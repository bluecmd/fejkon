package require ::quartus::project
package require ::quartus::flow

project_new fejkon -overwrite

set_global_assignment -name ORIGINAL_QUARTUS_VERSION 19.1.0
set_global_assignment -name LAST_QUARTUS_VERSION "19.1.0 Standard Edition"
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
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
set_global_assignment -name FLOW_ENABLE_POWER_ANALYZER ON

set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR [expr 0xff0000] -section_id Top
set_global_assignment -name PARTITION_NETLIST_TYPE POST_SYNTH -section_id "fejkon_pcie:pcie"
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id "fejkon_pcie:pcie"
set_global_assignment -name PARTITION_COLOR [expr 0x0dbaab] -section_id "fejkon_pcie:pcie"
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top
set_instance_assignment -name PARTITION_HIERARCHY fejkon_pcie -to "fejkon_pcie:pcie" -section_id "fejkon_pcie:pcie"

source ../de5net.tcl

# This is to enable SignalTap if you need that: (step 1/2)
# set_global_assignment -name ENABLE_SIGNALTAP ON
# set_global_assignment -name USE_SIGNALTAP_FILE ../stps/fcrx.stp
# set_global_assignment -name SIGNALTAP_FILE ../stps/fcrx.stp

# Commit assignments
export_assignments

# This is to enable SignalTap if you need that: (step 2/2)
# quartus_stp fejkon --stp_file ../stps/fcrx.stp --enable
execute_flow -compile
