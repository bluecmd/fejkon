# Kaitai.io struct definition for PCIe TLPs
# vim: set expandtab:syntax=yaml
meta:
  id: pcie_tlp
  title: PCIe 3.0 TLP
  file-extension: tlp
  endian: be
seq:
  - id: fmt
    type: b3
    enum: fmt
  - id: type
    type: b5
    enum: type
  - id: dummy1
    type: b14
  - id: length
    type: b10
  - id: payload
    type:
      switch-on: type
      cases:
        'type::mem_access': mem_access
        'type::completion': completion
types:
  mem_access:
    seq:
      - id: requester
        type: u2
      - id: tag
        type: u1
      - id: last_byte_enable
        type: b4
      - id: first_byte_enable
        type: b4
      - id: address
        type: b30
      - id: dummy2
        type: b2
  completion:
    seq:
      - id: completer
        type: u2
      - id: status
        type: b3
      - id: bcm
        type: b1
      - id: byte_count
        type: b12
      - id: requester
        type: u2
      - id: tag
        type: u1
      - id: dummy
        type: b1
      - id: address
        type: b7
enums:
  fmt:
    0: dw3_no_data
    1: dw4_no_data
    2: dw3_data
    3: dw3_data
    4: tlp_prefix
  type:
    0: mem_access
    1: mem_access_locked
    2: io_access
    4: cfg_type_0
    9: cfg_type_1
    10: completion
    11: completion_locked
