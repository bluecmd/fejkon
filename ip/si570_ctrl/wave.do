onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /top_tb/clk
add wave -noupdate -label reset /top_tb/reset
add wave -noupdate -label sda /top_tb/sda
add wave -noupdate -label scl /top_tb/scl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {800000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2 us}
