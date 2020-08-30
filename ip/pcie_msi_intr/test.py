#/usr/bin/env/python3
"""Testbench for PCIe MSI generation."""

import cocotb
from cocotb.clock import Clock, Timer
from cocotb.triggers import RisingEdge

async def setup(dut):
    clock = Clock(dut.clk, 10, 'us')
    cocotb.fork(clock.start())
    dut.reset <= 1
    dut.irq <= 0
    dut.app_msi_ack <= 0
    await Timer(50, units='us')
    dut.reset <= 0
    await RisingEdge(dut.clk)
    dut.reset._log.debug('Reset complete')

@cocotb.test()
async def test_single_irq(dut):
    """Test sending an interrupt."""
    await setup(dut)
    dut.irq <= dut.irq.value | (1 << 5)
    for i in range(10):
        await RisingEdge(dut.clk)
        dut.irq <= 0
        if dut.app_msi_req == 1:
            break
    else:
        raise Exception('timeout waiting for app_msi_req')
    assert dut.app_msi_num == 0x5, 'expected app_msi_num to be 5'
    dut.app_msi_ack <= 1
    await RisingEdge(dut.clk)
    dut.app_msi_ack <= 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.app_msi_req == 0, 'expected cleared app_msi_req 1 cycle after ack'
    # Expect no more events
    for i in range(10):
        await RisingEdge(dut.clk)
        if dut.app_msi_req == 1:
            raise Exception('unexpected secondary MSI')
    else:
        # all good
        pass

@cocotb.test()
async def test_continuous_irq(dut):
    """Test sending a continuous interrupt."""
    await setup(dut)
    dut.irq <= dut.irq.value | (1 << 5)
    for i in range(10):
        await RisingEdge(dut.clk)
        if dut.app_msi_req == 1:
            break
    else:
        raise Exception('timeout waiting for app_msi_req')
    assert dut.app_msi_num == 0x5, 'expected app_msi_num to be 5'
    dut.app_msi_ack <= 1
    await RisingEdge(dut.clk)
    dut.app_msi_ack <= 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.app_msi_req == 0, 'expected cleared app_msi_req 1 cycle after ack'
    # Expect no more events
    for i in range(10):
        await RisingEdge(dut.clk)
        if dut.app_msi_req == 1:
            raise Exception('unexpected secondary MSI')
    else:
        # all good
        pass

@cocotb.test()
async def test_multiple_irq(dut):
    """Test sending multiple interrupts."""
    await setup(dut)
    dut.irq <= dut.irq.value | (1 << 0 | 1 << 2 | 1 << 3)
    await RisingEdge(dut.clk)
    for ei in [0, 2, 3]:
        for i in range(10):
            dut.irq <= 0
            if dut.app_msi_req == 1:
                break
            await RisingEdge(dut.clk)
        else:
            raise Exception('timeout waiting for app_msi_req')
        assert dut.app_msi_num == ei, 'expected app_msi_num to be {}' % ei
        dut.app_msi_ack <= 1
        await RisingEdge(dut.clk)
        dut.app_msi_ack <= 0
        await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.app_msi_req == 0, 'expected cleared app_msi_req 1 cycle after ack'
    # Expect no more events
    for i in range(10):
        await RisingEdge(dut.clk)
        if dut.app_msi_req == 1:
            raise Exception('unexpected secondary MSI')
    else:
        # all good
        pass
