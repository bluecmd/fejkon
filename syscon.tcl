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
puts " - sfp 1"
puts " - enable 1"
puts " - fcstat 1"

puts ""

proc enable {id} {
  global m
  set off [expr 0x1000 * $id]
  master_write_32 $m [expr $off] 0
}

proc fcstat {id} {
  global m
  set off [expr 0x10000 * $id]
  puts [format " XCVR      : %s" [master_read_32 $m [expr $off + 0x00 * 4] 1]]
  puts [format " State     : %s" [master_read_32 $m [expr $off + 0x01 * 4] 1]]
  puts         " -- Prims         RX         TX"
  # TODO: Calculate rate?
  puts [format " IDLE      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x00 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x00 * 4] 1]]
  puts [format " R_RDY     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x01 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x01 * 4] 1]]
  puts [format " BB_SCS    : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x02 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x02 * 4] 1]]
  puts [format " BB_SCR    : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x03 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x03 * 4] 1]]
  puts [format " SOFc1     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x04 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x04 * 4] 1]]
  puts [format " SOFi1     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x05 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x05 * 4] 1]]
  puts [format " SOFN1     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x06 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x06 * 4] 1]]
  puts [format " SOFi2     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x07 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x07 * 4] 1]]
  puts [format " SOFn2     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x08 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x08 * 4] 1]]
  puts [format " SOFi3     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x09 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x09 * 4] 1]]
  puts [format " SOFn3     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0a * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0a * 4] 1]]
  puts [format " SOFc4     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0b * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0b * 4] 1]]
  puts [format " SOFi4     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0c * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0c * 4] 1]]
  puts [format " SOFn4     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0d * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0d * 4] 1]]
  puts [format " SOFf      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0e * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0e * 4] 1]]
  puts [format " EOFt      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x0f * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x0f * 4] 1]]
  puts [format " EOFdt     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x10 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x10 * 4] 1]]
  puts [format " EOFa      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x11 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x11 * 4] 1]]
  puts [format " EOFn      : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x12 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x12 * 4] 1]]
  puts [format " EOFni     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x13 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x13 * 4] 1]]
  puts [format " EOFdti    : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x14 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x14 * 4] 1]]
  puts [format " EOFrt     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x15 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x15 * 4] 1]]
  puts [format " EOFrti    : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x16 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x16 * 4] 1]]
  puts [format " NOS       : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x17 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x17 * 4] 1]]
  puts [format " OLS       : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x18 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x18 * 4] 1]]
  puts [format " LR        : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x19 * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x19 * 4] 1]]
  puts [format " LRR       : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x1a * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x1a * 4] 1]]
  puts [format " ARBff     : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x1b * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x1b * 4] 1]]
  puts [format " Unknown   : %s %s" [master_read_32 $m [expr $off + 0x80 + 0x1c * 4] 1] [master_read_32 $m [expr $off + 0x100 + 0x1c * 4] 1]]
}

proc sfp {id} {
  global m
  set off [expr 0x1000 * $id]
  puts [format " SFP status: %s" [master_read_8 $m $off 1]]
  # TODO: Verify that there is an SFP in the slot
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
