#!/usr/bin/env python3
"""Transaction testbench for Fejkon FC Debug.

This testbench ensures that the FC debug component can both pass traffic
but also generate test traffic at high speed.
"""
import binascii
import cocotb
from cocotb.clock import Clock, Timer
from cocotb.drivers.avalon import AvalonSTPkts as AvalonSTDriver
from cocotb.drivers.avalon import AvalonMaster
from cocotb.monitors.avalon import AvalonSTPkts as AvalonSTMonitor
from cocotb.scoreboard import Scoreboard
from cocotb.triggers import FallingEdge, RisingEdge, with_timeout
from cocotb.utils import hexdump


PAYLOAD = (
        binascii.unhexlify('bcb5565605060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1fff') +
        binascii.unhexlify('baadc0de')*7 + binascii.unhexlify('bc95d5d5'))

class Thing:
    """Commmon test logic for all tests."""

    def __init__(self, dut):
        self.dut = dut
        self.st_in = AvalonSTDriver(dut, 'st_in', dut.clk)
        self.st_out = AvalonSTMonitor(dut, 'st_out', dut.clk)
        self.csr = AvalonMaster(dut, 'csr', dut.clk)
        self.st_in_recovered = AvalonSTMonitor(dut, 'st_in', dut.clk,
                callback=self.model)
        self.expected_output = []
        self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.st_out, self.expected_output)

    @staticmethod
    async def new(dut):
        # Ensure the bus is in a known and quiet state before starting the monitors
        await Thing.reset(dut)
        return Thing(dut)

    @staticmethod
    async def reset(dut):
        dut.reset <= 1
        await Timer(50, units='us')
        dut.reset <= 0
        dut.st_out_ready <= 1
        dut.reset._log.debug('Reset complete')

    def model(self, transaction):
        """Model the DUT based on the input transaction."""
        self.expected_output.append(transaction)
        self.st_in_recovered.log.info(hexdump(transaction))


@cocotb.coroutine
async def flaky_ready(dut):
    # Ensure the generator respects _ready
    while True:
        dut.st_out_ready <= 0
        await RisingEdge(dut.clk)
        dut.st_out_ready <= 1
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)


@cocotb.test()
async def test_passthrough(dut):
    """Test traffic passthrough."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = await Thing.new(dut)
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    payload = bytes([8,8,8,8,8,8,8,8])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    payload = bytes([9,9,9,9,9,9,9,9])
    await Timer(100, 'us')
    raise tb.scoreboard.result

@cocotb.test()
async def test_single_generator(dut):
    """Test traffic generator for exactly one packet."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = await Thing.new(dut)
    await tb.csr.write(0, 1)
    cocotb.fork(flaky_ready(dut))
    tb.expected_output.append(PAYLOAD)
    await Timer(100, units='us')
    cntr = await tb.csr.read(0)
    assert cntr == 0, 'generator should have been zero'
    raise tb.scoreboard.result

@cocotb.test()
async def test_generator(dut):
    """Test traffic generator."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = await Thing.new(dut)
    await tb.csr.write(0, 10)
    cocotb.fork(flaky_ready(dut))
    for _ in range(10):
        tb.expected_output.append(PAYLOAD)
    await Timer(800, units='us')
    cntr = await tb.csr.read(0)
    assert cntr == 0, 'generator should have been zero'
    raise tb.scoreboard.result

@cocotb.test()
async def test_inf_generator(dut):
    """Test infinite traffic generator."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = await Thing.new(dut)
    await tb.csr.write(0, 2**32 - 1)
    for _ in range(10):
        tb.expected_output.append(PAYLOAD)
    await Timer(200, units='us')
    cntr = await tb.csr.read(0)
    assert cntr == 2**32-1, 'generator should have been 2**32 - 1'
    raise tb.scoreboard.result

@cocotb.test()
async def test_mixing(dut):
    """Test traffic mixing."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = await Thing.new(dut)
    cocotb.fork(flaky_ready(dut))
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    cocotb.fork(tb.csr.write(0, 100))
    payload = bytes([8,8,8,8,8,8,8,8])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    payload = bytes([9,9,9,9,9,9,9,9])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    await RisingEdge(dut.clk)
    tb.expected_output.append(PAYLOAD)
    await tb.csr.write(0, 0)
    payload = bytes([1,1,1,1,1,1,1,1])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    raise tb.scoreboard.result

@cocotb.test()
async def test_fast_mixing(dut):
    """Test back-to-back traffic mixing."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = await Thing.new(dut)
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    cocotb.fork(tb.csr.write(0, 100))
    payload = bytes([8,8,8,8,8,8,8,8])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    payload = bytes([9,9,9,9,9,9,9,9])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    # Leave one slot for a generator package set
    tb.expected_output.append(PAYLOAD)
    await tb.csr.write(0, 0)
    payload = bytes([1,1,1,1,1,1,1,1])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    raise tb.scoreboard.result
