# qsys scripting (.tcl) file for fejkon
package require -exact qsys 16.0

create_system {fejkon}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SEE9F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance clk_0 clock_source 18.1
set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}

add_instance fcport0 fejkon_fcport 1.0

add_instance sfp0 sfp_port 1.0

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk_0.clk_in
add_interface fcxcvr_0_line_rx conduit end
set_interface_property fcxcvr_0_line_rx EXPORT_OF fcport0.fcxcvr_line_rx
add_interface fcxcvr_0_line_tx conduit end
set_interface_property fcxcvr_0_line_tx EXPORT_OF fcport0.fcxcvr_line_tx
add_interface reset reset sink
set_interface_property reset EXPORT_OF clk_0.clk_in_reset
add_interface sfp0 conduit end
set_interface_property sfp0 EXPORT_OF sfp0.sfp

# connections and connection parameters
add_connection clk_0.clk fcport0.clk

add_connection clk_0.clk sfp0.clk

add_connection clk_0.clk_reset fcport0.rst

add_connection clk_0.clk_reset sfp0.reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon.qsys}
