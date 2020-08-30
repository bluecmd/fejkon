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
from cocotb.utils import hexdump

import pcie


class BaseTest:
    def __init__(self, dut):
        self.dut = dut
        self.tlp_tx_st = AvalonSTMonitor(dut, 'tlp_tx_multiplexer_out', dut.clk)
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


class TestReadWrite(BaseTest):

    def __init__(self, dut):
        super().__init__(dut)
        self.tlp_rx_st = AvalonSTDriver(dut, 'tlp_rx_st', dut.clk)
        self.data_tx = AvalonSTDriver(dut, 'data_tx', dut.clk)
        self.tlp_rx_recovered = AvalonSTMonitor(dut, 'tlp_rx_st', dut.clk,
                callback=self.model)

    def model(self, transaction):
        """Model the DUT based on the input transaction."""
        tlp = pcie.TLP(transaction)
        exp = pcie.TLP()
        exp.completer_id = pcie.PcieId(bus=0xb3, device=0)
        exp.address = tlp.address
        exp.lower_address = tlp.lower_address
        if tlp.fmt_type == pcie.TLP_MEM_READ:
            if tlp.address == 0x4:
                exp.fmt_type = pcie.TLP_CPL_DATA
                exp.set_data(binascii.unhexlify('deadbeef'))
                exp.byte_count = 4
        self.expected_output.append(exp.pack())
        self.tlp_rx_recovered.log.info(hexdump(transaction))
        self.tlp_rx_recovered.log.info("Sent TLP: " + repr(tlp))
        self.tlp_rx_recovered.log.info("Expecting TLP: " + repr(exp))


@cocotb.test()
async def test_read_write(dut):
    """Test simple MemWrite / MemRead."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.fork(clock.start())
    tb = TestReadWrite(dut)
    await tb.reset()
    tlp = pcie.TLP()
    tlp.fmt_type = pcie.TLP_MEM_READ
    tlp.set_be(addr=0x4, length=4)
    await with_timeout(tb.tlp_rx_st.send(tlp.pack()), 100, 'ns')
    await Timer(100, 'ns')
    raise tb.scoreboard.result


#@cocotb.test()
#async def test_c2h_dma(dut):
#    """Test C2H DMA."""
#    clock = Clock(dut.clk, 10, units='ns')
#    cocotb.fork(clock.start())
#    tb = Thing(dut)
#    await tb.reset()
#    payload = bytes([0,1,2,3,4,5,6,7])
#    await with_timeout(tb.tlp_rx_st.send(payload), 100, 'ns')
#    payload = bytes([0,1,2,3,4,5,6,7])
#    await with_timeout(tb.data_tx.send(payload), 100, 'ns')
#    await RisingEdge(dut.clk)
#    cntr = await tb.csr.read(0x6) # csr_c2h_staging_counter
#    assert cntr == 1, 'expected csr_c2h_staging_counter to be incremented to 1'
#    await Timer(100, 'ns')
#    #raise tb.scoreboard.result

