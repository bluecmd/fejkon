#!/usr/bin/env python3
"""

Copyright (c) 2018 Alex Forencich
Copyright (c) 2020 Christian Svensson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""
import math
import struct


FMT_3DW        = 0x0
FMT_4DW        = 0x1
FMT_3DW_DATA   = 0x2
FMT_4DW_DATA   = 0x3
FMT_TLP_PREFIX = 0x4


TLP_MEM_READ           = (FMT_3DW, 0x00)
TLP_MEM_READ_64        = (FMT_4DW, 0x00)
TLP_MEM_READ_LOCKED    = (FMT_3DW, 0x01)
TLP_MEM_READ_LOCKED_64 = (FMT_4DW, 0x01)
TLP_MEM_WRITE          = (FMT_3DW_DATA, 0x00)
TLP_MEM_WRITE_64       = (FMT_4DW_DATA, 0x00)
TLP_IO_READ            = (FMT_3DW, 0x02)
TLP_IO_WRITE           = (FMT_3DW_DATA, 0x02)
TLP_CFG_READ_0         = (FMT_3DW, 0x04)
TLP_CFG_WRITE_0        = (FMT_3DW_DATA, 0x04)
TLP_CFG_READ_1         = (FMT_3DW, 0x05)
TLP_CFG_WRITE_1        = (FMT_3DW_DATA, 0x05)
TLP_MSG_TO_RC          = (FMT_4DW, 0x10)
TLP_MSG_ADDR           = (FMT_4DW, 0x11)
TLP_MSG_ID             = (FMT_4DW, 0x12)
TLP_MSG_BCAST          = (FMT_4DW, 0x13)
TLP_MSG_LOCAL          = (FMT_4DW, 0x14)
TLP_MSG_GATHER         = (FMT_4DW, 0x15)
TLP_MSG_DATA_TO_RC     = (FMT_4DW_DATA, 0x10)
TLP_MSG_DATA_ADDR      = (FMT_4DW_DATA, 0x11)
TLP_MSG_DATA_ID        = (FMT_4DW_DATA, 0x12)
TLP_MSG_DATA_BCAST     = (FMT_4DW_DATA, 0x13)
TLP_MSG_DATA_LOCAL     = (FMT_4DW_DATA, 0x14)
TLP_MSG_DATA_GATHER    = (FMT_4DW_DATA, 0x15)
TLP_CPL                = (FMT_3DW, 0x0A)
TLP_CPL_DATA           = (FMT_3DW_DATA, 0x0A)
TLP_CPL_LOCKED         = (FMT_3DW, 0x0B)
TLP_CPL_LOCKED_DATA    = (FMT_3DW_DATA, 0x0B)
TLP_FETCH_ADD          = (FMT_3DW_DATA, 0x0C)
TLP_FETCH_ADD_64       = (FMT_4DW_DATA, 0x0C)
TLP_SWAP               = (FMT_3DW_DATA, 0x0D)
TLP_SWAP_64            = (FMT_4DW_DATA, 0x0D)
TLP_CAS                = (FMT_3DW_DATA, 0x0E)
TLP_CAS_64             = (FMT_4DW_DATA, 0x0E)
TLP_PREFIX_MRIOV       = (FMT_TLP_PREFIX, 0x00)
TLP_PREFIX_VENDOR_L0   = (FMT_TLP_PREFIX, 0x0E)
TLP_PREFIX_VENDOR_L1   = (FMT_TLP_PREFIX, 0x0F)
TLP_PREFIX_EXT_TPH     = (FMT_TLP_PREFIX, 0x10)
TLP_PREFIX_VENDOR_E0   = (FMT_TLP_PREFIX, 0x1E)
TLP_PREFIX_VENDOR_E1   = (FMT_TLP_PREFIX, 0x1F)


CPL_STATUS_SC  = 0x0 # successful completion
CPL_STATUS_UR  = 0x1 # unsupported request
CPL_STATUS_CRS = 0x2 # configuration request retry status
CPL_STATUS_CA  = 0x4 # completer abort


class PcieId(object):
    def __init__(self, bus=0, device=0, function=0):
        self.bus = 0
        self.device = 0
        self.function = 0
        if isinstance(bus, PcieId):
            self.bus = bus.bus
            self.device = bus.device
            self.function = bus.function
        elif isinstance(bus, tuple):
            self.bus, self.device, self.function = bus
        else:
            self.bus = bus
            self.device = device
            self.function = function

    @classmethod
    def from_int(cls, val):
        return cls((val >> 8) & 0xff, (val >> 3) & 0x1f, val & 0x7)

    def __eq__(self, other):
        if isinstance(other, PcieId):
            return self.bus == other.bus and self.device == other.device and self.function == other.function
        return False

    def __int__(self):
        return ((self.bus & 0xff) << 8) | ((self.device & 0x1f) << 3) | (self.function & 0x7)

    def __str__(self):
        return "%02x:%02x.%x" % (self.bus, self.device, self.function)

    def __repr__(self):
        return "PcieId(%d, %d, %d)" % (self.bus, self.device, self.function)


class TLP(object):
    def __init__(self, tlp=None):
        self.fmt = 0
        self.type = 0
        self.tc = 0
        self.th = 0
        self.td = 0
        self.ep = 0
        self.attr = 0
        self.at = 0
        self.length = 0
        self.completer_id = PcieId(0, 0, 0)
        self.status = 0
        self.bcm = 0
        self.byte_count = 0
        self.requester_id = PcieId(0, 0, 0)
        self.dest_id = PcieId(0, 0, 0)
        self.tag = 0
        self.first_be = 0
        self.last_be = 0
        self.lower_address = 0
        self.address = 0
        self.register_number = 0
        self.data = []

        if isinstance(tlp, bytes) or isinstance(tlp, bytearray):
            self.unpack(tlp)
        if isinstance(tlp, TLP):
            self.fmt = tlp.fmt
            self.type = tlp.type
            self.tc = tlp.tc
            self.td = tlp.td
            self.ep = tlp.ep
            self.attr = tlp.attr
            self.at = tlp.at
            self.length = tlp.length
            self.completer_id = tlp.completer_id
            self.status = tlp.status
            self.bcm = tlp.bcm
            self.byte_count = tlp.byte_count
            self.requester_id = tlp.requester_id
            self.dest_id = tlp.dest_id
            self.tag = tlp.tag
            self.first_be = tlp.first_be
            self.last_be = tlp.last_be
            self.lower_address = tlp.lower_address
            self.address = tlp.address
            self.register_number = tlp.register_number
            self.data = tlp.data

    @property
    def fmt_type(self):
        return (self.fmt, self.type)

    @fmt_type.setter
    def fmt_type(self, val):
        self.fmt, self.type = val

    @property
    def completer_id(self):
        return self._completer_id

    @completer_id.setter
    def completer_id(self, val):
        self._completer_id = PcieId(val)

    @property
    def requester_id(self):
        return self._requester_id

    @requester_id.setter
    def requester_id(self, val):
        self._requester_id = PcieId(val)

    @property
    def dest_id(self):
        return self._dest_id

    @dest_id.setter
    def dest_id(self, val):
        self._dest_id = PcieId(val)

    def check(self):
        """Validate TLP"""
        ret = True
        if self.fmt == FMT_3DW_DATA or self.fmt == FMT_4DW_DATA:
            if self.length != len(self.data):
                raise AssertionError("length field does not match data (actual %d != expected %d): %s" % (self.length, len(self.data), repr(self)))
            if 0 > self.length > 1024:
                raise AssertionError("length out of range: %s" % repr(self))
        if (self.fmt_type == TLP_MEM_READ or self.fmt_type == TLP_MEM_READ_64 or
                self.fmt_type == TLP_MEM_READ_LOCKED or self.fmt_type == TLP_MEM_READ_LOCKED_64 or
                self.fmt_type == TLP_MEM_WRITE or self.fmt_type == TLP_MEM_WRITE_64):
            if self.length*4 > 0x1000 - (self.address & 0xfff):
                raise AssertionError("request crosses 4K boundary: %s" % repr(self))
        if (self.fmt_type == TLP_IO_READ or self.fmt_type == TLP_IO_WRITE):
            if self.length != 1:
                raise AssertionError("invalid length for IO request: %s" % repr(self))
            if self.last_be != 0:
                raise AssertionError("invalid last BE for IO request: %s" % repr(self))
        if (self.fmt_type == TLP_CPL_DATA):
            if (self.byte_count + (self.lower_address&3) + 3) < self.length*4:
                raise AssertionError("completion byte count too small: %s" % repr(self))

    def set_completion(self, tlp, completer_id, has_data=False, status=CPL_STATUS_SC):
        """Prepare completion for TLP"""
        if has_data:
            self.fmt_type = TLP_CPL_DATA
        else:
            self.fmt_type = TLP_CPL
        self.requester_id = tlp.requester_id
        self.completer_id = completer_id
        self.status = status
        self.attr = tlp.attr
        self.tag = tlp.tag
        self.tc = tlp.tc

    def set_completion_data(self, tlp, completer_id):
        """Prepare completion with data for TLP"""
        self.set_completion(tlp, completer_id, True)

    def set_ur_completion(self, tlp, completer_id):
        """Prepare unsupported request (UR) completion for TLP"""
        self.set_completion(tlp, completer_id, False, CPL_STATUS_UR)

    def set_crs_completion(self, tlp, completer_id):
        """Prepare configuration request retry status (CRS) completion for TLP"""
        self.set_completion(tlp, completer_id, False, CPL_STATUS_CRS)

    def set_ca_completion(self, tlp, completer_id):
        """Prepare completer abort (CA) completion for TLP"""
        self.set_completion(tlp, completer_id, False, CPL_STATUS_CA)

    def set_be(self, addr, length):
        """Compute byte enables, DWORD address, and DWORD length from byte address and length"""
        self.address = addr & ~3
        first_pad = addr % 4
        last_pad = 3 - (addr+length-1) % 4
        self.length = math.ceil((length+first_pad+last_pad)/4)
        self.first_be = (0xf << first_pad) & 0xf
        self.last_be = (0xf >> last_pad)
        if self.length == 1:
            self.first_be &= self.last_be
            self.last_be = 0
        self.lower_address = self.get_lower_address()
        return (first_pad, last_pad)

    def set_data(self, data):
        """Set DWORD data from byte data"""
        self.data = []
        for k in range(0, len(data), 4):
            self.data.append(struct.unpack('>L', data[k:k+4])[0])
        self.length = len(self.data)

    def set_be_data(self, addr, data):
        """Set byte enables, DWORD address, DWORD length, and DWORD data from byte address and byte data"""
        self.address = addr & ~3
        first_pad, last_pad = self.set_be(addr, len(data))
        self.set_data(bytearray(first_pad)+data+bytearray(last_pad))

    def get_data(self):
        data = bytearray()
        for dw in self.data:
            data.extend(struct.pack('>L', dw))
        return data

    def get_first_be_offset(self):
        """Offset to first transferred byte from first byte enable"""
        if self.first_be & 0x7 == 0:
            return 3
        elif self.first_be & 0x3 == 0:
            return 2
        elif self.first_be & 0x1 == 0:
            return 1
        else:
            return 0

    def get_last_be_offset(self):
        """Offset after last transferred byte from last byte enable"""
        if self.length == 1:
            be = self.first_be
        else:
            be = self.last_be
        if be & 0xf == 0x1:
            return 3
        elif be & 0xe == 0x2:
            return 2
        elif be & 0xc == 0x4:
            return 1
        else:
            return 0

    def get_be_byte_count(self):
        """Compute byte length from DWORD length and byte enables"""
        return self.length*4 - self.get_first_be_offset() - self.get_last_be_offset()

    def get_lower_address(self):
        """Compute lower address field from address and first byte enable"""
        return self.address & 0x7c + self.get_first_be_offset()

    def get_size(self):
        """Return size of TLP in bytes"""
        if self.fmt == FMT_3DW:
            return 12
        elif self.fmt == FMT_3DW_DATA:
            return 12+len(self.data)*4
        elif self.fmt == FMT_4DW:
            return 16
        elif self.fmt == FMT_4DW_DATA:
            return 16+len(self.data)*4

    def get_wire_size(self):
        """Return size of TLP in bytes, including overhead"""
        return self.get_size()+12

    def get_data_credits(self):
        """Return size of TLP in data credits (1 credit per 4 DW)"""
        return int((len(self.data)+3)/4)

    def pack(self):
        """Pack TLP as byte array"""
        self.check()
        pkt = []

        l = self.length & 0x3ff
        l |= (self.at & 0x3) << 10
        l |= (self.attr & 0x3) << 12
        l |= (self.ep & 1) << 14
        l |= (self.td & 1) << 15
        l |= (self.th & 1) << 16
        l |= (self.attr & 0x4) << 16
        l |= (self.tc & 0x7) << 20
        l |= (self.type & 0x1f) << 24
        l |= (self.fmt & 0x7) << 29
        pkt.append(l)

        if (self.fmt_type == TLP_CFG_READ_0 or self.fmt_type == TLP_CFG_WRITE_0 or
                self.fmt_type == TLP_CFG_READ_1 or self.fmt_type == TLP_CFG_WRITE_1 or
                self.fmt_type == TLP_MEM_READ or self.fmt_type == TLP_MEM_READ_64 or
                self.fmt_type == TLP_MEM_READ_LOCKED or self.fmt_type == TLP_MEM_READ_LOCKED_64 or
                self.fmt_type == TLP_MEM_WRITE or self.fmt_type == TLP_MEM_WRITE_64 or
                self.fmt_type == TLP_IO_READ or self.fmt_type == TLP_IO_WRITE):
            l = self.first_be & 0xf
            l |= (self.last_be & 0xf) << 4
            l |= (self.tag & 0xff) << 8
            l |= int(self.requester_id) << 16
            pkt.append(l)

            if (self.fmt_type == TLP_CFG_READ_0 or self.fmt_type == TLP_CFG_WRITE_0 or
                    self.fmt_type == TLP_CFG_READ_1 or self.fmt_type == TLP_CFG_WRITE_1):
                l = (self.register_number & 0x3ff) << 2
                l |= int(self.dest_id) << 16
                pkt.append(l)
            else:
                l = 0
                if self.fmt == FMT_4DW or self.fmt == FMT_4DW_DATA:
                    l |= (self.address >> 32) & 0xffffffff
                    pkt.append(l)
                l |= self.address & 0xfffffffc
                pkt.append(l)
        elif (self.fmt_type == TLP_CPL or self.fmt_type == TLP_CPL_DATA or
                self.fmt_type == TLP_CPL_LOCKED or self.fmt_type == TLP_CPL_LOCKED_DATA):
            l = self.byte_count & 0xfff
            l |= (self.bcm & 1) << 12
            l |= (self.status & 0x7) << 13
            l |= int(self.completer_id) << 16
            pkt.append(l)
            l = self.lower_address & 0x7f
            l |= (self.tag & 0xff) << 8
            l |= int(self.requester_id) << 16
            pkt.append(l)
        else:
            raise Exception("Unknown TLP type")

        if self.fmt == FMT_3DW_DATA or self.fmt == FMT_4DW_DATA:
            pkt.extend(self.data)

        res = bytearray()
        for w in pkt:
            res.extend(struct.pack('>L', w))
        return bytes(res)

    def intel_pack(self):
        """Pack TLP using Intel QWORD alignment."""
        b = self.pack()
        if self.address & 0x4 != 0:
            return b
        if self.fmt == FMT_4DW or self.fmt == FMT_4DW_DATA:
            return b[:4*4] + bytes(4) + b[4*4:]
        return b[:4*3] + bytes(4) + b[4*3:]

    def unpack(self, data, check=True):
        """Unpack TLP from byte array"""
        pkt = []
        for k in range(0, len(data), 4):
            pkt.append(struct.unpack('>L', data[k:k+4])[0])
        self.length = pkt[0] & 0x3ff
        self.at = (pkt[0] >> 10) & 0x3
        self.attr = (pkt[0] >> 12) & 0x3
        self.ep = (pkt[0] >> 14) & 1
        self.td = (pkt[0] >> 15) & 1
        self.th = (pkt[0] >> 16) & 1
        self.attr |= (pkt[0] >> 16) & 0x4
        self.tc = (pkt[0] >> 20) & 0x7
        self.type = (pkt[0] >> 24) & 0x1f
        self.fmt = (pkt[0] >> 29) & 0x7

        if self.fmt == FMT_3DW_DATA or self.fmt == FMT_4DW_DATA:
            if self.length == 0:
                self.length = 1024

        if (self.fmt_type == TLP_CFG_READ_0 or self.fmt_type == TLP_CFG_WRITE_0 or
                self.fmt_type == TLP_CFG_READ_1 or self.fmt_type == TLP_CFG_WRITE_1 or
                self.fmt_type == TLP_MEM_READ or self.fmt_type == TLP_MEM_READ_64 or
                self.fmt_type == TLP_MEM_READ_LOCKED or self.fmt_type == TLP_MEM_READ_LOCKED_64 or
                self.fmt_type == TLP_MEM_WRITE or self.fmt_type == TLP_MEM_WRITE_64 or
                self.fmt_type == TLP_IO_READ or self.fmt_type == TLP_IO_WRITE):
            self.first_be = pkt[1] & 0xf
            self.last_be = (pkt[1] >> 4) & 0xf
            self.tag = (pkt[1] >> 8) & 0xff
            self.requester_id = PcieId.from_int(pkt[1] >> 16)

            if (self.fmt_type == TLP_CFG_READ_0 or self.fmt_type == TLP_CFG_WRITE_0 or
                    self.fmt_type == TLP_CFG_READ_1 or self.fmt_type == TLP_CFG_WRITE_1):
                self.register_number = (pkt[2] >> 2) >> 0x3ff
                self.dest_id = PcieId.from_int(pkt[2] >> 16)
            elif self.fmt == FMT_3DW or self.fmt == FMT_3DW_DATA:
                self.address = pkt[2] & 0xfffffffc
            elif self.fmt == FMT_4DW or self.fmt == FMT_4DW_DATA:
                self.address = (pkt[2] & 0xffffffff) << 32 | pkt[3] & 0xfffffffc
        elif (self.fmt_type == TLP_CPL or self.fmt_type == TLP_CPL_DATA or
                self.fmt_type == TLP_CPL_LOCKED or self.fmt_type == TLP_CPL_LOCKED_DATA):
            self.byte_count = pkt[1] & 0xfff
            self.bcm = (pkt[1] >> 12) & 1
            self.status = (pkt[1] >> 13) & 0x7
            self.completer_id = PcieId.from_int(pkt[1] >> 16)
            self.lower_address = pkt[2] & 0x7f
            self.tag = (pkt[2] >> 8) & 0xff
            self.requester_id = PcieId.from_int(pkt[2] >> 16)

            if self.byte_count == 0:
                self.byte_count = 4096
        else:
            raise Exception("Unknown TLP type")

        if len(pkt) == 3:
            pass
        elif self.fmt == FMT_3DW_DATA:
            self.data = pkt[3:]
        elif self.fmt == FMT_4DW_DATA:
            self.data = pkt[4:]

        self.lower_address = self.get_lower_address()
        if check:
            self.check()
        return self

    def intel_unpack(self, b):
        """Unpack TLP using Intel QWORD alignment."""
        self.unpack(b[:32*4], check=False)
        if self.address & 0x4 != 0:
            self.unpack(b)
            return
        if self.fmt == FMT_4DW or self.fmt == FMT_4DW_DATA:
            self.unpack(b[:4*4] + b[4*5:])
        else:
            self.unpack(b[:4*3] + b[4*4:])

    def __eq__(self, other):
        if isinstance(other, TLP):
            return (
                    self.data == other.data and
                    self.fmt == other.fmt and
                    self.type == other.type and
                    self.tc == other.tc and
                    self.td == other.td and
                    self.ep == other.ep and
                    self.attr == other.attr and
                    self.at == other.at and
                    self.length == other.length and
                    self.completer_id == other.completer_id and
                    self.status == other.status and
                    self.bcm == other.bcm and
                    self.byte_count == other.byte_count and
                    self.requester_id == other.requester_id and
                    self.dest_id == other.dest_id and
                    self.tag == other.tag and
                    self.first_be == other.first_be and
                    self.last_be == other.last_be and
                    self.lower_address == other.lower_address and
                    self.address == other.address and
                    self.register_number == other.register_number
                )
        return False

    def __repr__(self):
        # TODO(bluecmd): Make this only print stuff if set
        return (
                ('TLP(data=[%s], ' % ', '.join(hex(x) for x in self.data)) +
                ('fmt=0x%x, ' % self.fmt) +
                ('type=0x%x, ' % self.type) +
                ('tc=0x%x, ' % self.tc) +
                ('th=0x%x, ' % self.th) +
                ('td=0x%x, ' % self.td) +
                ('ep=0x%x, ' % self.ep) +
                ('attr=0x%x, ' % self.attr) +
                ('at=0x%x, ' % self.at) +
                ('length=0x%x, ' % self.length) +
                ('completer_id=%s, ' % repr(self.completer_id)) +
                ('status=0x%x, ' % self.status) +
                ('bcm=0x%x, ' % self.bcm) +
                ('byte_count=0x%x, ' % self.byte_count) +
                ('requester_id=%s, ' % repr(self.requester_id)) +
                ('dest_id=%s, ' % repr(self.dest_id)) +
                ('tag=0x%x, ' % self.tag) +
                ('first_be=0x%x, ' % self.first_be) +
                ('last_be=0x%x, ' % self.last_be) +
                ('lower_address=0x%x, ' % self.lower_address) +
                ('address=0x%x, ' % self.address) +
                ('register_number=0x%x)' % self.register_number)
            )

if __name__ == '__main__':
    import binascii
    import sys
    # Read TLP from command line and print it decoded
    if sys.argv[1] == 'intel':
        t = TLP()
        t.intel_unpack(binascii.unhexlify(''.join(x.replace('0x', '') for x in sys.argv[2:])))
        print(t)
