#!/usr/bin/env python3
"""Transaction testbench for Fejkon PCIe.

This test bench tests simplified behaviour of the PCIe TLP generation.
It is not as correct and detailed as a full PCIe endpoint simulation
(we have that as well in fejkon/test/pcie-hip/) but it is fast and easier
to debug. It also uses only open-source tools which is cool.
"""
import binascii
import cocotb
from cocotb.clock import Clock, Timer
from cocotb.drivers.avalon import AvalonSTPkts as AvalonSTDriver
from cocotb.drivers.avalon import AvalonMaster
from cocotb.monitors.avalon import AvalonSTPkts as AvalonSTMonitor
from cocotb.scoreboard import Scoreboard
from cocotb.triggers import RisingEdge, with_timeout

import pcie


class BaseTest:
    """Common test logic and resource for all tests."""

    def __init__(self, dut):
        self.dut = dut
        self.tlp_tx_st = AvalonSTMonitor(dut, 'tlp_tx_multiplexer_out', dut.clk)
        self.tlp_tx_recovered = AvalonSTMonitor(dut, 'tlp_tx_multiplexer_out', dut.clk,
                callback=self.tx_model)
        self.csr = AvalonMaster(dut, 'csr', dut.clk)
        self.expected_output = []
        self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.tlp_tx_st, self.expected_output)

    async def reset(self):
        self.dut.reset <= 1
        await Timer(50, units='ns')
        self.dut.reset <= 0
        await Timer(100, units='ns')
        self.dut.tlp_tx_multiplexer_out_ready <= 1
        self.dut.rx_st_bar <= 1
        self.dut.reset._log.debug('Reset complete')

    def expect_cmpld(self, address, data):
        exp = pcie.TLP()
        exp.completer_id = pcie.PcieId(bus=0xb3, device=0)
        exp.set_be(address, len(data))
        exp.fmt_type = pcie.TLP_CPL_DATA
        exp.set_data(data)
        exp.byte_count = len(data)
        self.expected_output.append(exp.intel_pack())

    def tx_model(self, transaction):
        """Log TLPs received from DUT."""
        tlp = pcie.TLP()
        tlp.intel_unpack(transaction)
        self.tlp_tx_recovered.log.info("TLP from DUT: " + repr(tlp))


class TestReadWrite(BaseTest):
    """Base class to test response to TLPs initiated by host."""

    def __init__(self, dut):
        super().__init__(dut)
        self.tlp_rx_st = AvalonSTDriver(dut, 'tlp_rx_st', dut.clk)
        self.tlp_rx_recovered = AvalonSTMonitor(dut, 'tlp_rx_st', dut.clk,
                callback=self.rx_model)

    def rx_model(self, transaction):
        """Log TLPs being set to DUT."""
        tlp = pcie.TLP()
        tlp.intel_unpack(transaction)
        self.tlp_rx_recovered.log.info("TLP to DUT: " + repr(tlp))


class TestC2H(BaseTest):
    """Base class to test TLPs emitted by C2H DMA."""

    def __init__(self, dut):
        super().__init__(dut)
        self.data_tx = AvalonSTDriver(dut, 'data_tx', dut.clk)


@cocotb.test()
async def test_unaligned_read(dut):
    """Test MemRead on a non-QWORD aligned address."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = TestReadWrite(dut)
    await tb.reset()
    tlp = pcie.TLP()
    tlp.fmt_type = pcie.TLP_MEM_READ
    tlp.set_be(addr=0x4, length=4)
    tb.expect_cmpld(0x4, binascii.unhexlify('deadbeef'))
    await with_timeout(tb.tlp_rx_st.send(tlp.intel_pack()), 100, 'ns')
    await Timer(100, 'ns')
    raise tb.scoreboard.result


@cocotb.test()
async def test_aligned_read(dut):
    """Test MemRead on a QWORD aligned address."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = TestReadWrite(dut)
    await tb.reset()
    tlp = pcie.TLP()
    tlp.fmt_type = pcie.TLP_MEM_READ
    tlp.set_be(addr=0x0, length=4)
    tb.expect_cmpld(0x0, binascii.unhexlify('02010de5'))
    await with_timeout(tb.tlp_rx_st.send(tlp.intel_pack()), 100, 'ns')
    await Timer(100, 'ns')
    raise tb.scoreboard.result


@cocotb.test()
async def test_read_write(dut):
    """Test scratch reg MemWrite / MemRead."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = TestReadWrite(dut)
    await tb.reset()
    tlp = pcie.TLP()
    tlp.fmt_type = pcie.TLP_MEM_WRITE
    tlp.set_be(addr=0xf00, length=4)
    tlp.set_data(binascii.unhexlify('f00fcafe'))
    await with_timeout(tb.tlp_rx_st.send(tlp.intel_pack()), 100, 'ns')
    tlp.fmt_type = pcie.TLP_MEM_READ
    tlp.set_be(addr=0xf00, length=4)
    tb.expect_cmpld(0xf00, binascii.unhexlify('f00fcafe'))
    await with_timeout(tb.tlp_rx_st.send(tlp.intel_pack()), 100, 'ns')
    await Timer(100, 'ns')
    raise tb.scoreboard.result


#@cocotb.test()
#async def test_c2h_dma(dut):
#    """Test C2H DMA."""
#    clock = Clock(dut.clk, 10, units='ns')
#    cocotb.fork(clock.start())
#    tb = TestC2H(dut)
#    await tb.reset()
#    payload = bytes([0,1,2,3,4,5,6,7])
#    await with_timeout(tb.data_tx.send(payload), 100, 'ns')
#    await RisingEdge(dut.clk)
#    cntr = await tb.csr.read(0x6) # csr_c2h_staging_counter
#    assert cntr == 1, 'expected csr_c2h_staging_counter to be incremented to 1'
#    await Timer(100, 'ns')
#    raise tb.scoreboard.result
