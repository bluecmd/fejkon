#/usr/bin/env/python3
"""Testbench for PCIe MSI generation."""

import logging as log
import os
import unittest

import myhdl

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
    """Collection of PCIe MSI test cases"""

    # pylint: disable=too-many-instance-attributes
    def setUp(self):
        # To HDL
        self.clk = myhdl.Signal(bool(0))
        self.rst = myhdl.Signal(bool(0))
        self.irq = myhdl.Signal(myhdl.intbv()[8:])
        self.msi_ack = myhdl.Signal(bool(0))
        # From HDL
        self.msi_num = myhdl.Signal(myhdl.intbv()[5:])
        self.msi_req = myhdl.Signal(bool(0))

    # === MyHDL instances ===
    # MyHDL instances that can be enable to co-execute alongside the test case
    # These are processes that may or may not be included depending on if that
    # signal is required for a particular test case.
    # dutgen and clkgen is probably always required.

    def clkgen(self, unused_test):
        @myhdl.always(myhdl.delay(2))
        def block():
            # pylint: disable=multiple-statements
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
            # To HDL
            clk=self.clk,
            reset=self.rst,
            irq=self.irq,
            app_msi_ack=self.msi_ack,
            # From HDL
            app_msi_num=self.msi_num,
            app_msi_req=self.msi_req)
        os.chdir(oldpath)
        return ret

    # === End of MyHDL instances ===
    def reset(self):
        yield myhdl.delay(10)
        self.rst.next = 1
        yield myhdl.delay(10)
        self.rst.next = 0
        yield myhdl.delay(10)

    @testcase(clkgen, dutgen)
    def test_single_irq(self):
        """Test sending an interrupt."""
        yield from self.reset()
        yield myhdl.delay(10)
        self.irq.next |= 1 << 5
        yield self.msi_req.posedge, myhdl.delay(1000)
        if not self.msi_req:
            raise Exception("Timeout waiting for app_msi_req")
        self.irq.next = 0
        yield self.clk.posedge
        self.assertEqual(self.msi_num, 0x5)
        self.msi_ack.next = 1
        yield self.clk.posedge
        self.msi_ack.next = 0
        yield self.clk.negedge
        if self.msi_req:
            raise Exception("Expected cleared app_msi_req 1 cycle after ack")
        # Expect no more events
        yield self.msi_req.posedge, myhdl.delay(100)
        if self.msi_req:
            raise Exception("Got unexpected secondary MSI")
        yield myhdl.delay(10)

    @testcase(clkgen, dutgen)
    def test_continuous_irq(self):
        """Test sending a continuous interrupt."""
        yield from self.reset()
        yield myhdl.delay(10)
        self.irq.next |= 1 << 5
        yield self.msi_req.posedge, myhdl.delay(1000)
        if not self.msi_req:
            raise Exception("Timeout waiting for app_msi_req")
        yield self.clk.posedge
        self.assertEqual(self.msi_num, 0x5)
        self.msi_ack.next = 1
        yield self.clk.posedge
        self.msi_ack.next = 0
        yield self.clk.negedge
        if not self.msi_req:
            yield self.msi_req.posedge, myhdl.delay(100)
            if not self.msi_req:
                raise Exception("Expected app_msi_req to be re-asserted")
        self.assertEqual(self.msi_num, 0x5)
        yield myhdl.delay(10)

    @testcase(clkgen, dutgen)
    def test_multiple_irq(self):
        """Test sending multiple interrupts."""
        yield from self.reset()
        yield myhdl.delay(10)
        self.irq.next |= 1 << 0 | 1 << 2 | 1 << 3
        yield self.msi_req.posedge, myhdl.delay(1000)
        if not self.msi_req:
            raise Exception("Timeout waiting for app_msi_req")
        self.irq.next = 0
        for ei in [0, 2, 3]:
            yield self.clk.posedge
            self.assertEqual(self.msi_num, ei)
            self.msi_ack.next = 1
            yield self.clk.posedge
            self.msi_ack.next = 0
            yield self.clk.negedge
        if self.msi_req:
            raise Exception("Expected cleared app_msi_req 1 cycle after ack")
        yield myhdl.delay(10)

if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    log.basicConfig(
            level=log.DEBUG,
            format='[%(asctime)-15s] %(funcName)-15s %(levelname)-8s %(message)s')
    unittest.main()
