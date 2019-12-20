"""PCIe BFM of Intel PCIe streaming IP

Used to emulate the Intel PCIe IP core using Avalon-ST interface.
"""
import logging as log
import math
import threading

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
        self.tx_sem = threading.Semaphore(0)
        self.lock = threading.Lock()
        self.clk = clk
        self.vendor_id = 0xf1c0
        self.device_id = 0x0de5
        self.msi_multiple_message_capable = 32
        self.msi_64bit_address_capable = 1
        self.msi_per_vector_mask_capable = 1
        self.register_rx_tlp_handler(pcie.TLP_MEM_READ, self.handle_mem_read_tlp)
        self.register_rx_tlp_handler(pcie.TLP_MEM_READ_64, self.handle_mem_read_tlp)
        self.register_rx_tlp_handler(pcie.TLP_MEM_WRITE, self.handle_mem_write_tlp)
        self.register_rx_tlp_handler(pcie.TLP_MEM_WRITE_64, self.handle_mem_write_tlp)
        self.configure_bar(0, 0x80000, ext=False, prefetch=False, io=False)
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
        self.tl_cfg_add = myhdl.Signal(myhdl.intbv()[4:])
        self.tl_cfg_ctl = myhdl.Signal(myhdl.intbv()[32:])
        self.tl_cfg_sts = myhdl.Signal(myhdl.intbv()[53:])

    def reset(self):
        self.tx_st_ready.next = 1

    def handle_config_0_tlp(self, tlp):
        yield from super(FejkonEP, self).handle_config_0_tlp(tlp)
        # Send the bus/dev number
        self.tl_cfg_add.next = 0xF
        self.tl_cfg_ctl.next = self.bus_num << 5 | self.device_num

    def _tlp_to_dut(self, tlp):
        """Move a TLP to the DUT."""
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
        with self.lock:
            self.rx_st_bar = bar
            for i in range(frames):
                # This is only >0 on the last frame
                last = (i == frames-1)
                first = (i == 0)
                self.rx_st_data.next = (
                    dws[8*i+7] << 224 | dws[8*i+6] << 192 | dws[8*i+5] << 160 |
                    dws[8*i+4] << 128 | dws[8*i+3] << 96 | dws[8*i+2] << 64 |
                    dws[8*i+1] << 32 | dws[8*i])
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

    def handle_mem_read_tlp(self, tlp):
        """Handle ordinary 32 and 64 bit memory read TLPs"""
        log.info("MRd TLP: %s", tlp)
        yield from self._tlp_to_dut(tlp)
        self.tx_sem.release()
        yield self.tx_st_valid.posedge, myhdl.delay(1000)
        if not self.tx_st_valid:
            raise Exception("Timeout waiting for CplD")

        yield self.clk.posedge

        dws = []
        val = int(self.tx_st_data)
        empty = int(self.tx_st_empty)
        if empty == 1:
            val &= 2**192-1
        if empty == 2:
            val &= 2**128-1
        if empty == 3:
            val &= 2**64-1
        # Parse header
        for i in range(3):
            dws.append(val & 0xffffffff)
            val = val >> 32
        cpl = pcie.TLP()
        cpl.unpack(dws)
        # Poorly documented alignment on Intel PCIe cores for V-series
        # See things like "256-bit Avalon-ST tx_st_data Cycle Definition"
        # TODO: For 64-bit accesses skip this
        if cpl.lower_address & 0x4 == 0:
            val = val >> 32
        # Read data
        for i in range(cpl.length):
            if i > 4:
                raise Exception("Unsupported, only 8 DW supported for now")
            dws.append(val & 0xffffffff)
            val = val >> 32
        cpl = pcie.TLP()
        cpl.unpack(dws)
        log.info("Completion TLP: %s", cpl)
        assert cpl.lower_address == tlp.get_lower_address()
        yield from self.send(cpl)

    def handle_mem_write_tlp(self, tlp):
        log.info("Got write TLP: %s", tlp)
        yield from self._tlp_to_dut(tlp)
        self.tx_sem.release()
