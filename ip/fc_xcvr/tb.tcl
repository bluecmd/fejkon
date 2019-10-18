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

add_instance clk_0 clock_source 19.1
set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}

add_instance fc_8g_xcvr_0 fc_8g_xcvr 1.0

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk_0.clk_in
add_interface reset reset sink
set_interface_property reset EXPORT_OF clk_0.clk_in_reset
add_interface xcvr_line conduit end
set_interface_property xcvr_line EXPORT_OF fc_8g_xcvr_0.line
add_interface xcvr_rx avalon_streaming source
set_interface_property xcvr_rx EXPORT_OF fc_8g_xcvr_0.rx
add_interface xcvr_rx_clk clock source
set_interface_property xcvr_rx_clk EXPORT_OF fc_8g_xcvr_0.rx_clk
add_interface xcvr_tx avalon_streaming sink
set_interface_property xcvr_tx EXPORT_OF fc_8g_xcvr_0.tx
add_interface xcvr_tx_clk clock source
set_interface_property xcvr_tx_clk EXPORT_OF fc_8g_xcvr_0.tx_clk

# connections and connection parameters
add_connection clk_0.clk alt_xcvr_reconfig_0.mgmt_clk_clk

add_connection clk_0.clk fc_8g_xcvr_0.mgmt_clk

add_connection clk_0.clk_reset alt_xcvr_reconfig_0.mgmt_rst_reset

add_connection clk_0.clk_reset fc_8g_xcvr_0.reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {tb.qsys}
