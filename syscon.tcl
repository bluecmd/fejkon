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

puts ""
puts [format " SFP A status: %s" [master_read_8 $m 0x1000 1]]
# TODO: Verify that there is an SFP in the slot
master_write_32 $m 0x1040 0x2A0
master_write_32 $m 0x1040 0x000
master_write_32 $m 0x1040 0x100
master_write_32 $m 0x1048 1

puts [format " SFP A data: %s" [master_read_32 $m 0x1044 1]]
