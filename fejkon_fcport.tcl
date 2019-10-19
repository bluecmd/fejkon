# qsys scripting (.tcl) file for fejkon_fcport
package require -exact qsys 16.0

create_system {fejkon_fcport}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SEE9F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance add_idle_0 fc_add_idle 1.0

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

add_instance mgmt_clk altera_clock_bridge 19.1
set_instance_parameter_value mgmt_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value mgmt_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance phy_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value phy_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value phy_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance remove_idle_0 fc_remove_idle 1.0

add_instance rst0 altera_reset_bridge 19.1
set_instance_parameter_value rst0 {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value rst0 {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value rst0 {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value rst0 {USE_RESET_REQUEST} {0}

add_instance rx_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value rx_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value rx_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance setup_bridge altera_avalon_mm_bridge 19.1
set_instance_parameter_value setup_bridge {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value setup_bridge {ADDRESS_WIDTH} {10}
set_instance_parameter_value setup_bridge {DATA_WIDTH} {32}
set_instance_parameter_value setup_bridge {LINEWRAPBURSTS} {0}
set_instance_parameter_value setup_bridge {MAX_BURST_SIZE} {1}
set_instance_parameter_value setup_bridge {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value setup_bridge {PIPELINE_COMMAND} {1}
set_instance_parameter_value setup_bridge {PIPELINE_RESPONSE} {1}
set_instance_parameter_value setup_bridge {SYMBOL_WIDTH} {8}
set_instance_parameter_value setup_bridge {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value setup_bridge {USE_RESPONSE} {0}

add_instance tx_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value tx_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value tx_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance xcvr fc_8g_xcvr 1.0

# exported interfaces
add_interface line_rd conduit end
set_interface_property line_rd EXPORT_OF xcvr.line_rd
add_interface line_td conduit end
set_interface_property line_td EXPORT_OF xcvr.line_td
add_interface mgmt_clk clock sink
set_interface_property mgmt_clk EXPORT_OF mgmt_clk.in_clk
add_interface mgmt_mm avalon slave
set_interface_property mgmt_mm EXPORT_OF setup_bridge.s0
add_interface phy_clk clock sink
set_interface_property phy_clk EXPORT_OF phy_clk_bridge.in_clk
add_interface reconfig_busy conduit end
set_interface_property reconfig_busy EXPORT_OF alt_xcvr_reconfig_0.reconfig_busy
add_interface reconfig_mgmt avalon slave
set_interface_property reconfig_mgmt EXPORT_OF alt_xcvr_reconfig_0.reconfig_mgmt
add_interface reset reset sink
set_interface_property reset EXPORT_OF rst0.in_reset
add_interface rx_clk clock source
set_interface_property rx_clk EXPORT_OF rx_clk_bridge.out_clk
add_interface rx_st avalon_streaming source
set_interface_property rx_st EXPORT_OF remove_idle_0.out
add_interface tx_clk clock source
set_interface_property tx_clk EXPORT_OF tx_clk_bridge.out_clk
add_interface tx_st avalon_streaming sink
set_interface_property tx_st EXPORT_OF add_idle_0.in

# connections and connection parameters
add_connection add_idle_0.out xcvr.tx

add_connection alt_xcvr_reconfig_0.reconfig_to_xcvr xcvr.reconfig_to_xcvr
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/xcvr.reconfig_to_xcvr endPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/xcvr.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/xcvr.reconfig_to_xcvr startPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/xcvr.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/xcvr.reconfig_to_xcvr width {0}

add_connection mgmt_clk.out_clk alt_xcvr_reconfig_0.mgmt_clk_clk

add_connection mgmt_clk.out_clk rst0.clk

add_connection mgmt_clk.out_clk setup_bridge.clk

add_connection mgmt_clk.out_clk xcvr.mgmt_clk

add_connection phy_clk_bridge.out_clk xcvr.phy_clk

add_connection rst0.out_reset add_idle_0.reset

add_connection rst0.out_reset alt_xcvr_reconfig_0.mgmt_rst_reset

add_connection rst0.out_reset remove_idle_0.reset

add_connection rst0.out_reset setup_bridge.reset

add_connection rst0.out_reset xcvr.reset

add_connection setup_bridge.m0 xcvr.mgmt_mm
set_connection_parameter_value setup_bridge.m0/xcvr.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/xcvr.mgmt_mm baseAddress {0x0000}
set_connection_parameter_value setup_bridge.m0/xcvr.mgmt_mm defaultConnection {0}

add_connection xcvr.reconfig_from_xcvr alt_xcvr_reconfig_0.reconfig_from_xcvr
set_connection_parameter_value xcvr.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPort {}
set_connection_parameter_value xcvr.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvr.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPort {}
set_connection_parameter_value xcvr.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvr.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr width {0}

add_connection xcvr.rx remove_idle_0.in

add_connection xcvr.rx_clk remove_idle_0.clk

add_connection xcvr.rx_clk rx_clk_bridge.in_clk

add_connection xcvr.tx_clk add_idle_0.clk

add_connection xcvr.tx_clk tx_clk_bridge.in_clk

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon_fcport.qsys}
