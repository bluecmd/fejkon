#!/usr/bin/env python3
"""TODO(bluecmd): String here

Documentation
"""
import binascii
import logging as log
import math
import os
import unittest

import myhdl
from pcietb import pcie


class Error(Exception):
    """Catch-all local error class"""

class NoSuchBarError(Error):
    """An invalid BAR was addressed"""

class FejkonEP(pcie.Endpoint, pcie.MSICapability):
    """Fejkon card function model"""

    # pylint: disable=too-many-instance-attributes
    def __init__(self, clk):
        super(FejkonEP, self).__init__()
        self.clk = clk
        self.vendor_id = 0xf1c0
        self.device_id = 0x0de5
        self.msi_multiple_message_capable = 32
        self.msi_64bit_address_capable = 1
        self.msi_per_vector_mask_capable = 1
        # No I/O bars for now
        # self.register_rx_tlp_handler(pcie.TLP_IO_READ, self.handle_io_read_tlp)
        # self.register_rx_tlp_handler(pcie.TLP_IO_WRITE, self.handle_io_write_tlp)
        self.register_rx_tlp_handler(pcie.TLP_MEM_READ, self.handle_mem_read_tlp)
        self.register_rx_tlp_handler(pcie.TLP_MEM_READ_64, self.handle_mem_read_tlp)
        self.register_rx_tlp_handler(pcie.TLP_MEM_WRITE, self.handle_mem_write_tlp)
        self.register_rx_tlp_handler(pcie.TLP_MEM_WRITE_64, self.handle_mem_write_tlp)
        self.configure_bar(0, 0x80000, ext=False, prefetch=False, io=False)
        self.bar0_mm_address = myhdl.Signal(myhdl.intbv()[32:])
        self.bar0_mm_readdatavalid = myhdl.Signal(myhdl.intbv())
        self.bar0_mm_readdata = myhdl.Signal(myhdl.intbv()[32:])
        self.bar0_mm_read = myhdl.Signal(myhdl.intbv())
        self.bar0_mm_write = myhdl.Signal(myhdl.intbv())
        self.bar0_mm_writedata = myhdl.Signal(myhdl.intbv()[32:])
        self.bar0_mm_waitrequest = myhdl.Signal(myhdl.intbv())
        self.rx_st_data = myhdl.Signal(myhdl.intbv()[256:])
        self.rx_st_empty = myhdl.Signal(myhdl.intbv()[2:])
        self.rx_st_error = myhdl.Signal(myhdl.intbv())
        self.rx_st_startofpacket = myhdl.Signal(myhdl.intbv())
        self.rx_st_endofpacket = myhdl.Signal(myhdl.intbv())
        self.rx_st_ready = myhdl.Signal(myhdl.intbv())
        self.rx_st_valid = myhdl.Signal(myhdl.intbv())
        self.tx_st_data = myhdl.Signal(myhdl.intbv()[256:])
        self.tx_st_startofpacket = myhdl.Signal(myhdl.intbv())
        self.tx_st_endofpacket = myhdl.Signal(myhdl.intbv())
        self.tx_st_error = myhdl.Signal(myhdl.intbv())
        self.tx_st_empty = myhdl.Signal(myhdl.intbv()[2:])
        self.tx_st_ready = myhdl.Signal(myhdl.intbv())
        self.tx_st_valid = myhdl.Signal(myhdl.intbv())
        self.rx_st_bar = myhdl.Signal(myhdl.intbv()[8:])
        self.rx_st_mask = myhdl.Signal(myhdl.intbv())
        self.data_tx_data = myhdl.Signal(myhdl.intbv()[256:])
        self.data_tx_valid = myhdl.Signal(myhdl.intbv())
        self.data_tx_ready = myhdl.Signal(myhdl.intbv())
        self.data_tx_channel = myhdl.Signal(myhdl.intbv()[2:])
        self.data_tx_endofpacket = myhdl.Signal(myhdl.intbv())
        self.data_tx_startofpacket = myhdl.Signal(myhdl.intbv())
        self.data_tx_empty = myhdl.Signal(myhdl.intbv()[5:])

    def handle_mem_read_tlp(self, tlp):
        """Handle ordinary 32 and 64 bit memory read TLPs"""
        log.info("Got read TLP: %s", tlp)
        log.info("Match BAR: %s", self.match_bar(tlp.address))
        bars = self.match_bar(tlp.address)
        if len(bars) != 1:
            raise NoSuchBarError(tlp.address)
        bar = bars[0]

        if self.rx_st_ready != 1:
            val = yield self.rx_st_ready.posedge, myhdl.delay(1000)
            if not val:
                raise Exception("Timeout waiting for rx_st_ready")

        dws = tlp.pack()
        frames = int(math.ceil(len(dws)/8.0))
        # Pad to 32 word alignment
        empty_dws = 8 - len(dws) % 8
        dws.extend([0]*(empty_dws))
        yield self.clk.posedge
        self.rx_st_bar = bar
        for i in range(frames):
            # This is only >0 on the last frame
            last = (i == frames-1)
            first = (i == 0)
            self.rx_st_data.next = (
                dws[i+7] << 224 | dws[i+6] << 192 | dws[i+5] << 160 |
                dws[i+4] << 128 | dws[i+3] << 96 | dws[i+2] << 64 |
                dws[i+1] << 32 | dws[i])
            self.rx_st_empty.next = empty_dws // 2 if last else 0
            self.rx_st_error.next = 0
            self.rx_st_startofpacket.next = first
            self.rx_st_endofpacket.next = last
            self.rx_st_valid.next = 1
            yield self.clk.posedge

        self.rx_st_valid.next = 0
        # Clean up some signals to make things look neat
        self.rx_st_startofpacket.next = 0
        self.rx_st_endofpacket.next = 0
        self.rx_st_empty.next = 0
        self.rx_st_bar = 0

        val = yield self.tx_st_valid.posedge, myhdl.delay(1000)
        if not val:
            raise Exception("Timeout waiting for CplD")
        yield self.clk.posedge

        # TODO(bluecmd): This is supposed to be in the dut
        #_, addr = bar
        #data = bytearray(tlp.length*4)
        #m = 0
        #n = 0
        #addr = tlp.address+tlp.get_first_be_offset()
        #dw_length = tlp.length
        #byte_length = tlp.get_be_byte_count()

        #while m < dw_length:
        #    cpl = pcie.TLP()
        #    cpl.set_completion_data(tlp, self.get_id())

        #    cpl_dw_length = dw_length - m
        #    cpl_byte_length = byte_length - n
        #    cpl.byte_count = cpl_byte_length
        #    if cpl_dw_length > 32 << self.max_payload_size:
        #        cpl_dw_length = 32 << self.max_payload_size # max payload size
        #        cpl_dw_length -= (addr & 0x7c) >> 2 # RCB align

        #    cpl.lower_address = addr & 0x7f

        #    cpl.set_data(data[m*4:(m+cpl_dw_length)*4])
        #    # logging
        #    yield from self.send(cpl)
        #    m += cpl_dw_length
        #    n += cpl_dw_length*4 - (addr&3)
        #    addr += cpl_dw_length*4 - (addr&3)


    def handle_mem_write_tlp(self, tlp):
        log.info("Got write TLP: %s", tlp)
        log.info("Match BAR: %s", self.match_bar(tlp.address))
        # TODO: Not implemented

def testcase(*blocks):
    """Runs a decorated function as a block in MyHDL.

    Arguments:
      *blocks: Any argument given is a function to create other blocks
    """
    def inner(func):
        def block(self):
            def run_and_stop():
                yield from func(self)
                raise myhdl.StopSimulation
            insts = [x(self, func) for x in blocks] + [run_and_stop()]
            sim = myhdl.Simulation(insts)
            sim.run(quiet=1)
        return block
    return inner

class Test(unittest.TestCase):
    """Collection of PCIe test cases"""

    def setUp(self):
        self.clk = myhdl.Signal(bool(0))
        self.rst = myhdl.Signal(bool(0))
        # PCIe devices
        rc = pcie.RootComplex()
        ep = FejkonEP(self.clk)
        dev = pcie.Device(ep)
        rc.make_port().connect(dev)
        sw = pcie.Switch()
        rc.make_port().connect(sw)
        self.rc = rc
        self.ep = ep
        self.sw = sw

    # === MyHDL instances ===
    # MyHDL instances that can be enable to co-execute alongside the test case
    # These are processes that may or may not be included depending on if that
    # signal is required for a particular test case.
    # dutgen and clkgen is probably always required.

    def clkgen(self, unused_test):
        @myhdl.always(myhdl.delay(2))
        def block():
            self.clk.next = not self.clk
        return block

    def dutgen(self, test):
        # This is because icarus does not allow changing the dumpfile in
        # a nice way
        op = os.getcwd()
        np = os.path.join(op, test.__name__)
        os.makedirs(np, exist_ok=True)
        os.chdir(np)
        ret = myhdl.Cosimulation(
            "vvp -m myhdl ../test.vvp -fst",
            clk=self.clk,
            reset=self.rst,
            bar0_mm_address=self.ep.bar0_mm_address,
            bar0_mm_readdatavalid=self.ep.bar0_mm_readdatavalid,
            bar0_mm_readdata=self.ep.bar0_mm_readdata,
            bar0_mm_read=self.ep.bar0_mm_read,
            bar0_mm_write=self.ep.bar0_mm_write,
            bar0_mm_writedata=self.ep.bar0_mm_writedata,
            bar0_mm_waitrequest=self.ep.bar0_mm_waitrequest,
            rx_st_data=self.ep.rx_st_data,
            rx_st_empty=self.ep.rx_st_empty,
            rx_st_error=self.ep.rx_st_error,
            rx_st_startofpacket=self.ep.rx_st_startofpacket,
            rx_st_endofpacket=self.ep.rx_st_endofpacket,
            rx_st_ready=self.ep.rx_st_ready,
            rx_st_valid=self.ep.rx_st_valid,
            rx_st_bar=self.ep.rx_st_bar,
            rx_st_mask=self.ep.rx_st_mask,
            tx_st_data=self.ep.tx_st_data,
            tx_st_startofpacket=self.ep.tx_st_startofpacket,
            tx_st_endofpacket=self.ep.tx_st_endofpacket,
            tx_st_error=self.ep.tx_st_error,
            tx_st_empty=self.ep.tx_st_empty,
            tx_st_ready=self.ep.tx_st_ready,
            tx_st_valid=self.ep.tx_st_valid,
            data_tx_data=self.ep.data_tx_data,
            data_tx_valid=self.ep.data_tx_valid,
            data_tx_ready=self.ep.data_tx_ready,
            data_tx_channel=self.ep.data_tx_channel,
            data_tx_endofpacket=self.ep.data_tx_endofpacket,
            data_tx_startofpacket=self.ep.data_tx_startofpacket,
            data_tx_empty=self.ep.data_tx_empty)
        os.chdir(op)
        return ret

    # === End of MyHDL instances ===

    def reset(self):
        yield myhdl.delay(10)
        self.rst.next = 1
        yield myhdl.delay(10)
        self.rst.next = 0
        yield myhdl.delay(10)
        yield from self.rc.enumerate(enable_bus_mastering=True, configure_msi=True)

    @testcase(clkgen, dutgen)
    def test_identity(self):
        # TODO
        yield from self.reset()
        bar0 = self.ep.bar[0]
        ident = yield from self.rc.mem_read(bar0, 4)
        assert self.ep.bar0_mm_address > 0
        log.info("Identity: %s", binascii.hexlify(ident))

    @testcase(clkgen, dutgen)
    def test_dma(self):
        # TODO
        yield from self.reset()
        bar0 = self.ep.bar[0]
        ident = yield from self.rc.mem_read(bar0, 4)
        assert self.ep.bar0_mm_address > 0


if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    log.basicConfig(
        level=log.DEBUG,
        format='[%(asctime)-15s] %(funcName)-15s %(levelname)-8s %(message)s')
    unittest.main()
