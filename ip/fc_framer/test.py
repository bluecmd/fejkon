"""Testbench for FC framing."""
import binascii
import cocotb
from cocotb.binary import BinaryValue
from cocotb.clock import Clock, Timer
from cocotb.drivers.avalon import AvalonMaster
from cocotb.handle import ModifiableObject
from cocotb.monitors.avalon import AvalonSTPkts as AvalonSTMonitor
from cocotb.scoreboard import Scoreboard
from cocotb.triggers import RisingEdge

import fc


class Thing:
    """Commmon test logic for all tests."""

    def __init__(self, dut):
        self.dut = dut
        # TODO: See https://github.com/cocotb/cocotb/issues/2051 for Verilator freeze bug
        self.userrx = AvalonSTMonitor(dut, 'userrx', dut.rx_clk)
        self.tx_csr = AvalonMaster(dut, 'tx_mm', dut.tx_clk)
        self.rx_csr = AvalonMaster(dut, 'rx_mm', dut.rx_clk)
        self.expected_output = []
        self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.userrx, self.expected_output)

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
    """Construct control for K,D,D,D format."""
    v = BinaryValue(n_bits=40, bigEndian=True)
    v.buff = bytes([0x8]) + b
    return v[4:39]


def with_data(b):
    """Construct data for D,D,D,D format."""
    v = BinaryValue(n_bits=40, bigEndian=True)
    v.buff = bytes([0x0]) + b
    return v[4:39]


def decode_symbol(b):
    if b[0] == 0x8:
        return fc.decode(b[1:])
    if b[0] == 0x0:
        return '<DATA %s>' % (binascii.hexlify(b[1:]), )
    raise Exception('symbol had unsupported control bits')


def assert_symbol(value, symbol):
    if isinstance(value, ModifiableObject):
        value = value.value
    value = value.buff
    symbol = symbol.buff
    assert value == symbol, 'value expected to be %s, is %s' % (decode_symbol(symbol), decode_symbol(value))


@cocotb.test()
async def test_reset_tx(dut):
    """Test the primitives sent after reset."""
    await Thing.new(dut)
    await RisingEdge(dut.tx_clk)
    assert dut.avtx_valid == 1, 'avtx expected to be valid'
    assert dut.state == fc.STATE_OL1, 'state expected to be OL1'
    assert_symbol(dut.avtx_data, with_control(fc.OLS))


@cocotb.test()
async def test_link_recovery_handshake(dut):
    """Test the FC link-recovery (fast) handshake."""
    await Thing.new(dut)
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


async def handshake(dut):
    """Quietly do a link recovery FC handshake."""
    dut.avrx_valid <= 1
    dut.avrx_data <= with_control(fc.NOS)
    await RisingEdge(dut.tx_clk)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.OLS)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.LR)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.LRR)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.IDLE)
    for _ in range(8):
        if dut.state == fc.STATE_AC:
            break
        await RisingEdge(dut.tx_clk)
    for _ in range(6):
        await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.ARBFF)
    assert dut.active == 1, 'state expected to be active'


@cocotb.test()
async def test_simple_frame(dut):
    """Test the FC simple framing."""
    tb = await Thing.new(dut)
    await handshake(dut)
    tb.expected_output.append(fc.SOFI3 + binascii.unhexlify('0102030405060708090a0b0c') + fc.EOFN_P)
    dut.avrx_data <= with_control(fc.SOFI3)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('01020304'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('05060708'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('090A0B0C'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.EOFN_P)
    await RisingEdge(dut.rx_clk)
    dut.avrx_data <= with_control(fc.ARBFF)
    await RisingEdge(dut.rx_clk)
    await Timer(50, 'us')
    raise tb.scoreboard.result


@cocotb.test()
async def test_broken_half_frame(dut):
    """Test ignoring broken frame."""
    tb = await Thing.new(dut)
    await handshake(dut)
    dut.avrx_data <= with_data(binascii.unhexlify('05060708'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('090A0B0C'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.EOFN_P)
    await RisingEdge(dut.rx_clk)
    dut.avrx_data <= with_control(fc.ARBFF)
    await RisingEdge(dut.rx_clk)
    await Timer(50, 'us')
    raise tb.scoreboard.result


@cocotb.test()
async def test_extra_prim_frame(dut):
    """Test extra control primitives ends frame."""
    tb = await Thing.new(dut)
    await handshake(dut)
    tb.expected_output.append(fc.SOFI3 + binascii.unhexlify('01020304') + fc.R_RDY)
    dut.avrx_data <= with_control(fc.SOFI3)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('01020304'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.R_RDY)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('05060708'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('090A0B0C'))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.EOFN_P)
    await RisingEdge(dut.rx_clk)
    dut.avrx_data <= with_control(fc.ARBFF)
    await RisingEdge(dut.rx_clk)
    await Timer(50, 'us')
    raise tb.scoreboard.result


@cocotb.test()
async def test_runaway_frame(dut):
    """Test handling of frame that becomes too long."""
    tb = await Thing.new(dut)
    await handshake(dut)
    tb.expected_output.append(fc.SOFI3 + binascii.unhexlify('01020304') * 7)
    dut.avrx_data <= with_control(fc.SOFI3)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_data(binascii.unhexlify('01020304'))
    for _ in range(10):
        await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.EOFN_P)
    await RisingEdge(dut.rx_clk)
    dut.avrx_data <= with_control(fc.ARBFF)
    await RisingEdge(dut.rx_clk)
    await Timer(50, 'us')
    raise tb.scoreboard.result


@cocotb.test()
async def test_prim_frame(dut):
    """Test the FC framing of selected primitives."""
    tb = await Thing.new(dut)
    await handshake(dut)
    tb.expected_output.append(fc.R_RDY)
    tb.expected_output.append(fc.VC_RDY(0xaa))
    dut.avrx_data <= with_control(fc.R_RDY)
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.ARBFF)
    await RisingEdge(dut.rx_clk)
    dut.avrx_data <= with_control(fc.VC_RDY(0xaa))
    await RisingEdge(dut.tx_clk)
    dut.avrx_data <= with_control(fc.ARBFF)
    await Timer(50, 'us')
    raise tb.scoreboard.result
