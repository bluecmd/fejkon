# Note: Requires that full design is available first
source config.tcl

package require -exact qsys 16.0

load_system {svpcie_sim_tb.qsys}

if {$CONFIG_AVALON_MONITOR != "y"} {
  set_instance_property mm_pcie_monitor ENABLED false
} else {
  remove_connection fejkon_pcie_avalon.mm/test_pcie_mem.s1
}

save_system {svpcie_sim_tb.qsys}
