onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold -label ref_clk /top_tb/dut/ref_clk
add wave -noupdate -color {Cornflower Blue} -label probe_clk /top_tb/dut/probe_clk
add wave -noupdate -label measure /top_tb/dut/measure
add wave -noupdate -label process /top_tb/dut/process
add wave -noupdate -label counter -radix unsigned /top_tb/dut/counter
add wave -noupdate -label mm_readdata -radix unsigned -radixshowbase 0 /top_tb/dut/mm_readdata
add wave -noupdate -expand -group CDC -label {Measure #0} /top_tb/dut/measure
add wave -noupdate -expand -group CDC -label {Measure #1} /top_tb/dut/measure_cdc1
add wave -noupdate -expand -group CDC -label {Measure #2} /top_tb/dut/measure_cdc2
add wave -noupdate -expand -group CDC -label {Measure #3} /top_tb/dut/probe_measure
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11000000000 ps} 0}
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
configure wave -timelineunits ms
update
WaveRestoreZoom {601 us} {12601 us}
