"""Testbench for FC framing."""
import binascii
import cocotb
from cocotb.binary import BinaryValue
from cocotb.clock import Clock, Timer
from cocotb.drivers.avalon import AvalonMaster
from cocotb.handle import ModifiableObject
from cocotb.monitors.avalon import AvalonSTPkts as AvalonSTMonitor
from cocotb.triggers import RisingEdge

import fc


class Thing:
    """Commmon test logic for all tests."""

    def __init__(self, dut):
        self.dut = dut
        # TODO: See https://github.com/cocotb/cocotb/issues/2051
        # self.userrx = AvalonSTMonitor(dut, 'userrx', dut.rx_clk)
        self.tx_csr = AvalonMaster(dut, 'tx_mm', dut.tx_clk)
        self.rx_csr = AvalonMaster(dut, 'rx_mm', dut.rx_clk)

    @staticmethod
    async def new(dut):
        rx_clock = Clock(dut.rx_clk, 10, units='us')
        tx_clock = Clock(dut.tx_clk, 10, units='us')
        cocotb.fork(rx_clock.start())
        cocotb.fork(tx_clock.start())
        # Ensure the bus is in a known and quiet state before starting the monitors
        await Thing.reset(dut)
        return Thing(dut)

    @staticmethod
    async def reset(dut):
        dut.reset <= 1
        await Timer(30, units='us')
        dut.reset <= 0
        dut.avtx_ready <= 1
        dut.reset._log.info('Reset complete')


def with_control(b):
    """Append control for K,D,D,D format."""
    v = BinaryValue(n_bits=40, bigEndian=True)
    v.buff = bytes([0x8]) + b
    return v[4:39]


def decode_symbol(b):
    if b[0] == 0x8:
        return fc.decode(b[1:])
    elif b[0] == 0x0:
        return '<DATA %s>' % (binascii.hexlify(b[1:]), )


def assert_symbol(value, symbol):
    if isinstance(value, ModifiableObject):
        value = value.value
    value = value.buff
    symbol = symbol.buff
    assert value == symbol, 'value expected to be %s, is %s' % (decode_symbol(symbol), decode_symbol(value))


@cocotb.test()
async def test_reset_tx(dut):
    """Test the primitives sent after reset."""
    tb = await Thing.new(dut)
    await RisingEdge(dut.tx_clk)
    assert dut.avtx_valid == 1, 'avtx expected to be valid'
    assert dut.state == fc.STATE_LF2, 'state expected to be LF2'
    assert_symbol(dut.avtx_data, with_control(fc.NOS))


@cocotb.test()
async def test_handshake(dut):
    """Test the FC link-up handshake."""
    tb = await Thing.new(dut)
    await RisingEdge(dut.tx_clk)
    assert dut.avtx_valid == 1, 'avtx expected to be valid'
    # LF2 -> LF1
    dut.avrx_valid <= 1
    dut.avrx_data <= with_control(fc.NOS)
    for _ in range(8):
        await RisingEdge(dut.tx_clk)
    assert dut.state == fc.STATE_LF1, 'state expected to be LF1'
    assert_symbol(dut.avtx_data, with_control(fc.OLS))
    # LF1 -> OL2
    dut.avrx_data <= with_control(fc.OLS)
    for _ in range(8):
        await RisingEdge(dut.tx_clk)
    assert dut.state == fc.STATE_OL2, 'state expected to be OL2'
    assert_symbol(dut.avtx_data, with_control(fc.LR))
    # OL2 -> LR2
    dut.avrx_data <= with_control(fc.LR)
    for _ in range(8):
        await RisingEdge(dut.tx_clk)
    assert dut.state == fc.STATE_LR2, 'state expected to be LR2'
    assert_symbol(dut.avtx_data, with_control(fc.LRR))
    # LR2 -> LR3
    dut.avrx_data <= with_control(fc.LRR)
    for _ in range(8):
        await RisingEdge(dut.tx_clk)
    assert dut.state == fc.STATE_LR3, 'state expected to be LR3'
    assert_symbol(dut.avtx_data, with_control(fc.IDLE))
    # LR3 -> Active
    dut.avrx_data <= with_control(fc.IDLE)
    for _ in range(8):
        if dut.state == fc.STATE_AC:
            break
        await RisingEdge(dut.tx_clk)
    assert dut.state == fc.STATE_AC, 'state expected to be AC'
    assert_symbol(dut.avtx_data, with_control(fc.IDLE))
    # Wait for 6 IDLEs
    assert dut.active == 0, 'state expected to be inactive'
    for _ in range(6):
        await RisingEdge(dut.tx_clk)
    assert_symbol(dut.avtx_data, with_control(fc.ARBFF))
    assert dut.active == 1, 'state expected to be active'
