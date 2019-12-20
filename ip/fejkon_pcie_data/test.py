#!/usr/bin/env python3
"""TODO(bluecmd): String here

Documentation
"""
import logging as log
import os
import unittest

import myhdl
from pcietb import pcie
import test_ep

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
        ep = test_ep.FejkonEP(self.clk)
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
        """Cosimulation of actual Verilog code"""
        # This is because icarus does not allow changing the dumpfile in
        # a nice way
        oldpath = os.getcwd()
        newpath = os.path.join(oldpath, test.__name__)
        os.makedirs(newpath, exist_ok=True)
        os.chdir(newpath)
        ret = myhdl.Cosimulation(
            "vvp -m myhdl ../test.vvp -fst",
            clk=self.clk,
            reset=self.rst,
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
            data_tx_empty=self.ep.data_tx_empty,
            tl_cfg_add=self.ep.tl_cfg_add,
            tl_cfg_ctl=self.ep.tl_cfg_ctl,
            tl_cfg_sts=self.ep.tl_cfg_sts)
        os.chdir(oldpath)
        return ret

    # === End of MyHDL instances ===

    def reset(self):
        yield myhdl.delay(10)
        self.ep.reset()
        self.rst.next = 1
        yield myhdl.delay(10)
        self.rst.next = 0
        yield myhdl.delay(10)
        yield from self.rc.enumerate(enable_bus_mastering=True, configure_msi=True)

    def await_tx(self):
        """Called to prevent multiple TX to be called at the same time."""
        # Bug workaround for MyHDL
        while not self.ep.tx_sem.acquire(blocking=False):
            yield myhdl.delay(100)

    # TODO(bluecmd): we don't test 64 bit operations currently
    @testcase(clkgen, dutgen)
    def test_read(self):
        """Test reading standard 4 byte reads."""
        yield from self.reset()
        bar0 = self.ep.bar[0]
        ident_raw = yield from self.rc.mem_read(bar0, 4)
        ident = int.from_bytes(ident_raw, byteorder='little', signed=False)
        githash_raw = yield from self.rc.mem_read(bar0 + 4, 4)
        githash = int.from_bytes(githash_raw, byteorder='little', signed=False)
        self.assertEqual(ident, 0x02010de5)
        self.assertEqual(githash, 0xdeadbeef)

    @testcase(clkgen, dutgen)
    def test_too_small_read(self):
        """Test reading 3 bytes, should fail."""
        yield from self.reset()
        bar0 = self.ep.bar[0]
        with self.assertRaises(pcie.UnsuccessfulCompletionError):
            _ = yield from self.rc.mem_read(bar0, 3)

    @testcase(clkgen, dutgen)
    def test_too_large_read(self):
        """Test reading 1024 bytes, should fail."""
        yield from self.reset()
        bar0 = self.ep.bar[0]
        with self.assertRaises(pcie.UnsuccessfulCompletionError):
            _ = yield from self.rc.mem_read(bar0, 1024)

    @testcase(clkgen, dutgen)
    def test_write_read(self):
        """Test writing and then reading 4 bytes."""
        yield from self.reset()
        bar0 = self.ep.bar[0]
        # TODO: PCIe test code requires LE byte arrays for some reason
        data = bytearray(reversed([1, 2, 3, 4]))
        yield from self.rc.mem_write(bar0 + 128, data)
        yield from self.await_tx()
        readback = yield from self.rc.mem_read(bar0 + 128, 4)
        self.assertEqual(data, readback)

    @testcase(clkgen, dutgen)
    def test_dma(self):
        # TODO
        yield from self.reset()


if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    log.basicConfig(
        level=log.DEBUG,
        format='[%(asctime)-15s] %(funcName)-15s %(levelname)-8s %(message)s')
    unittest.main()
