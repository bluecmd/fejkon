package require ::quartus::project
package require ::quartus::flow

project_new fejkon -overwrite

source ../config.tcl

set_global_assignment -name ORIGINAL_QUARTUS_VERSION 20.1.0
set_global_assignment -name LAST_QUARTUS_VERSION "20.1.0 Standard Edition"
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
set_global_assignment -name QSYS_FILE ../fejkon.qsys
set_global_assignment -name SDC_FILE ../de5net.sdc
set_global_assignment -name NUM_PARALLEL_PROCESSORS [exec nproc]
set_global_assignment -name RAPID_RECOMPILE_MODE ON
set_global_assignment -name TIMEQUEST_REPORT_SCRIPT ../timing.tcl
if {$CONFIG_AGGRESSIVE_OPT == "y"} {
  set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
  set_global_assignment -name ROUTER_CLOCKING_TOPOLOGY_ANALYSIS ON
  set_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT EXTRA
}
set_global_assignment -name FLOW_ENABLE_POWER_ANALYZER ON
# NOTE: These are defaults, might be better values for the DE5-Net?
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"

source ../de5net.tcl

if {$CONFIG_STP == "y"} {
  set_global_assignment -name ENABLE_SIGNALTAP ON
  set_global_assignment -name USE_SIGNALTAP_FILE fejkon.configured.stp
  set_global_assignment -name SIGNALTAP_FILE fejkon.configured.stp
}

# Commit assignments
export_assignments

if {$CONFIG_STP == "y"} {
  qexec "quartus_stp fejkon --stp_file fejkon.configured.stp --enable"
}

execute_flow -compile
