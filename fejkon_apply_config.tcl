# Note: Requires that full designs are available first
# Generate modified fejkon.qsys first to ensure that no errors regarding
# undefined connections are emitted for deactivated parts
source config.tcl

package require -exact qsys 16.0

load_system {fejkon.qsys}

set fc_ports 1
set eth_ports 0

if {$CONFIG_PORT1_FC == "y"} {
  set fc_ports [expr $fc_ports + 1]
}
# TODO: Add terminator/dummy IP cores instead of xcvrX when port disabled?

if {$CONFIG_PORT2_FC == "y"} {
  set fc_ports [expr $fc_ports + 1]
}

if {$CONFIG_PORT3_FC == "y"} {
  set fc_ports [expr $fc_ports + 1]
}

if {$CONFIG_LOOPBACK_01 == "y"} {
  set_instance_parameter_value datapath {LOOPBACK_01} {true}
} else {
  set_instance_parameter_value datapath {LOOPBACK_01} {false}
}

if {$CONFIG_PORT2_ETHERNET == "y"} {
  set eth_ports [expr $eth_ports + 1]
}

if {$CONFIG_PORT3_ETHERNET == "y"} {
  set eth_ports [expr $eth_ports + 1]
}

if {$CONFIG_PORT1_DISABLED == "y"} {
  set_instance_property sfp1 ENABLED false
}

if {$CONFIG_PORT2_DISABLED == "y"} {
  set_instance_property sfp2 ENABLED false
}

if {$CONFIG_PORT3_DISABLED == "y"} {
  set_instance_property sfp3 ENABLED false
}

set_instance_parameter_value ident {FcPorts} $fc_ports
set_instance_parameter_value ident {EthPorts} $eth_ports

save_system {fejkon.qsys}
