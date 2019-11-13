#!/usr/bin/env python3
from pcietb import pcie

import binascii
import logging
import myhdl
import os
import sys
import unittest


log = logging.getLogger(__name__)


class Error(Exception):
    pass

class NoSuchBarError(Error):
    pass

class FejkonEP(pcie.Endpoint, pcie.MSICapability):
    def __init__(self, dut):
        super(FejkonEP, self).__init__()
        self.dut = dut
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

    def handle_mem_read_tlp(self, tlp):
        log.info("Got read TLP: %s", tlp)
        log.info("Match BAR: %s", self.match_bar(tlp.address))
        bars = self.match_bar(tlp.address)
        if len(bars) != 1:
            raise NoSuchBarError(tlp.address)
        bar, = bars

        # TODO(bluecmd): This is supposed to be in the dut
        region = bar[0]
        addr = bar[1]
        data = bytearray(tlp.length*4)
        m = 0
        n = 0
        addr = tlp.address+tlp.get_first_be_offset()
        dw_length = tlp.length
        byte_length = tlp.get_be_byte_count()

        while m < dw_length:
            cpl = pcie.TLP()
            cpl.set_completion_data(tlp, self.get_id())

            cpl_dw_length = dw_length - m
            cpl_byte_length = byte_length - n
            cpl.byte_count = cpl_byte_length
            if cpl_dw_length > 32 << self.max_payload_size:
                cpl_dw_length = 32 << self.max_payload_size # max payload size
                cpl_dw_length -= (addr & 0x7c) >> 2 # RCB align

            cpl.lower_address = addr & 0x7f

            cpl.set_data(data[m*4:(m+cpl_dw_length)*4])
            # logging
            yield from self.send(cpl)
            m += cpl_dw_length;
            n += cpl_dw_length*4 - (addr&3)
            addr += cpl_dw_length*4 - (addr&3)


    def handle_mem_write_tlp(self, tlp):
        log.info("Got write TLP: %s", tlp)
        log.info("Match BAR: %s", self.match_bar(tlp.address))
        # TODO: Not implemented

def testcase(*blocks):
    """Runs a decorated function as a block in MyHDL.

    Arguments:
      *blocks: Any argument given is a function to create other blocks
    """
    def inner(f):
        def w(self):
            def rf():
                yield from f(self)
                raise myhdl.StopSimulation
            insts = [x(self, f) for x in blocks] + [f(self)]
            sim = myhdl.Simulation([x(self, f) for x in blocks] + [rf()])
            sim.run(quiet=1)
        return w
    return inner

class Test(unittest.TestCase):

    def setUp(self):
        self.clk = myhdl.Signal(bool(0))
        self.rst = myhdl.Signal(bool(0))

        self.bar2_mm_address = myhdl.Signal(myhdl.intbv(0)[31:])

        self.dut = myhdl.Cosimulation(
                "vvp -m myhdl test.vvp -fst",
                clk=self.clk,
                reset=self.rst,
                bar2_mm_address=self.bar2_mm_address)

        # PCIe devices
        rc = pcie.RootComplex()
        ep = FejkonEP(self.dut)
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

    def clkgen(self, test):
        @myhdl.always(myhdl.delay(2))
        def block():
            self.clk.next = not self.clk
        return block

    def dutgen(self, test):
        return self.dut

    # === End of MyHDL instances ===

    def reset(self):
        yield myhdl.delay(10)
        self.rst.next = 1
        yield myhdl.delay(10)
        self.rst.next = 0
        yield myhdl.delay(10)
        yield from self.rc.enumerate(enable_bus_mastering=True, configure_msi=True)

    @testcase(clkgen, dutgen)
    def testCosim(self):
        yield from self.reset()
        bar0 = self.ep.bar[0]
        ident = yield from self.rc.mem_read(bar0, 4)
        assert self.bar2_mm_address > 0
        log.info("Identity: %s", binascii.hexlify(ident))


if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    logging.basicConfig(
            level=logging.DEBUG,
            format='[%(asctime)-15s] %(funcName)-15s %(levelname)-8s %(message)s')
    unittest.main()

