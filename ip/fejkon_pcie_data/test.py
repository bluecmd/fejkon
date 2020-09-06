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
from cocotb.regression import TestFactory
from cocotb.scoreboard import Scoreboard
from cocotb.triggers import RisingEdge, with_timeout

import pcie

DMA_WND_START = 0x1000
DMA_WND_END   = 0x5000
DMA_WND_SIZE  = 4


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

    def expect_memwrite(self, address, data):
        exp = pcie.TLP()
        exp.requester_id = pcie.PcieId(bus=0xb3, device=0)
        exp.set_be(address, len(data))
        exp.fmt_type = pcie.TLP_MEM_WRITE
        exp.set_data(data)
        exp.byte_count = len(data)
        self.expected_output.append(exp.intel_pack())

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


@cocotb.coroutine
async def run_c2h_dma_test(dut, dwords, channel):
    """Test C2H DMA."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = TestC2H(dut)
    await tb.reset()
    # Wait for my_id_valid
    await Timer(100, 'ns')
    payload = bytearray()
    for i in range(dwords * 4):
        payload.append(i % 256)
    payload = bytes(payload)
    header = int.to_bytes(0x4 + ((len(payload) // 4) << 4) + (channel << 14), length=4, byteorder='big')
    header = header + bytes(12)
    # TODO: Fragmentation is not implemented, so expect truncated packets
    tb.expect_memwrite(DMA_WND_START, header + payload[:224])
    await with_timeout(tb.data_tx.send(payload, channel=channel), 1000, 'ns')
    await RisingEdge(dut.clk)
    cntr = await tb.csr.read(0x6) # csr_c2h_staging_counter
    assert cntr == 1, 'expected csr_c2h_staging_counter to be incremented to 1'
    await Timer(1000, 'ns')
    assert tb.dut.irq_c2h_avail == 1, 'expected irq_c2h_avail to be high'
    wptr = await tb.csr.read(0x2b) # c2h_dma_card_write_ptr
    await tb.csr.write(0x2a, wptr) # c2h_dma_host_read_ptr
    await Timer(100, 'ns')
    assert tb.dut.irq_c2h_avail == 0, 'expected irq_c2h_avail to be reset'
    raise tb.scoreboard.result


c2h_factory = TestFactory(run_c2h_dma_test)
# TODO:
# - Add packet fragmentation
c2h_factory.add_option('dwords', [3, 8, 15, 16, 100, 512])
c2h_factory.add_option('channel', [0, 3])
c2h_factory.generate_tests()


@cocotb.test()
async def test_c2h_dma_pressure(dut):
    """Test C2H DMA pressure."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = TestC2H(dut)
    channel = 2
    await tb.reset()
    # my_id_valid is not high yet so the first packet will be missed, which
    # is an accident in this testbench, but a behavior we want to test so
    # it has been incorporated for now. See if i > 1 down below.
    for i in range(30):
        payload = bytearray()
        for j in range(10 * 4):
            payload.append(j % 256)
        payload = bytes(payload)
        header = int.to_bytes(0x4 + ((len(payload) // 4) << 4) + (channel << 14), length=4, byteorder='big')
        header = header + bytes(12)
        if i > 0:
            # See comment above for explaination
            tb.expect_memwrite(DMA_WND_START + 4096 * ((i-1) % DMA_WND_SIZE), header + payload)
        await with_timeout(tb.data_tx.send(payload, channel=channel), 1000, 'ns')
    await RisingEdge(dut.clk)
    cntr = await tb.csr.read(0x6) # csr_c2h_staging_counter
    assert cntr == i + 1, 'expected csr_c2h_staging_counter to be incremented to %s' % (i + 1, )
    await Timer(1000, 'ns')
    raise tb.scoreboard.result
