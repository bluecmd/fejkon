onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /top_tb/clk
add wave -noupdate -label reset /top_tb/reset
add wave -noupdate -label reset_out /top_tb/dut/reset_out
add wave -noupdate -label scl /top_tb/scl
add wave -noupdate -label sda /top_tb/sda
add wave -noupdate -color {Medium Slate Blue} -label {TB: Section} /top_tb/section
add wave -noupdate -divider <NULL>
add wave -noupdate -color Gold -label {Tri-state scl} -radixshowbase 1 /top_tb/dut/scl_t
add wave -noupdate -label {TB: Detect} /top_tb/detect
add wave -noupdate -label {TB: Bit Counter} -radix decimal -radixshowbase 0 /top_tb/cntr
add wave -noupdate -label {TB: sda_oe} -radixshowbase 1 /top_tb/sda_oe
add wave -noupdate -label {Instruction #} -radix unsigned -radixshowbase 0 /top_tb/dut/instr
add wave -noupdate -label {TB: Writing?} -radix binary -radixshowbase 1 /top_tb/writing
add wave -noupdate -label {TB: Written Data} -radix unsigned -radixshowbase 0 /top_tb/data_stable
add wave -noupdate -group Internal -label instr_next -radix decimal /top_tb/dut/instr_next
add wave -noupdate -group Internal -label bus -expand /top_tb/dut/bus
add wave -noupdate -group Internal -label phy_state /top_tb/dut/i2c/phy_state_reg
add wave -noupdate -expand -group {Si570 Parameters} -label orig_hs_div -radix unsigned -radixshowbase 0 /top_tb/dut/orig_hs_div
add wave -noupdate -expand -group {Si570 Parameters} -label orig_n1 -radix unsigned -radixshowbase 0 /top_tb/dut/orig_n1
add wave -noupdate -expand -group {Si570 Parameters} -label orig_rfreq -radix unsigned /top_tb/dut/orig_rfreq
add wave -noupdate -expand -group {Si570 Parameters} -label orig_fdco -radix unsigned -radixshowbase 0 /top_tb/dut/orig_fdco
add wave -noupdate -expand -group {Si570 Parameters} -label new_hs_div -radix unsigned -radixshowbase 0 /top_tb/dut/new_hs_div
add wave -noupdate -expand -group {Si570 Parameters} -label new_n1 -radix unsigned -radixshowbase 0 /top_tb/dut/new_n1
add wave -noupdate -expand -group {Si570 Parameters} -label new_rfreq -radix hexadecimal -radixshowbase 0 /top_tb/dut/new_rfreq
add wave -noupdate -expand -group {Si570 Parameters} -label new_fdco -radix unsigned -radixshowbase 0 /top_tb/dut/new_fdco
add wave -noupdate -expand -group {Si570 Parameters} -label config_valid /top_tb/dut/config_valid
add wave -noupdate -expand -group {Si570 Parameters} -label fxtal_stable /top_tb/dut/fxtal_stable
add wave -noupdate -expand -group {Si570 Parameters} -label f_XTAL -radix unsigned -radixshowbase 0 /top_tb/dut/fxtal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1.4 ms} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 190
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
WaveRestoreZoom {0 ps} {1.6 ms}
