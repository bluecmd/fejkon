# qsys scripting (.tcl) file for tb
package require -exact qsys 16.0

create_system {tb}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGSMD4E1H29C1}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance alt_xcvr_reconfig_0 alt_xcvr_reconfig 19.1
set_instance_parameter_value alt_xcvr_reconfig_0 {ber_en} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_adce} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_analog} {1}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dcd} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dcd_power_up} {1}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dfe} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_eyemon} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_mif} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_offset} {1}
set_instance_parameter_value alt_xcvr_reconfig_0 {gui_cal_status_port} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {gui_enable_pll} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {gui_split_sizes} {}
set_instance_parameter_value alt_xcvr_reconfig_0 {number_of_reconfig_interfaces} {2}

add_instance fc_8g_xcvr_0 fc_8g_xcvr 1.0

add_instance fc_framer_0 fc_framer 1.0

add_instance mgmt_clk clock_source 19.1
set_instance_parameter_value mgmt_clk {clockFrequency} {50000000.0}
set_instance_parameter_value mgmt_clk {clockFrequencyKnown} {1}
set_instance_parameter_value mgmt_clk {resetSynchronousEdges} {NONE}

add_instance phy_clk clock_source 19.1
set_instance_parameter_value phy_clk {clockFrequency} {106250000.0}
set_instance_parameter_value phy_clk {clockFrequencyKnown} {1}
set_instance_parameter_value phy_clk {resetSynchronousEdges} {NONE}

add_instance rx_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value rx_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value rx_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance tx_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value tx_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value tx_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF mgmt_clk.clk_in
add_interface framer_mgmt_mm avalon slave
set_interface_property framer_mgmt_mm EXPORT_OF fc_framer_0.mgmt_mm
add_interface phy_clk clock sink
set_interface_property phy_clk EXPORT_OF phy_clk.clk_in
add_interface phy_reset reset sink
set_interface_property phy_reset EXPORT_OF phy_clk.clk_in_reset
add_interface reset reset sink
set_interface_property reset EXPORT_OF mgmt_clk.clk_in_reset
add_interface rx_clk clock source
set_interface_property rx_clk EXPORT_OF rx_clk_bridge.out_clk
add_interface tx_clk clock source
set_interface_property tx_clk EXPORT_OF tx_clk_bridge.out_clk
add_interface userrx avalon_streaming source
set_interface_property userrx EXPORT_OF fc_framer_0.userrx
add_interface usertx avalon_streaming sink
set_interface_property usertx EXPORT_OF fc_framer_0.usertx
add_interface xcvr_mgmt_mm avalon slave
set_interface_property xcvr_mgmt_mm EXPORT_OF fc_8g_xcvr_0.mgmt_mm

# connections and connection parameters
add_connection alt_xcvr_reconfig_0.reconfig_to_xcvr fc_8g_xcvr_0.reconfig_to_xcvr
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/fc_8g_xcvr_0.reconfig_to_xcvr endPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/fc_8g_xcvr_0.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/fc_8g_xcvr_0.reconfig_to_xcvr startPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/fc_8g_xcvr_0.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/fc_8g_xcvr_0.reconfig_to_xcvr width {0}

add_connection fc_8g_xcvr_0.avrx fc_framer_0.avrx

add_connection fc_8g_xcvr_0.line_td fc_8g_xcvr_0.line_rd
set_connection_parameter_value fc_8g_xcvr_0.line_td/fc_8g_xcvr_0.line_rd endPort {}
set_connection_parameter_value fc_8g_xcvr_0.line_td/fc_8g_xcvr_0.line_rd endPortLSB {0}
set_connection_parameter_value fc_8g_xcvr_0.line_td/fc_8g_xcvr_0.line_rd startPort {}
set_connection_parameter_value fc_8g_xcvr_0.line_td/fc_8g_xcvr_0.line_rd startPortLSB {0}
set_connection_parameter_value fc_8g_xcvr_0.line_td/fc_8g_xcvr_0.line_rd width {0}

add_connection fc_8g_xcvr_0.reconfig_from_xcvr alt_xcvr_reconfig_0.reconfig_from_xcvr
set_connection_parameter_value fc_8g_xcvr_0.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPort {}
set_connection_parameter_value fc_8g_xcvr_0.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value fc_8g_xcvr_0.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPort {}
set_connection_parameter_value fc_8g_xcvr_0.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value fc_8g_xcvr_0.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr width {0}

add_connection fc_8g_xcvr_0.rx_clk fc_framer_0.rx_clk

add_connection fc_8g_xcvr_0.rx_clk rx_clk_bridge.in_clk

add_connection fc_8g_xcvr_0.tx_clk fc_framer_0.tx_clk

add_connection fc_8g_xcvr_0.tx_clk tx_clk_bridge.in_clk

add_connection fc_framer_0.avtx fc_8g_xcvr_0.avtx

add_connection mgmt_clk.clk alt_xcvr_reconfig_0.mgmt_clk_clk

add_connection mgmt_clk.clk fc_8g_xcvr_0.mgmt_clk

add_connection mgmt_clk.clk fc_framer_0.mgmt_clk

add_connection mgmt_clk.clk_reset alt_xcvr_reconfig_0.mgmt_rst_reset

add_connection mgmt_clk.clk_reset fc_8g_xcvr_0.reset

add_connection mgmt_clk.clk_reset fc_framer_0.reset

add_connection phy_clk.clk fc_8g_xcvr_0.phy_clk

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {tb.qsys}
