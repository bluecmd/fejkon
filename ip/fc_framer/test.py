#/usr/bin/env/python3
"""Testbench for FC framing."""
import binascii
import cocotb
from cocotb.clock import Clock, Timer
from cocotb.drivers.avalon import AvalonMaster
from cocotb.monitors.avalon import AvalonSTPkts as AvalonSTMonitor
from cocotb.scoreboard import Scoreboard
from cocotb.triggers import RisingEdge

import fc


class Thing:
    """Commmon test logic for all tests."""

    def __init__(self, dut):
        self.dut = dut
        self.userrx = AvalonSTMonitor(dut, 'userrx', dut.rx_clk)
        self.tx_csr = AvalonMaster(dut, 'tx_mm', dut.tx_clk)
        self.rx_csr = AvalonMaster(dut, 'rx_mm', dut.rx_clk)
        self.expected_output = []
        self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.userrx, self.expected_output)

    @staticmethod
    async def new(dut):
        rx_clock = Clock(dut.rx_clk, 10, units='us')
        tx_clock = Clock(dut.tx_clk, 10, units='us')
        cocotb.fork(rx_clock.start())
        cocotb.fork(tx_clock.start())
        # Ensure the bus is in a known and quiet state before starting the monitors
        await Thing.reset(dut)
        return Thing(dut)

    @staticmethod
    async def reset(dut):
        dut.reset <= 1
        await Timer(50, units='us')
        dut.reset <= 0
        dut.avtx_ready <= 1
        dut.reset._log.info('Reset complete')


def with_control(b):
    """Append control for K,D,D,D format."""
    return bytes([0x8]) + b


def decode_symbol(b):
    if b[0] == 0x8:
        return fc.decode(b[1:])
    elif b[0] == 0x0:
        return '<DATA %s>' % (binascii.hexlify(b[1:]), )


def assert_symbol(value, symbol):
    value = value.value.buff
    assert value == symbol, 'value expected to be %s, is %s' % (decode_symbol(symbol), decode_symbol(value))


@cocotb.test()
async def test_reset_tx(dut):
    """Test the primitives sent after reset."""
    tb = await Thing.new(dut)
    await RisingEdge(dut.tx_clk)
    assert dut.avtx_valid == 1, 'avtx expected to be valid'
    assert_symbol(dut.avtx_data, with_control(fc.NOS))
    raise tb.scoreboard.result
