set masters [get_service_paths master]
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
