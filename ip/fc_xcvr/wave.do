onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group framer0 -label state /top_tb/tb/tb_inst/framer0/state

add wave -noupdate -expand -group xcvr0 -group TX -label tx_clk /top_tb/tb/tb_inst/xcvr0/tx_clk
add wave -noupdate -expand -group xcvr0 -group TX -label avtx_data /top_tb/tb/tb_inst/xcvr0/avtx_data
add wave -noupdate -expand -group xcvr0 -group TX -label avtx_valid /top_tb/tb/tb_inst/xcvr0/avtx_valid
add wave -noupdate -expand -group xcvr0 -group RX -label rx_clk /top_tb/tb/tb_inst/xcvr0/rx_clk
add wave -noupdate -expand -group xcvr0 -group RX -label avrx_data /top_tb/tb/tb_inst/xcvr0/avrx_data
add wave -noupdate -expand -group xcvr0 -group RX -label avrx_valid /top_tb/tb/tb_inst/xcvr0/avrx_valid
add wave -noupdate -expand -group xcvr0 -label reset /top_tb/tb/tb_inst/xcvr0/reset
add wave -noupdate -expand -group xcvr0 -label mgmt_clk /top_tb/tb/tb_inst/xcvr0/mgmt_clk
add wave -noupdate -expand -group xcvr0 -label phy_clk /top_tb/tb/tb_inst/phy0_clk_clk
add wave -noupdate -expand -group xcvr0 -group {Mgmt Avalon} -label address /top_tb/tb/tb_inst/xcvr0/mm_address
add wave -noupdate -expand -group xcvr0 -group {Mgmt Avalon} -label waitrequest /top_tb/tb/tb_inst/xcvr0/mm_waitrequest
add wave -noupdate -expand -group xcvr0 -group {Mgmt Avalon} -label read /top_tb/tb/tb_inst/xcvr0/mm_read
add wave -noupdate -expand -group xcvr0 -group {Mgmt Avalon} -label write /top_tb/tb/tb_inst/xcvr0/mm_write
add wave -noupdate -expand -group xcvr0 -group {Mgmt Avalon} -label readdata /top_tb/tb/tb_inst/xcvr0/mm_readdata
add wave -noupdate -expand -group xcvr0 -group {Mgmt Avalon} -label writedata /top_tb/tb/tb_inst/xcvr0/mm_writedata
add wave -noupdate -expand -group xcvr0 -group LVDS -color Yellow -label {Ref. 8G Clock} /top_tb/ref_8g_clk
add wave -noupdate -expand -group xcvr0 -group LVDS -label {Ref. 10B} -radix hexadecimal /top_tb/symbol_rr
add wave -noupdate -expand -group xcvr0 -group LVDS -label {Ref. Symbol Name} /top_tb/symbol
add wave -noupdate -expand -group xcvr0 -group LVDS -label rd_p /top_tb/tb/tb_inst/xcvr0/rd_p
add wave -noupdate -expand -group xcvr0 -group LVDS -label td_p /top_tb/tb/tb_inst/xcvr0/td_p
add wave -noupdate -expand -group xcvr0 -label pll_locked /top_tb/tb/tb_inst/xcvr0/pll_locked
add wave -noupdate -expand -group xcvr0 -label is_aligned /top_tb/tb/tb_inst/xcvr0/is_aligned
add wave -noupdate -expand -group xcvr0 -label tx_prim /top_tb/tb/tb_inst/xcvr0/tx_prim
add wave -noupdate -expand -group xcvr0 -label rx_prim /top_tb/tb/tb_inst/xcvr0/rx_prim
add wave -noupdate -expand -group xcvr0 -group PHY -label rx_syncstatus /top_tb/tb/tb_inst/xcvr0/phy/rx_syncstatus
add wave -noupdate -expand -group xcvr0 -group PHY -label rx_patterndetect /top_tb/tb/tb_inst/xcvr0/phy/rx_patterndetect
add wave -noupdate -expand -group xcvr0 -group PHY -label rx_errdetect /top_tb/tb/tb_inst/xcvr0/phy/rx_errdetect
add wave -noupdate -expand -group xcvr0 -group PHY -label tx_parallel_data /top_tb/tb/tb_inst/xcvr0/phy/tx_parallel_data
add wave -noupdate -expand -group xcvr0 -group PHY -label tx_datak /top_tb/tb/tb_inst/xcvr0/phy/tx_datak
add wave -noupdate -expand -group xcvr0 -group PHY -label tx_ready /top_tb/tb/tb_inst/xcvr0/phy/tx_ready
add wave -noupdate -expand -group xcvr0 -group PHY -label rx_parallel_data /top_tb/tb/tb_inst/xcvr0/phy/rx_parallel_data
add wave -noupdate -expand -group xcvr0 -group PHY -label rx_datak /top_tb/tb/tb_inst/xcvr0/phy/rx_datak
add wave -noupdate -expand -group xcvr0 -group PHY -label rx_ready /top_tb/tb/tb_inst/xcvr0/phy/rx_ready
add wave -noupdate -expand -group xcvr0 -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvr0/tx_primitive_cntrs
add wave -noupdate -expand -group xcvr0 -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvr0/rx_primitive_cntrs

add wave -noupdate -expand -group xcvrA -group TX -label tx_clk /top_tb/tb/tb_inst/xcvra/tx_clk
add wave -noupdate -expand -group xcvrA -group TX -label avtx_data /top_tb/tb/tb_inst/xcvra/avtx_data
add wave -noupdate -expand -group xcvrA -group TX -label avtx_valid /top_tb/tb/tb_inst/xcvra/avtx_valid
add wave -noupdate -expand -group xcvrA -group RX -label rx_clk /top_tb/tb/tb_inst/xcvra/rx_clk
add wave -noupdate -expand -group xcvrA -group RX -label avrx_data /top_tb/tb/tb_inst/xcvra/avrx_data
add wave -noupdate -expand -group xcvrA -group RX -label avrx_valid /top_tb/tb/tb_inst/xcvra/avrx_valid
add wave -noupdate -expand -group xcvrA -label reset /top_tb/tb/tb_inst/xcvra/reset
add wave -noupdate -expand -group xcvrA -label mgmt_clk /top_tb/tb/tb_inst/xcvra/mgmt_clk
add wave -noupdate -expand -group xcvrA -label phy_clk /top_tb/tb/tb_inst/phya_clk_clk
add wave -noupdate -expand -group xcvrA -group {Mgmt Avalon} -label address /top_tb/tb/tb_inst/xcvra/mm_address
add wave -noupdate -expand -group xcvrA -group {Mgmt Avalon} -label waitrequest /top_tb/tb/tb_inst/xcvra/mm_waitrequest
add wave -noupdate -expand -group xcvrA -group {Mgmt Avalon} -label read /top_tb/tb/tb_inst/xcvra/mm_read
add wave -noupdate -expand -group xcvrA -group {Mgmt Avalon} -label write /top_tb/tb/tb_inst/xcvra/mm_write
add wave -noupdate -expand -group xcvrA -group {Mgmt Avalon} -label readdata /top_tb/tb/tb_inst/xcvra/mm_readdata
add wave -noupdate -expand -group xcvrA -group {Mgmt Avalon} -label writedata /top_tb/tb/tb_inst/xcvra/mm_writedata
add wave -noupdate -expand -group xcvrA -group LVDS -label rd_p /top_tb/tb/tb_inst/xcvra/rd_p
add wave -noupdate -expand -group xcvrA -group LVDS -label td_p /top_tb/tb/tb_inst/xcvra/td_p
add wave -noupdate -expand -group xcvrA -label pll_locked /top_tb/tb/tb_inst/xcvra/pll_locked
add wave -noupdate -expand -group xcvrA -label is_aligned /top_tb/tb/tb_inst/xcvra/is_aligned
add wave -noupdate -expand -group xcvrA -label tx_prim /top_tb/tb/tb_inst/xcvra/tx_prim
add wave -noupdate -expand -group xcvrA -label rx_prim /top_tb/tb/tb_inst/xcvra/rx_prim
add wave -noupdate -expand -group xcvrA -group PHY -label rx_syncstatus /top_tb/tb/tb_inst/xcvra/phy/rx_syncstatus
add wave -noupdate -expand -group xcvrA -group PHY -label rx_patterndetect /top_tb/tb/tb_inst/xcvra/phy/rx_patterndetect
add wave -noupdate -expand -group xcvrA -group PHY -label rx_errdetect /top_tb/tb/tb_inst/xcvra/phy/rx_errdetect
add wave -noupdate -expand -group xcvrA -group PHY -label tx_parallel_data /top_tb/tb/tb_inst/xcvra/phy/tx_parallel_data
add wave -noupdate -expand -group xcvrA -group PHY -label tx_datak /top_tb/tb/tb_inst/xcvra/phy/tx_datak
add wave -noupdate -expand -group xcvrA -group PHY -label tx_ready /top_tb/tb/tb_inst/xcvra/phy/tx_ready
add wave -noupdate -expand -group xcvrA -group PHY -label rx_parallel_data /top_tb/tb/tb_inst/xcvra/phy/rx_parallel_data
add wave -noupdate -expand -group xcvrA -group PHY -label rx_datak /top_tb/tb/tb_inst/xcvra/phy/rx_datak
add wave -noupdate -expand -group xcvrA -group PHY -label rx_ready /top_tb/tb/tb_inst/xcvra/phy/rx_ready
add wave -noupdate -expand -group xcvrA -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvra/tx_primitive_cntrs
add wave -noupdate -expand -group xcvrA -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvra/rx_primitive_cntrs

add wave -noupdate -expand -group xcvrB -group TX -label tx_clk /top_tb/tb/tb_inst/xcvrb/tx_clk
add wave -noupdate -expand -group xcvrB -group TX -label avtx_data /top_tb/tb/tb_inst/xcvrb/avtx_data
add wave -noupdate -expand -group xcvrB -group TX -label avtx_valid /top_tb/tb/tb_inst/xcvrb/avtx_valid
add wave -noupdate -expand -group xcvrB -group RX -label rx_clk /top_tb/tb/tb_inst/xcvrb/rx_clk
add wave -noupdate -expand -group xcvrB -group RX -label avrx_data /top_tb/tb/tb_inst/xcvrb/avrx_data
add wave -noupdate -expand -group xcvrB -group RX -label avrx_valid /top_tb/tb/tb_inst/xcvrb/avrx_valid
add wave -noupdate -expand -group xcvrB -label reset /top_tb/tb/tb_inst/xcvrb/reset
add wave -noupdate -expand -group xcvrB -label mgmt_clk /top_tb/tb/tb_inst/xcvrb/mgmt_clk
add wave -noupdate -expand -group xcvrB -label phy_clk /top_tb/tb/tb_inst/phyb_clk_clk
add wave -noupdate -expand -group xcvrB -group {Mgmt Avalon} -label address /top_tb/tb/tb_inst/xcvrb/mm_address
add wave -noupdate -expand -group xcvrB -group {Mgmt Avalon} -label waitrequest /top_tb/tb/tb_inst/xcvrb/mm_waitrequest
add wave -noupdate -expand -group xcvrB -group {Mgmt Avalon} -label read /top_tb/tb/tb_inst/xcvrb/mm_read
add wave -noupdate -expand -group xcvrB -group {Mgmt Avalon} -label write /top_tb/tb/tb_inst/xcvrb/mm_write
add wave -noupdate -expand -group xcvrB -group {Mgmt Avalon} -label readdata /top_tb/tb/tb_inst/xcvrb/mm_readdata
add wave -noupdate -expand -group xcvrB -group {Mgmt Avalon} -label writedata /top_tb/tb/tb_inst/xcvrb/mm_writedata
add wave -noupdate -expand -group xcvrB -group LVDS -label rd_p /top_tb/tb/tb_inst/xcvrb/rd_p
add wave -noupdate -expand -group xcvrB -group LVDS -label td_p /top_tb/tb/tb_inst/xcvrb/td_p
add wave -noupdate -expand -group xcvrB -label pll_locked /top_tb/tb/tb_inst/xcvrb/pll_locked
add wave -noupdate -expand -group xcvrB -label is_aligned /top_tb/tb/tb_inst/xcvrb/is_aligned
add wave -noupdate -expand -group xcvrB -label tx_prim /top_tb/tb/tb_inst/xcvrb/tx_prim
add wave -noupdate -expand -group xcvrB -label rx_prim /top_tb/tb/tb_inst/xcvrb/rx_prim
add wave -noupdate -expand -group xcvrB -group PHY -label rx_syncstatus /top_tb/tb/tb_inst/xcvrb/phy/rx_syncstatus
add wave -noupdate -expand -group xcvrB -group PHY -label rx_patterndetect /top_tb/tb/tb_inst/xcvrb/phy/rx_patterndetect
add wave -noupdate -expand -group xcvrB -group PHY -label rx_errdetect /top_tb/tb/tb_inst/xcvrb/phy/rx_errdetect
add wave -noupdate -expand -group xcvrB -group PHY -label tx_parallel_data /top_tb/tb/tb_inst/xcvrb/phy/tx_parallel_data
add wave -noupdate -expand -group xcvrB -group PHY -label tx_datak /top_tb/tb/tb_inst/xcvrb/phy/tx_datak
add wave -noupdate -expand -group xcvrB -group PHY -label tx_ready /top_tb/tb/tb_inst/xcvrb/phy/tx_ready
add wave -noupdate -expand -group xcvrB -group PHY -label rx_parallel_data /top_tb/tb/tb_inst/xcvrb/phy/rx_parallel_data
add wave -noupdate -expand -group xcvrB -group PHY -label rx_datak /top_tb/tb/tb_inst/xcvrb/phy/rx_datak
add wave -noupdate -expand -group xcvrB -group PHY -label rx_ready /top_tb/tb/tb_inst/xcvrb/phy/rx_ready
add wave -noupdate -expand -group xcvrB -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvrb/tx_primitive_cntrs
add wave -noupdate -expand -group xcvrB -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvrb/rx_primitive_cntrs

add wave -noupdate -expand -group xcvr1 -group TX -label tx_clk /top_tb/tb/tb_inst/xcvr1/tx_clk
add wave -noupdate -expand -group xcvr1 -group TX -label avtx_data /top_tb/tb/tb_inst/xcvr1/avtx_data
add wave -noupdate -expand -group xcvr1 -group TX -label avtx_valid /top_tb/tb/tb_inst/xcvr1/avtx_valid
add wave -noupdate -expand -group xcvr1 -group RX -label rx_clk /top_tb/tb/tb_inst/xcvr1/rx_clk
add wave -noupdate -expand -group xcvr1 -group RX -label avrx_data /top_tb/tb/tb_inst/xcvr1/avrx_data
add wave -noupdate -expand -group xcvr1 -group RX -label avrx_valid /top_tb/tb/tb_inst/xcvr1/avrx_valid
add wave -noupdate -expand -group xcvr1 -label reset /top_tb/tb/tb_inst/xcvr1/reset
add wave -noupdate -expand -group xcvr1 -label mgmt_clk /top_tb/tb/tb_inst/xcvr1/mgmt_clk
add wave -noupdate -expand -group xcvr1 -label phy_clk /top_tb/tb/tb_inst/phy1_clk_clk
add wave -noupdate -expand -group xcvr1 -group {Mgmt Avalon} -label address /top_tb/tb/tb_inst/xcvr1/mm_address
add wave -noupdate -expand -group xcvr1 -group {Mgmt Avalon} -label waitrequest /top_tb/tb/tb_inst/xcvr1/mm_waitrequest
add wave -noupdate -expand -group xcvr1 -group {Mgmt Avalon} -label read /top_tb/tb/tb_inst/xcvr1/mm_read
add wave -noupdate -expand -group xcvr1 -group {Mgmt Avalon} -label write /top_tb/tb/tb_inst/xcvr1/mm_write
add wave -noupdate -expand -group xcvr1 -group {Mgmt Avalon} -label readdata /top_tb/tb/tb_inst/xcvr1/mm_readdata
add wave -noupdate -expand -group xcvr1 -group {Mgmt Avalon} -label writedata /top_tb/tb/tb_inst/xcvr1/mm_writedata
add wave -noupdate -expand -group xcvr1 -group LVDS -label rd_p /top_tb/tb/tb_inst/xcvr1/rd_p
add wave -noupdate -expand -group xcvr1 -group LVDS -label td_p /top_tb/tb/tb_inst/xcvr1/td_p
add wave -noupdate -expand -group xcvr1 -label pll_locked /top_tb/tb/tb_inst/xcvr1/pll_locked
add wave -noupdate -expand -group xcvr1 -label is_aligned /top_tb/tb/tb_inst/xcvr1/is_aligned
add wave -noupdate -expand -group xcvr1 -label tx_prim /top_tb/tb/tb_inst/xcvr1/tx_prim
add wave -noupdate -expand -group xcvr1 -label rx_prim /top_tb/tb/tb_inst/xcvr1/rx_prim
add wave -noupdate -expand -group xcvr1 -group PHY -label rx_syncstatus /top_tb/tb/tb_inst/xcvr1/phy/rx_syncstatus
add wave -noupdate -expand -group xcvr1 -group PHY -label rx_patterndetect /top_tb/tb/tb_inst/xcvr1/phy/rx_patterndetect
add wave -noupdate -expand -group xcvr1 -group PHY -label rx_errdetect /top_tb/tb/tb_inst/xcvr1/phy/rx_errdetect
add wave -noupdate -expand -group xcvr1 -group PHY -label tx_parallel_data /top_tb/tb/tb_inst/xcvr1/phy/tx_parallel_data
add wave -noupdate -expand -group xcvr1 -group PHY -label tx_datak /top_tb/tb/tb_inst/xcvr1/phy/tx_datak
add wave -noupdate -expand -group xcvr1 -group PHY -label tx_ready /top_tb/tb/tb_inst/xcvr1/phy/tx_ready
add wave -noupdate -expand -group xcvr1 -group PHY -label rx_parallel_data /top_tb/tb/tb_inst/xcvr1/phy/rx_parallel_data
add wave -noupdate -expand -group xcvr1 -group PHY -label rx_datak /top_tb/tb/tb_inst/xcvr1/phy/rx_datak
add wave -noupdate -expand -group xcvr1 -group PHY -label rx_ready /top_tb/tb/tb_inst/xcvr1/phy/rx_ready
add wave -noupdate -expand -group xcvr1 -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvr1/tx_primitive_cntrs
add wave -noupdate -expand -group xcvr1 -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvr1/rx_primitive_cntrs

add wave -noupdate -expand -group framer1 -label state /top_tb/tb/tb_inst/framer1/state

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {52982017 ps} 0}
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
WaveRestoreZoom {51120119 ps} {54697931 ps}
