onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group xcvr0 -group TX /top_tb/tb/tb_inst/xcvr0/tx_clk
add wave -noupdate -group xcvr0 -group TX /top_tb/tb/tb_inst/xcvr0/avtx_data
add wave -noupdate -group xcvr0 -group TX /top_tb/tb/tb_inst/xcvr0/avtx_valid
add wave -noupdate -group xcvr0 -group RX /top_tb/tb/tb_inst/xcvr0/rx_clk
add wave -noupdate -group xcvr0 -group RX /top_tb/tb/tb_inst/xcvr0/avrx_data
add wave -noupdate -group xcvr0 -group RX /top_tb/tb/tb_inst/xcvr0/avrx_valid
add wave -noupdate -group xcvr0 /top_tb/tb/tb_inst/xcvr0/reset
add wave -noupdate -group xcvr0 /top_tb/tb/tb_inst/xcvr0/mgmt_clk
add wave -noupdate -group xcvr0 /top_tb/tb/tb_inst/phy0_clk_clk
add wave -noupdate -group xcvr0 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr0/mm_address
add wave -noupdate -group xcvr0 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr0/mm_waitrequest
add wave -noupdate -group xcvr0 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr0/mm_read
add wave -noupdate -group xcvr0 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr0/mm_write
add wave -noupdate -group xcvr0 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr0/mm_readdata
add wave -noupdate -group xcvr0 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr0/mm_writedata
add wave -noupdate -group xcvr0 -group LVDS -color Yellow -label {Ref. 8G Clock} /top_tb/ref_8g_clk
add wave -noupdate -group xcvr0 -group LVDS -label {Ref. 10B} -radix hexadecimal /top_tb/symbol_rr
add wave -noupdate -group xcvr0 -group LVDS -label {Ref. Symbol Name} /top_tb/symbol
add wave -noupdate -group xcvr0 -group LVDS /top_tb/tb/tb_inst/xcvr0/rd_p
add wave -noupdate -group xcvr0 -group LVDS /top_tb/tb/tb_inst/xcvr0/td_p
add wave -noupdate -group xcvr0 /top_tb/tb/tb_inst/xcvr0/pll_locked
add wave -noupdate -group xcvr0 /top_tb/tb/tb_inst/xcvr0/is_aligned
add wave -noupdate -group xcvr0 /top_tb/tb/tb_inst/xcvr0/tx_prim
add wave -noupdate -group xcvr0 /top_tb/tb/tb_inst/xcvr0/rx_prim
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/rx_syncstatus
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/rx_patterndetect
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/rx_errdetect
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/tx_parallel_data
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/tx_datak
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/tx_ready
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/rx_parallel_data
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/rx_datak
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/rx_ready
add wave -noupdate -group xcvr0 -group PHY /top_tb/tb/tb_inst/xcvr0/phy/rx_runningdisp
add wave -noupdate -group xcvr0 -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvr0/tx_primitive_cntrs
add wave -noupdate -group xcvr0 -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvr0/rx_primitive_cntrs
add wave -noupdate -group xcvrA -group TX /top_tb/tb/tb_inst/xcvra/tx_clk
add wave -noupdate -group xcvrA -group TX /top_tb/tb/tb_inst/xcvra/avtx_data
add wave -noupdate -group xcvrA -group TX /top_tb/tb/tb_inst/xcvra/avtx_valid
add wave -noupdate -group xcvrA -group RX /top_tb/tb/tb_inst/xcvra/rx_clk
add wave -noupdate -group xcvrA -group RX /top_tb/tb/tb_inst/xcvra/avrx_data
add wave -noupdate -group xcvrA -group RX /top_tb/tb/tb_inst/xcvra/avrx_valid
add wave -noupdate -group xcvrA /top_tb/tb/tb_inst/xcvra/reset
add wave -noupdate -group xcvrA /top_tb/tb/tb_inst/xcvra/mgmt_clk
add wave -noupdate -group xcvrA /top_tb/tb/tb_inst/phya_clk_clk
add wave -noupdate -group xcvrA -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvra/mm_address
add wave -noupdate -group xcvrA -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvra/mm_waitrequest
add wave -noupdate -group xcvrA -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvra/mm_read
add wave -noupdate -group xcvrA -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvra/mm_write
add wave -noupdate -group xcvrA -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvra/mm_readdata
add wave -noupdate -group xcvrA -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvra/mm_writedata
add wave -noupdate -group xcvrA -group LVDS /top_tb/tb/tb_inst/xcvra/rd_p
add wave -noupdate -group xcvrA -group LVDS /top_tb/tb/tb_inst/xcvra/td_p
add wave -noupdate -group xcvrA /top_tb/tb/tb_inst/xcvra/pll_locked
add wave -noupdate -group xcvrA /top_tb/tb/tb_inst/xcvra/is_aligned
add wave -noupdate -group xcvrA /top_tb/tb/tb_inst/xcvra/tx_prim
add wave -noupdate -group xcvrA /top_tb/tb/tb_inst/xcvra/rx_prim
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/rx_syncstatus
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/rx_patterndetect
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/rx_errdetect
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/tx_parallel_data
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/tx_datak
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/tx_ready
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/rx_parallel_data
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/rx_datak
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/rx_ready
add wave -noupdate -group xcvrA -group PHY /top_tb/tb/tb_inst/xcvra/phy/rx_runningdisp
add wave -noupdate -group xcvrA -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvra/tx_primitive_cntrs
add wave -noupdate -group xcvrA -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvra/rx_primitive_cntrs
add wave -noupdate -group xcvrB -group TX /top_tb/tb/tb_inst/xcvrb/tx_clk
add wave -noupdate -group xcvrB -group TX /top_tb/tb/tb_inst/xcvrb/avtx_data
add wave -noupdate -group xcvrB -group TX /top_tb/tb/tb_inst/xcvrb/avtx_valid
add wave -noupdate -group xcvrB -group RX /top_tb/tb/tb_inst/xcvrb/rx_clk
add wave -noupdate -group xcvrB -group RX /top_tb/tb/tb_inst/xcvrb/avrx_data
add wave -noupdate -group xcvrB -group RX /top_tb/tb/tb_inst/xcvrb/avrx_valid
add wave -noupdate -group xcvrB /top_tb/tb/tb_inst/xcvrb/reset
add wave -noupdate -group xcvrB /top_tb/tb/tb_inst/xcvrb/mgmt_clk
add wave -noupdate -group xcvrB /top_tb/tb/tb_inst/phyb_clk_clk
add wave -noupdate -group xcvrB -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvrb/mm_address
add wave -noupdate -group xcvrB -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvrb/mm_waitrequest
add wave -noupdate -group xcvrB -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvrb/mm_read
add wave -noupdate -group xcvrB -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvrb/mm_write
add wave -noupdate -group xcvrB -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvrb/mm_readdata
add wave -noupdate -group xcvrB -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvrb/mm_writedata
add wave -noupdate -group xcvrB -group LVDS /top_tb/tb/tb_inst/xcvrb/rd_p
add wave -noupdate -group xcvrB -group LVDS /top_tb/tb/tb_inst/xcvrb/td_p
add wave -noupdate -group xcvrB /top_tb/tb/tb_inst/xcvrb/pll_locked
add wave -noupdate -group xcvrB /top_tb/tb/tb_inst/xcvrb/is_aligned
add wave -noupdate -group xcvrB /top_tb/tb/tb_inst/xcvrb/tx_prim
add wave -noupdate -group xcvrB /top_tb/tb/tb_inst/xcvrb/rx_prim
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/rx_syncstatus
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/rx_patterndetect
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/rx_errdetect
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/tx_parallel_data
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/tx_datak
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/tx_ready
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/rx_parallel_data
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/rx_datak
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/rx_ready
add wave -noupdate -group xcvrB -group PHY /top_tb/tb/tb_inst/xcvrb/phy/rx_runningdisp
add wave -noupdate -group xcvrB -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvrb/tx_primitive_cntrs
add wave -noupdate -group xcvrB -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvrb/rx_primitive_cntrs
add wave -noupdate -group xcvr1 -group TX /top_tb/tb/tb_inst/xcvr1/tx_clk
add wave -noupdate -group xcvr1 -group TX /top_tb/tb/tb_inst/xcvr1/avtx_data
add wave -noupdate -group xcvr1 -group TX /top_tb/tb/tb_inst/xcvr1/avtx_valid
add wave -noupdate -group xcvr1 -group RX /top_tb/tb/tb_inst/xcvr1/rx_clk
add wave -noupdate -group xcvr1 -group RX /top_tb/tb/tb_inst/xcvr1/avrx_data
add wave -noupdate -group xcvr1 -group RX /top_tb/tb/tb_inst/xcvr1/avrx_valid
add wave -noupdate -group xcvr1 /top_tb/tb/tb_inst/xcvr1/reset
add wave -noupdate -group xcvr1 /top_tb/tb/tb_inst/xcvr1/mgmt_clk
add wave -noupdate -group xcvr1 /top_tb/tb/tb_inst/phy1_clk_clk
add wave -noupdate -group xcvr1 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr1/mm_address
add wave -noupdate -group xcvr1 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr1/mm_waitrequest
add wave -noupdate -group xcvr1 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr1/mm_read
add wave -noupdate -group xcvr1 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr1/mm_write
add wave -noupdate -group xcvr1 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr1/mm_readdata
add wave -noupdate -group xcvr1 -group {Mgmt Avalon} /top_tb/tb/tb_inst/xcvr1/mm_writedata
add wave -noupdate -group xcvr1 -group LVDS /top_tb/tb/tb_inst/xcvr1/rd_p
add wave -noupdate -group xcvr1 -group LVDS /top_tb/tb/tb_inst/xcvr1/td_p
add wave -noupdate -group xcvr1 /top_tb/tb/tb_inst/xcvr1/pll_locked
add wave -noupdate -group xcvr1 /top_tb/tb/tb_inst/xcvr1/is_aligned
add wave -noupdate -group xcvr1 /top_tb/tb/tb_inst/xcvr1/tx_prim
add wave -noupdate -group xcvr1 /top_tb/tb/tb_inst/xcvr1/rx_prim
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/rx_syncstatus
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/rx_patterndetect
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/rx_errdetect
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/tx_parallel_data
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/tx_datak
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/tx_ready
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/rx_parallel_data
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/rx_datak
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/rx_ready
add wave -noupdate -group xcvr1 -group PHY /top_tb/tb/tb_inst/xcvr1/phy/rx_runningdisp
add wave -noupdate -group xcvr1 -label {TX Prim. Counters} /top_tb/tb/tb_inst/xcvr1/tx_primitive_cntrs
add wave -noupdate -group xcvr1 -label {RX Prim. Counters} /top_tb/tb/tb_inst/xcvr1/rx_primitive_cntrs
add wave -noupdate -expand -group framer0 /top_tb/tb/tb_inst/framer0/state
add wave -noupdate -expand -group framer0 -group userrx /top_tb/tb/tb_inst/framer0/userrx_data
add wave -noupdate -expand -group framer0 -group userrx /top_tb/tb/tb_inst/framer0/userrx_valid
add wave -noupdate -expand -group framer0 -group userrx /top_tb/tb/tb_inst/framer0/userrx_ready
add wave -noupdate -expand -group framer0 -group userrx /top_tb/tb/tb_inst/framer0/userrx_startofpacket
add wave -noupdate -expand -group framer0 -group userrx /top_tb/tb/tb_inst/framer0/userrx_endofpacket
add wave -noupdate -expand -group framer0 -expand -group usertx /top_tb/tb/tb_inst/framer0/usertx_data
add wave -noupdate -expand -group framer0 -expand -group usertx /top_tb/tb/tb_inst/framer0/usertx_ready
add wave -noupdate -expand -group framer0 -expand -group usertx /top_tb/tb/tb_inst/framer0/usertx_valid
add wave -noupdate -expand -group framer0 -expand -group usertx /top_tb/tb/tb_inst/framer0/usertx_startofpacket
add wave -noupdate -expand -group framer0 -expand -group usertx /top_tb/tb/tb_inst/framer0/usertx_endofpacket
add wave -noupdate -expand -group framer1 /top_tb/tb/tb_inst/framer1/state
add wave -noupdate -expand -group framer1 -group usertx /top_tb/tb/tb_inst/framer1/usertx_data
add wave -noupdate -expand -group framer1 -group usertx /top_tb/tb/tb_inst/framer1/usertx_ready
add wave -noupdate -expand -group framer1 -group usertx /top_tb/tb/tb_inst/framer1/usertx_valid
add wave -noupdate -expand -group framer1 -group usertx /top_tb/tb/tb_inst/framer1/usertx_startofpacket
add wave -noupdate -expand -group framer1 -group usertx /top_tb/tb/tb_inst/framer1/usertx_endofpacket
add wave -noupdate -expand -group framer1 -expand -group userrx /top_tb/tb/tb_inst/framer1/userrx_data
add wave -noupdate -expand -group framer1 -expand -group userrx /top_tb/tb/tb_inst/framer1/userrx_valid
add wave -noupdate -expand -group framer1 -expand -group userrx /top_tb/tb/tb_inst/framer1/userrx_ready
add wave -noupdate -expand -group framer1 -expand -group userrx /top_tb/tb/tb_inst/framer1/userrx_startofpacket
add wave -noupdate -expand -group framer1 -expand -group userrx /top_tb/tb/tb_inst/framer1/userrx_endofpacket
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {52 us} 0} {{Cursor 2} {56 us} 0}
quietly wave cursor active 1
configure wave -namecolwidth 237
configure wave -valuecolwidth 134
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {52 us} {56 us}
