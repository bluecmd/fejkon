set d [lindex [get_service_paths device] 0]
set sof [file join fejkon.sof]

set masters [get_service_paths master]

if {[llength $masters] == 0} {
  puts " ==> WARNING: No masters found <=="
  puts "To program the device, run 'device_download_sof \$d \$sof'"
  return
}

set m [lindex $masters 0]
open_service master $m

puts ""
puts "=> Fejkon system console initialized"
puts ""
puts " Master is available at \$m"
puts ""

if {![jtag_debug_sense_clock $m]} {
  puts " ==> WARNING: Clock not detected as running <=="
  puts ""
}

puts " E.g:"
puts " - master_write_32 \$m 0x000e0000 5"
puts " - jtag_debug_reset_system \$m"
puts " - sfp \[1-4]"
puts " - enable \[1-4]"
puts " - fcstat \[1-4]"
puts " - pcie"
puts " - clocks"
puts " - id"

proc id {} {
  global m
  set off [expr 0x0]
  master_write_32 $m [expr $off] 0
  puts [format " Version  : %s" [master_read_8 $m [expr $off + 0x2] 1]]
  set po [master_read_8 $m [expr $off + 0x3] 1]
  set fc_ports [expr $po & 0xf]
  set eth_ports [expr ($po >> 4) & 0xf]
  puts [format " Ports    : FC %s Ethernet %s" $fc_ports $eth_ports]
  puts [format " Git rev. : %s" [master_read_32 $m [expr $off + 0x4] 1]]
}

proc ltssm_str {state} {
  switch $state {
    0  { return "Detect.Quiet" }
    1  { return "Detect.Active" }
    2  { return "Polling.Active" }
    3  { return "Polling.Compliance" }
    4  { return "Polling.Configuration" }
    5  { return "Polling.Speed" }
    6  { return "config.Linkwidthstart" }
    7  { return "Config.Linkaccept" }
    8  { return "Config.Lanenumaccept" }
    9  { return "Config.Lanenumwait" }
    10 { return "Config.Complete" }
    11 { return "Config.Idle" }
    12 { return "Recovery.Rcvlock" }
    13 { return "Recovery.Rcvconfig" }
    14 { return "Recovery.Idle" }
    15 { return "L0" }
    16 { return "Disable" }
    17 { return "Loopback.Entry" }
    18 { return "Loopback.Active" }
    19 { return "Loopback.Exit" }
    20 { return "Hot.Reset" }
    21 { return "LOs" }
    25 { return "L2.transmit.Wake" }
    26 { return "Recovery.Speed" }
    27 { return "Recovery.Equalization, Phase 0" }
    28 { return "Recovery.Equalization, Phase 1" }
    29 { return "Recovery.Equalization, Phase 2" }
    30 { return "Recovery.Equalization, Phase 3" }
    31 { return "Recovery.Equalization, Done" }
    default { return "<Unknown>" }
  }
}

proc pcie {} {
  global m
  set off [expr 0x800]
  set ltssm [expr [master_read_8 $m [expr $off + 0x180] 1]]
  puts [format " LTSSM state          : %s (0x%02x)" [ltssm_str $ltssm] $ltssm]
  puts [format " Lanes active         : %s" [format "x%d" [master_read_8 $m [expr $off + 0x181] 1]]]
  puts [format " My ID                : %s" [master_read_16 $m [expr $off + 0x00] 1]]
  puts ""
  puts [format " TLP RX               : %s" [master_read_32 $m [expr $off + 0x04] 1]]
  puts [format " TLP Unsupported RX   : %s" [master_read_32 $m [expr $off + 0x08] 1]]
  puts [format " TLP TX Data          : %s" [master_read_32 $m [expr $off + 0x0c] 1]]
  puts [format " TLP TX Instant       : %s" [master_read_32 $m [expr $off + 0x10] 1]]
  puts [format " TLP TX Response      : %s" [master_read_32 $m [expr $off + 0x14] 1]]
  puts ""
  puts [format " Last TLP RX          : %s" [master_read_32 $m [expr $off + 0x20] 8]]
  puts [format " Last TLP TX Data     : %s" [master_read_32 $m [expr $off + 0x40] 8]]
  puts [format " Last TLP TX Instant  : %s" [master_read_32 $m [expr $off + 0x60] 8]]
  puts [format " Last TLP TX Response : %s" [master_read_32 $m [expr $off + 0x80] 8]]
  puts ""
  puts [format " C2H Packet counter   : %s" [master_read_32 $m [expr $off + 0x18] 1]]
  puts [format " C2H Start address    : %s" [master_read_32 $m [expr $off + 0xA0] 1]]
  puts [format " C2H End address      : %s" [master_read_32 $m [expr $off + 0xA4] 1]]
  puts [format " C2H Host read ptr    : %s" [master_read_32 $m [expr $off + 0xA8] 1]]
  puts [format " C2H Card write ptr   : %s" [master_read_32 $m [expr $off + 0xAC] 1]]
}

proc clocks {} {
  global m
  set off [expr 0x20]
  puts [format " PHY  : %s MHz" [format "%.3f" [expr [master_read_32 $m [expr $off + 0x00] 1] / 1000000.0]]]
  puts [format " PCIe : %s MHz" [format "%.3f" [expr [master_read_32 $m [expr $off + 0x04] 1] / 1000000.0]]]
}

proc check_fc_port {id} {
  global m
  set po [master_read_8 $m 0x3 1]
  set fc_ports [expr $po & 0xf]
  if {$id > $fc_ports} {
    puts [format " ** WARNING ** Accessing past last FC port (# FC ports = %s)" $fc_ports]
  }
  if {$id <= 0} {
    puts [format "FC Port IDs start at 1"]
    return false
  }
  return true
}

proc check_eth_port {id} {
  global m
  set po [master_read_8 $m 0x3 1]
  set eth_ports [expr ($po >> 4) & 0xf]
  if {$id > [expr 2 + $eth_ports]} {
    puts [format " ** WARNING ** Accessing past last Ethernet port (# Ethernet ports = %s)" $eth_ports]
  }
  if {$id <= 2} {
    puts [format "Ethernet Port IDs start at 3"]
    return false
  }
  return true
}

proc check_port {id} {
  global m
  set po [master_read_8 $m 0x3 1]
  set fc_ports [expr $po & 0xf]
  set eth_ports [expr ($po >> 4) & 0xf]
  set ports [expr $fc_ports + $eth_ports]
  if {$id > $ports} {
    puts [format " ** WARNING ** Accessing past last port (# ports = %s)" $ports]
  }
  if {$id <= 0} {
    puts [format "Port IDs start at 1"]
    return false
  }
  return true
}

proc enable {id} {
  if {![check_fc_port $id]} {
    return
  }
  global m
  set off [expr 0x100 * $id]
  master_write_32 $m [expr $off] 0
}

proc fcstat {id} {
  if {![check_fc_port $id]} {
    return
  }
  global m
  set off [expr 0x6000 + $id * 0x2000]
  puts [format " XCVR      : %s" [master_read_32 $m [expr $off + 0x00 * 4] 1]]
  puts [format " Last Unk. : %s" [master_read_32 $m [expr $off + 0x01 * 4] 1]]
  puts [format " State     : %s" [master_read_32 $m [expr $off + 0x1000] 1]]
  puts         " -- Prims         RX         TX"
  # TODO: Calculate rate?
  puts [format " IDLE      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x00 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x00 * 4] 1]]
  puts [format " R_RDY     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x01 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x01 * 4] 1]]
  puts [format " VC_RDY    : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x02 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x02 * 4] 1]]
  puts [format " BB_SCS    : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x03 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x03 * 4] 1]]
  puts [format " BB_SCR    : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x04 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x04 * 4] 1]]
  puts [format " SOFi2     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x05 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x05 * 4] 1]]
  puts [format " SOFn2     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x06 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x06 * 4] 1]]
  puts [format " SOFi3     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x07 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x07 * 4] 1]]
  puts [format " SOFn3     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x08 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x08 * 4] 1]]
  puts [format " SOFf      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x09 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x09 * 4] 1]]
  puts [format " EOFt      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0a * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0a * 4] 1]]
  puts [format " EOFa      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0b * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0b * 4] 1]]
  puts [format " EOFn      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0c * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0c * 4] 1]]
  puts [format " EOFni     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0d * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0d * 4] 1]]
  puts [format " NOS       : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0e * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0e * 4] 1]]
  puts [format " OLS       : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0f * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0f * 4] 1]]
  puts [format " LR        : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x10 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x10 * 4] 1]]
  puts [format " LRR       : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x11 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x11 * 4] 1]]
  puts [format " ARBff     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x12 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x12 * 4] 1]]
  puts [format " Unknown   : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x13 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x13 * 4] 1]]
}

proc sfp {id} {
  if {![check_port $id]} {
    return
  }
  global m
  set off [expr 0x100 * $id]
  set status [master_read_8 $m $off 1]
  puts [format " SFP status: %s" $status]

  if {[expr $status & 1] != 0} {
    puts [format " - SFP present"]
  } else {
    puts [format " - SFP *not* present"]
  }

  if {[expr $status & 2] != 0} {
    puts [format " - Loss of signal detected"]
  }

  if {[expr $status & 4] != 0} {
    puts [format " - TX fault detected"]
  }

  if {[expr $status & 8] != 0} {
    puts [format " - TX is disabled"]
  } else {
    puts [format " - TX is enabled"]
  }

  if {[expr $status & 1] == 0} {
    # Only probe the SFP port if it is reported as present
    return
  }

  master_write_32 $m [expr $off + 0x48] 0
  # Configure ISER, SCL_LOW, SCL_HIGH, SDA_HOLD register
  master_write_32 $m [expr $off + 0x4c] 0x0 ; # No interrupts
  master_write_32 $m [expr $off + 0x60] 250
  master_write_32 $m [expr $off + 0x64] 250
  master_write_32 $m [expr $off + 0x68] 15
  master_write_32 $m [expr $off + 0x48] 1
  # Read three byte @ 0x0
  master_write_32 $m [expr $off + 0x40] 0x2A0
  master_write_32 $m [expr $off + 0x40] 0x000
  master_write_32 $m [expr $off + 0x40] 0x2A1
  master_write_32 $m [expr $off + 0x40] 0x000
  master_write_32 $m [expr $off + 0x40] 0x000
  master_write_32 $m [expr $off + 0x40] 0x100

  puts [format " SFP identifier: %s" [master_read_8 $m [expr $off + 0x44] 1]]
  puts [format " SFP ext. identifier: %s" [master_read_8 $m [expr $off + 0x44] 1]]
  puts [format " SFP connector: %s" [master_read_8 $m [expr $off + 0x44] 1]]

  # Read vendor @ 0x14
  master_write_32 $m [expr $off + 0x40] 0x2A0
  master_write_32 $m [expr $off + 0x40] 0x014
  master_write_32 $m [expr $off + 0x40] 0x2A1

  master_write_32 $m [expr $off + 0x40] 0x000
  set vendor [master_read_8 $m [expr $off + 0x44] 1]

  for {set i 0} {$i < 14} {incr i} {
    master_write_32 $m [expr $off + 0x40] 0x000
    lappend vendor [master_read_8 $m [expr $off + 0x44] 1]
  }

  master_write_32 $m [expr $off + 0x40] 0x100
  lappend vendor [master_read_8 $m [expr $off + 0x44] 1]

  puts [format " SFP vendor: '%s'" [binary format c* $vendor]]

  # Read vendor PN @ 0x28
  master_write_32 $m [expr $off + 0x40] 0x2A0
  master_write_32 $m [expr $off + 0x40] 0x028
  master_write_32 $m [expr $off + 0x40] 0x2A1

  master_write_32 $m [expr $off + 0x40] 0x000
  set vendor [master_read_8 $m [expr $off + 0x44] 1]

  for {set i 0} {$i < 14} {incr i} {
    master_write_32 $m [expr $off + 0x40] 0x000
    lappend vendor [master_read_8 $m [expr $off + 0x44] 1]
  }

  master_write_32 $m [expr $off + 0x40] 0x100
  lappend vendor [master_read_8 $m [expr $off + 0x44] 1]

  puts [format " SFP vendor PN: '%s'" [binary format c* $vendor]]

  # Read vendor SN @ 0x44
  master_write_32 $m [expr $off + 0x40] 0x2A0
  master_write_32 $m [expr $off + 0x40] 0x044
  master_write_32 $m [expr $off + 0x40] 0x2A1

  master_write_32 $m [expr $off + 0x40] 0x000
  set vendor [master_read_8 $m [expr $off + 0x44] 1]

  for {set i 0} {$i < 14} {incr i} {
    master_write_32 $m [expr $off + 0x40] 0x000
    lappend vendor [master_read_8 $m [expr $off + 0x44] 1]
  }

  master_write_32 $m [expr $off + 0x40] 0x100
  lappend vendor [master_read_8 $m [expr $off + 0x44] 1]

  puts [format " SFP vendor SN: '%s'" [binary format c* $vendor]]
}

proc generate {pkts} {
  global m
  master_write_32 $m 0x40 $pkts
}
