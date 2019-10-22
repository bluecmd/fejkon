onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold -label ref_clk /top_tb/dut/ref_clk
add wave -noupdate -color {Cornflower Blue} -label probe_clk /top_tb/dut/probe_clk
add wave -noupdate -label measure /top_tb/dut/measure
add wave -noupdate -label process /top_tb/dut/process
add wave -noupdate -label counter /top_tb/dut/counter
add wave -noupdate -label mm_readdata -radix unsigned -childformat {{{/top_tb/dut/mm_readdata[31]} -radix unsigned} {{/top_tb/dut/mm_readdata[30]} -radix unsigned} {{/top_tb/dut/mm_readdata[29]} -radix unsigned} {{/top_tb/dut/mm_readdata[28]} -radix unsigned} {{/top_tb/dut/mm_readdata[27]} -radix unsigned} {{/top_tb/dut/mm_readdata[26]} -radix unsigned} {{/top_tb/dut/mm_readdata[25]} -radix unsigned} {{/top_tb/dut/mm_readdata[24]} -radix unsigned} {{/top_tb/dut/mm_readdata[23]} -radix unsigned} {{/top_tb/dut/mm_readdata[22]} -radix unsigned} {{/top_tb/dut/mm_readdata[21]} -radix unsigned} {{/top_tb/dut/mm_readdata[20]} -radix unsigned} {{/top_tb/dut/mm_readdata[19]} -radix unsigned} {{/top_tb/dut/mm_readdata[18]} -radix unsigned} {{/top_tb/dut/mm_readdata[17]} -radix unsigned} {{/top_tb/dut/mm_readdata[16]} -radix unsigned} {{/top_tb/dut/mm_readdata[15]} -radix unsigned} {{/top_tb/dut/mm_readdata[14]} -radix unsigned} {{/top_tb/dut/mm_readdata[13]} -radix unsigned} {{/top_tb/dut/mm_readdata[12]} -radix unsigned} {{/top_tb/dut/mm_readdata[11]} -radix unsigned} {{/top_tb/dut/mm_readdata[10]} -radix unsigned} {{/top_tb/dut/mm_readdata[9]} -radix unsigned} {{/top_tb/dut/mm_readdata[8]} -radix unsigned} {{/top_tb/dut/mm_readdata[7]} -radix unsigned} {{/top_tb/dut/mm_readdata[6]} -radix unsigned} {{/top_tb/dut/mm_readdata[5]} -radix unsigned} {{/top_tb/dut/mm_readdata[4]} -radix unsigned} {{/top_tb/dut/mm_readdata[3]} -radix unsigned} {{/top_tb/dut/mm_readdata[2]} -radix unsigned} {{/top_tb/dut/mm_readdata[1]} -radix unsigned} {{/top_tb/dut/mm_readdata[0]} -radix unsigned}} -radixshowbase 0 -subitemconfig {{/top_tb/dut/mm_readdata[31]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[30]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[29]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[28]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[27]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[26]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[25]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[24]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[23]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[22]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[21]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[20]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[19]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[18]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[17]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[16]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[15]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[14]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[13]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[12]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[11]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[10]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[9]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[8]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[7]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[6]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[5]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[4]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[3]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[2]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[1]} {-height 16 -radix unsigned -radixshowbase 0} {/top_tb/dut/mm_readdata[0]} {-height 16 -radix unsigned -radixshowbase 0}} /top_tb/dut/mm_readdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10000999106 ps} 0}
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
WaveRestoreZoom {2025002500 ps} {12526052500 ps}
