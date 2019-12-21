# Note: Requires that full designs are available first
# Generate modified fejkon.qsys first to ensure that no errors regarding
# undefined connections are emitted for deactivated parts
source config.tcl

package require -exact qsys 16.0

load_system {fejkon_fc.qsys}

set ports 1

if {$CONFIG_FCPORT1 != "y"} {
  set_instance_property fc1 ENABLED false
  set_instance_property xcvr1 ENABLED false
  set_instance_property fc1_rx_split ENABLED false
  set_instance_property fc1_256_rx ENABLED false
  set_instance_property fc1_rx_cdc ENABLED false
} else {
  set ports [expr $ports + 1]
}

if {$CONFIG_LOOPBACK_01 != "y"} {
  set_instance_property fifo_0to1 ENABLED false
  set_instance_property fifo_1to0 ENABLED false
} else {
  # TODO: Disable normal logic when we have it
}

set_instance_parameter_value rx_mux {numInputInterfaces} $ports

save_system {fejkon_fc.qsys}

load_system {fejkon.qsys}

if {$CONFIG_FCPORT1 != "y"} {
  set_instance_property sfp1 ENABLED false
}

set_instance_parameter_value ident {Ports} $ports


if {$CONFIG_FCPORT1 != "y"} {
  remove_connection fc.fc1_active/led.fcport1_active
  remove_connection fc.xcvr1_aligned/led.fcport1_aligned
}

save_system {fejkon.qsys}
