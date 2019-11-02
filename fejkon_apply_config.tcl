source fejkon.tcl

source config.tcl

set ports 0

if {$CONFIG_PCIE != "y"} {
  set_instance_property pcie ENABLED false
}

if {$CONFIG_FCPORT0 != "y"} {
  set_instance_property sfp0 ENABLED false
  set_instance_property fc0 ENABLED false
  set_instance_property xcvr0 ENABLED false
} else {
  set ports [expr $ports + 1]
}

if {$CONFIG_FCPORT1 != "y"} {
  set_instance_property sfp1 ENABLED false
  set_instance_property fc1 ENABLED false
  set_instance_property xcvr1 ENABLED false
} else {
  set ports [expr $ports + 1]
}

if {$CONFIG_LOOPBACK_01 != "y"} {
  set_instance_property fifo_0to1 ENABLED false
  set_instance_property fifo_1to0 ENABLED false
} else {
  # TODO: Disable normal logic when we have it
}

set_instance_parameter_value ident {Ports} $ports

save_system {fejkon.qsys}
