onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/dut/fcport0_aligned
add wave -noupdate /top_tb/dut/fcport0_active
add wave -noupdate /top_tb/dut/fcport1_aligned
add wave -noupdate /top_tb/dut/fcport1_active
add wave -noupdate /top_tb/dut/fcport2_aligned
add wave -noupdate /top_tb/dut/fcport2_active
add wave -noupdate /top_tb/dut/fcport3_aligned
add wave -noupdate /top_tb/dut/fcport3_active
add wave -noupdate /top_tb/dut/reconfig_busy
add wave -noupdate /top_tb/dut/led_bracket
add wave -noupdate /top_tb/dut/led_rj45
add wave -noupdate /top_tb/dut/led_board
add wave -noupdate -expand /top_tb/dut/led
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 239
configure wave -valuecolwidth 179
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {3150 ms}
