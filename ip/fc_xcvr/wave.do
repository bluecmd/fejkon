onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group XCVR -group TX -label tx_data /top_tb/tb/tb_inst/fc_8g_xcvr_0/tx_data
add wave -noupdate -expand -group XCVR -group TX -label tx_ready /top_tb/tb/tb_inst/fc_8g_xcvr_0/tx_ready
add wave -noupdate -expand -group XCVR -group TX -label tx_clk /top_tb/tb/tb_inst/fc_8g_xcvr_0/tx_clk
add wave -noupdate -expand -group XCVR -expand -group RX -label rx_data /top_tb/tb/tb_inst/fc_8g_xcvr_0/rx_data
add wave -noupdate -expand -group XCVR -expand -group RX -label rx_valid /top_tb/tb/tb_inst/fc_8g_xcvr_0/rx_valid
add wave -noupdate -expand -group XCVR -expand -group RX -label rx_clk /top_tb/tb/tb_inst/fc_8g_xcvr_0/rx_clk
add wave -noupdate -expand -group XCVR -label reset /top_tb/tb/tb_inst/fc_8g_xcvr_0/reset
add wave -noupdate -expand -group XCVR -label mgmt_clk /top_tb/tb/tb_inst/fc_8g_xcvr_0/mgmt_clk
add wave -noupdate -expand -group XCVR -label phy_clk /top_tb/tb/tb_inst/phy_clk_clk
add wave -noupdate -expand -group XCVR -expand -group {Mgmt Avalon} -label address /top_tb/tb/tb_inst/fc_8g_xcvr_0/mm_address
add wave -noupdate -expand -group XCVR -expand -group {Mgmt Avalon} -label waitrequest /top_tb/tb/tb_inst/fc_8g_xcvr_0/mm_waitrequest
add wave -noupdate -expand -group XCVR -expand -group {Mgmt Avalon} -label read /top_tb/tb/tb_inst/fc_8g_xcvr_0/mm_read
add wave -noupdate -expand -group XCVR -expand -group {Mgmt Avalon} -label write /top_tb/tb/tb_inst/fc_8g_xcvr_0/mm_write
add wave -noupdate -expand -group XCVR -expand -group {Mgmt Avalon} -label readdata /top_tb/tb/tb_inst/fc_8g_xcvr_0/mm_readdata
add wave -noupdate -expand -group XCVR -expand -group {Mgmt Avalon} -label writedata /top_tb/tb/tb_inst/fc_8g_xcvr_0/mm_writedata
add wave -noupdate -expand -group XCVR -expand -group LVDS -color Yellow -label {Ref. 8G Clock} /top_tb/ref_8g_clk
add wave -noupdate -expand -group XCVR -expand -group LVDS -label {Ref. 10B} -radix hexadecimal /top_tb/symbol_rr
add wave -noupdate -expand -group XCVR -expand -group LVDS -label {Ref. Symbol Name}  /top_tb/symbol
add wave -noupdate -expand -group XCVR -expand -group LVDS -label rd_p /top_tb/tb/tb_inst/fc_8g_xcvr_0/rd_p
add wave -noupdate -expand -group XCVR -expand -group LVDS -label td_p /top_tb/tb/tb_inst/fc_8g_xcvr_0/td_p
add wave -noupdate -expand -group XCVR -label pll_locked /top_tb/tb/tb_inst/fc_8g_xcvr_0/pll_locked
add wave -noupdate -expand -group XCVR -expand -group PHY -label rx_syncstatus /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/rx_syncstatus
add wave -noupdate -expand -group XCVR -expand -group PHY -label rx_patterndetect /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/rx_patterndetect
add wave -noupdate -expand -group XCVR -expand -group PHY -label rx_errdetect /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/rx_errdetect
add wave -noupdate -expand -group XCVR -expand -group PHY -label tx_parallel_data /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/tx_parallel_data
add wave -noupdate -expand -group XCVR -expand -group PHY -label tx_datak /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/tx_datak
add wave -noupdate -expand -group XCVR -expand -group PHY -label tx_ready /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/tx_ready
add wave -noupdate -expand -group XCVR -expand -group PHY -label rx_parallel_data /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/rx_parallel_data
add wave -noupdate -expand -group XCVR -expand -group PHY -label rx_datak /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/rx_datak
add wave -noupdate -expand -group XCVR -expand -group PHY -label rx_ready /top_tb/tb/tb_inst/fc_8g_xcvr_0/phy/rx_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1096515 ps} 0}
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
WaveRestoreZoom {1093097 ps} {1099933 ps}
