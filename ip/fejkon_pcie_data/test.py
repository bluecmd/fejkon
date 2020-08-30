#!/usr/bin/env python3
"""Transaction testbench for Fejkon PCIe.

This test bench tests simplified behaviour of the PCIe TLP generation.
It is not as correct and detailed as a full PCIe endpoint simulation
(we have that as well in fejkon/test/pcie-hip/) but it is fast and easier
to debug. It also uses only open-source tools which is cool.
"""
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
        self.tlp_rx_st = AvalonSTDriver(dut, 'tlp_rx_st', dut.clk)
        self.tlp_tx_st = AvalonSTMonitor(dut, 'tlp_tx_multiplexer_out', dut.clk)
        self.data_tx = AvalonSTDriver(dut, 'data_tx', dut.clk)
        self.csr = AvalonMaster(dut, 'csr', dut.clk)
        self.tlp_rx_recovered = AvalonSTMonitor(dut, 'tlp_rx_st', dut.clk,
                callback=self.model)
        self.expected_output = []
        #self.scoreboard = Scoreboard(dut)
        #self.scoreboard.add_interface(self.tlp_tx_st, self.expected_output)

    def model(self, transaction):
        """Model the DUT based on the input transaction."""
        #self.expected_output.append(transaction)
        self.tlp_rx_recovered.log.info(hexdump(transaction))

    async def reset(self):
        self.dut.reset <= 1
        await Timer(50, units='ns')
        self.dut.reset <= 0
        await Timer(100, units='ns')
        self.dut.tlp_tx_multiplexer_out_ready <= 1
        self.dut.reset._log.debug('Reset complete')


@cocotb.test()
async def test_read_write(dut):
    """Test simple MemWrite / MemRead."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = Thing(dut)
    await tb.reset()
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.tlp_rx_st.send(payload), 100, 'ns')
    await Timer(100, 'ns')
    #raise tb.scoreboard.result

@cocotb.test()
async def test_c2h_dma(dut):
    """Test C2H DMA."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = Thing(dut)
    await tb.reset()
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.tlp_rx_st.send(payload), 100, 'ns')
    payload = bytes([0,1,2,3,4,5,6,7])
    await with_timeout(tb.data_tx.send(payload), 100, 'ns')
    await RisingEdge(dut.clk)
    cntr = await tb.csr.read(0x6) # csr_c2h_staging_counter
    assert cntr == 1, 'expected csr_c2h_staging_counter to be incremented to 1'
    await Timer(100, 'ns')
    #raise tb.scoreboard.result

