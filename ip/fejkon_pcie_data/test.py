#!/usr/bin/env python
from pcietb import pcie
import logging
import myhdl
import unittest

import os
import sys


log = logging.getLogger(__name__)

# TODO(bluecmd): Remove the code below, I kept it to test the layout
# Until I actually remove it, credit goes to https://github.com/alexforencich/verilog-pcie

class FakeEP(pcie.MemoryEndpoint, pcie.MSICapability):
    def __init__(self, *args, **kwargs):
        super(FakeEP, self).__init__(*args, **kwargs)

        self.vendor_id = 0x1234
        self.device_id = 0x5678

        self.msi_multiple_message_capable = 5
        self.msi_64bit_address_capable = 1
        self.msi_per_vector_mask_capable = 1

        self.add_mem_region(1024)
        self.add_prefetchable_mem_region(1024*1024)
        self.add_io_region(32)

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

class TestFejkonDataFacility(unittest.TestCase):

    def setUp(self):
        self.clk = myhdl.Signal(bool(0))
        self.rst = myhdl.Signal(bool(0))
        # PCIe devices
        rc = pcie.RootComplex()
        ep = FakeEP()
        dev = pcie.Device(ep)
        rc.make_port().connect(dev)
        sw = pcie.Switch()
        rc.make_port().connect(sw)
        self.rc = rc
        self.ep = ep
        self.sw = sw

    def clkgen(self, test):
        @myhdl.always(myhdl.delay(2))
        def block():
            self.clk.next = not self.clk
        return block

    def reset(self):
        yield myhdl.delay(100)
        yield self.clk.posedge
        self.rst.next = 1
        yield self.clk.posedge
        self.rst.next = 0
        yield self.clk.posedge
        yield myhdl.delay(100)
        yield self.clk.posedge
        yield self.clk.posedge
        yield from self.rc.enumerate(enable_bus_mastering=True, configure_msi=True)

    @testcase(clkgen)
    def testEnumeration(self):
        yield from self.reset()
        for k in range(6):
            log.debug("0x%08x / 0x%08x" %(self.ep.bar[k], self.ep.bar_mask[k]))

        log.debug(self.sw.upstream_bridge.pri_bus_num)
        log.debug(self.sw.upstream_bridge.sec_bus_num)
        log.debug(self.sw.upstream_bridge.sub_bus_num)
        log.debug("0x%08x" % self.sw.upstream_bridge.io_base)
        log.debug("0x%08x" % self.sw.upstream_bridge.io_limit)
        log.debug("0x%08x" % self.sw.upstream_bridge.mem_base)
        log.debug("0x%08x" % self.sw.upstream_bridge.mem_limit)
        log.debug("0x%016x" % self.sw.upstream_bridge.prefetchable_mem_base)
        log.debug("0x%016x" % self.sw.upstream_bridge.prefetchable_mem_limit)

    @testcase(clkgen)
    def testIO(self):
        yield from self.reset()
        yield from self.rc.io_write(0x80000000, bytearray(range(16)), 1000)
        assert self.ep.read_region(3, 0, 16) == bytearray(range(16))

        val = yield from self.rc.io_read(0x80000000, 16, 1000)
        assert val == bytearray(range(16))

        yield from self.rc.mem_write(0x80000000, bytearray(range(16)), 1000)
        yield myhdl.delay(100)
        assert self.ep.read_region(0, 0, 16) == bytearray(range(16))

        val = yield from self.rc.mem_read(0x80000000, 16, 1000)
        assert val == bytearray(range(16))

        yield from self.rc.mem_write(0x8000000000000000, bytearray(range(16)), 1000)
        yield myhdl.delay(1000)
        assert self.ep.read_region(1, 0, 16) == bytearray(range(16))

        val = yield from self.rc.mem_read(0x8000000000000000, 16, 1000)
        assert val == bytearray(range(16))

    @testcase(clkgen)
    def testLargeIO(self):
        yield from self.reset()
        yield from self.rc.mem_write(0x8000000000000000, bytearray(range(256))*32, 100)
        yield myhdl.delay(1000)
        assert self.ep.read_region(1, 0, 256*32) == bytearray(range(256))*32

        val = yield from self.rc.mem_read(0x8000000000000000, 256*32, 100)
        assert val == bytearray(range(256))*32

    @testcase(clkgen)
    def testRootMemory(self):
        yield from self.reset()
        mem_base, mem_data = self.rc.alloc_region(1024*1024)
        io_base, io_data = self.rc.alloc_io_region(1024)

        yield from self.rc.io_write(io_base, bytearray(range(16)))
        assert io_data[0:16] == bytearray(range(16))

        val = yield from self.rc.io_read(io_base, 16)
        assert val == bytearray(range(16))

        yield from self.rc.mem_write(mem_base, bytearray(range(16)))
        assert mem_data[0:16] == bytearray(range(16))

        val = yield from self.rc.mem_read(mem_base, 16)
        assert val == bytearray(range(16))

    @testcase(clkgen)
    def testDeviceToDeviceDMA(self):
        ep2 = FakeEP()
        dev2 = pcie.Device(ep2)
        self.sw.make_port().connect(dev2)

        yield from self.reset()
        yield from self.ep.io_write(0x80001000, bytearray(range(16)), 10000)
        assert ep2.read_region(3, 0, 16) == bytearray(range(16))

        val = yield from self.ep.io_read(0x80001000, 16, 10000)
        assert val == bytearray(range(16))

        yield from self.ep.mem_write(0x80100000, bytearray(range(16)), 10000)
        yield myhdl.delay(1000)
        assert ep2.read_region(0, 0, 16) == bytearray(range(16))

        val = yield from self.ep.mem_read(0x80100000, 16, 10000)
        assert val == bytearray(range(16))

        yield from self.ep.mem_write(0x8000000000100000, bytearray(range(16)), 10000)
        yield myhdl.delay(1000)
        assert ep2.read_region(1, 0, 16) == bytearray(range(16))

        val = yield from self.ep.mem_read(0x8000000000100000, 16, 10000)
        assert val == bytearray(range(16))

    @testcase(clkgen)
    def testDeviceToRootDMA(self):
        yield from self.reset()
        mem_base, mem_data = self.rc.alloc_region(1024*1024)
        io_base, io_data = self.rc.alloc_io_region(1024)
        yield from self.ep.io_write(io_base, bytearray(range(16)), 1000)
        assert io_data[0:16] == bytearray(range(16))

        val = yield from self.ep.io_read(io_base, 16, 1000)
        assert val == bytearray(range(16))

        yield from self.ep.mem_write(mem_base, bytearray(range(16)), 1000)
        yield myhdl.delay(1000)
        assert mem_data[0:16] == bytearray(range(16))

        val = yield from self.ep.mem_read(mem_base, 16, 1000)
        assert val == bytearray(range(16))

    @testcase(clkgen)
    def testMSI(self):
        yield from self.reset()
        yield from self.ep.issue_msi_interrupt(4)
        yield self.rc.msi_get_signal(self.ep.get_id(), 4)
        yield myhdl.delay(100)

if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    logging.basicConfig(
            level=logging.DEBUG,
            format='[%(asctime)-15s] %(funcName)-15s %(levelname)-8s %(message)s')
    unittest.main()

