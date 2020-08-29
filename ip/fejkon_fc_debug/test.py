import binascii
import random
import cocotb
from cocotb.clock import Clock, Timer
from cocotb.drivers.avalon import AvalonSTPkts as AvalonSTDriver
from cocotb.drivers.avalon import AvalonMaster
from cocotb.monitors.avalon import AvalonSTPkts as AvalonSTMonitor
from cocotb.scoreboard import Scoreboard
from cocotb.triggers import FallingEdge, RisingEdge, with_timeout
from cocotb.utils import hexdump

class Thing:

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

    def model(self, transaction):
        """Model the DUT based on the input transaction."""
        self.expected_output.append(transaction)
        self.st_in_recovered.log.info(hexdump(transaction))

    async def reset(self):
        self.dut.reset <= 1
        await Timer(50, units='us')
        self.dut.reset <= 0
        self.dut.st_out_ready <= 1
        self.dut.reset._log.debug('Reset complete')

@cocotb.test()
async def test_passthrough(dut):
    """Test traffic passthrough."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = Thing(dut)
    await tb.reset()
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    payload = bytes([8,8,8,8,8,8,8,8])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    payload = bytes([9,9,9,9,9,9,9,9])
    await Timer(100, 'us')
    raise tb.scoreboard.result

@cocotb.test()
async def test_mixing(dut):
    """Test traffic mixing."""
    clock = Clock(dut.clk, 10, units='us')
    cocotb.fork(clock.start())
    tb = Thing(dut)
    await tb.reset()
    await tb.csr.write(0, 1)
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    payload = bytes([8,8,8,8,8,8,8,8])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    payload = bytes([9,9,9,9,9,9,9,9])
    await with_timeout(tb.st_in.send(payload, sync=False), 100, 'us')
    # Leave one slot for a generator package set
    tb.expected_output.append(
            binascii.unhexlify('deadbeef')*8 +
            binascii.unhexlify('baadc0de')*8)
    await tb.csr.write(0, 0)
    payload = bytes([1,1,1,1,1,1,1,1])
    await with_timeout(tb.st_in.send(payload), 100, 'us')
    await FallingEdge(dut.clk)
    raise tb.scoreboard.result
