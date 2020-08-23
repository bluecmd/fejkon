# Note: Requires that full designs are available first
# Generate modified fejkon.qsys first to ensure that no errors regarding
# undefined connections are emitted for deactivated parts
source config.tcl

package require -exact qsys 16.0

load_system {fejkon_fc.qsys}

set fc_ports 1
set eth_ports 0

if {$CONFIG_PORT1_FC != "y"} {
  set_instance_property fc1 ENABLED false
  set_instance_property xcvr1 ENABLED false
  set_instance_property fc1_rx_split ENABLED false
  set_instance_property fc1_256_rx ENABLED false
  set_instance_property fc1_rx_cdc ENABLED false
} else {
  set fc_ports [expr $fc_ports + 1]
}

if {$CONFIG_PORT2_FC != "y"} {
  # TODO
} else {
  set fc_ports [expr $fc_ports + 1]
}

if {$CONFIG_PORT3_FC != "y"} {
  # TODO
} else {
  set fc_ports [expr $fc_ports + 1]
}

if {$CONFIG_LOOPBACK_01 != "y"} {
  set_instance_property fifo_0to1 ENABLED false
  set_instance_property fifo_1to0 ENABLED false
} else {
  # TODO: Disable normal logic when we have it
}

if {$fc_ports < 2} {
  # Lowest number of interfaces supported is 2
  set_instance_parameter_value rx_mux {numInputInterfaces} 2
} else {
  set_instance_parameter_value rx_mux {numInputInterfaces} $fc_ports
}

save_system {fejkon_fc.qsys}

load_system {fejkon.qsys}

if {$CONFIG_PORT2_ETHERNET != "y"} {
  # TODO
} else {
  set eth_ports [expr $eth_ports + 1]
}

if {$CONFIG_PORT3_ETHERNET != "y"} {
  # TODO
} else {
  set eth_ports [expr $eth_ports + 1]
}

if {$CONFIG_PORT1_DISABLED != "n"} {
  set_instance_property sfp1 ENABLED false
}

if {$CONFIG_PORT2_DISABLED != "n"} {
  set_instance_property sfp2 ENABLED false
}

if {$CONFIG_PORT3_DISABLED != "n"} {
  set_instance_property sfp3 ENABLED false
}

set_instance_parameter_value ident {FcPorts} $fc_ports
set_instance_parameter_value ident {EthPorts} $eth_ports


if {$CONFIG_PORT1_FC != "y"} {
  remove_connection fc.fc1_active/led.fcport1_active
  remove_connection fc.xcvr1_aligned/led.fcport1_aligned
}

save_system {fejkon.qsys}
