# TCL File Generated by Component Editor 19.1
# Tue Oct 29 12:01:36 CET 2019
# DO NOT MODIFY


# 
# freq_gauge "Frequency Counter Gauge" v1.0
# bluecmd 2019.10.29.12:01:36
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module freq_gauge
# 
set_module_property DESCRIPTION ""
set_module_property NAME freq_gauge
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR bluecmd
set_module_property DISPLAY_NAME "Frequency Counter Gauge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL freq_gauge
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file freq_gauge.sv SYSTEM_VERILOG PATH freq_gauge.sv TOP_LEVEL_FILE
add_fileset_file freq_gauge.sdc SDC PATH freq_gauge.sdc

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL freq_gauge
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file freq_gauge.sv SYSTEM_VERILOG PATH freq_gauge.sv


# 
# parameters
# 
add_parameter ReferenceClock POSITIVE 50000000 ""
set_parameter_property ReferenceClock DEFAULT_VALUE 50000000
set_parameter_property ReferenceClock DISPLAY_NAME ReferenceClock
set_parameter_property ReferenceClock TYPE POSITIVE
set_parameter_property ReferenceClock VISIBLE false
set_parameter_property ReferenceClock UNITS Hertz
set_parameter_property ReferenceClock ALLOWED_RANGES 1:2147483647
set_parameter_property ReferenceClock DESCRIPTION ""
set_parameter_property ReferenceClock AFFECTS_GENERATION false
set_parameter_property ReferenceClock HDL_PARAMETER true
set_parameter_property ReferenceClock SYSTEM_INFO_TYPE CLOCK_RATE
set_parameter_property ReferenceClock SYSTEM_INFO_ARG ref_clk


# 
# display items
# 


# 
# connection point probe_clk
# 
add_interface probe_clk clock end
set_interface_property probe_clk clockRate 0
set_interface_property probe_clk ENABLED true
set_interface_property probe_clk EXPORT_OF ""
set_interface_property probe_clk PORT_NAME_MAP ""
set_interface_property probe_clk CMSIS_SVD_VARIABLES ""
set_interface_property probe_clk SVD_ADDRESS_GROUP ""

add_interface_port probe_clk probe_clk clk Input 1


# 
# connection point ref_clk
# 
add_interface ref_clk clock end
set_interface_property ref_clk clockRate 0
set_interface_property ref_clk ENABLED true
set_interface_property ref_clk EXPORT_OF ""
set_interface_property ref_clk PORT_NAME_MAP ""
set_interface_property ref_clk CMSIS_SVD_VARIABLES ""
set_interface_property ref_clk SVD_ADDRESS_GROUP ""

add_interface_port ref_clk ref_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock ""
set_interface_property reset synchronousEdges NONE
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point mm
# 
add_interface mm avalon end
set_interface_property mm addressUnits WORDS
set_interface_property mm associatedClock ref_clk
set_interface_property mm associatedReset reset
set_interface_property mm bitsPerSymbol 8
set_interface_property mm burstOnBurstBoundariesOnly false
set_interface_property mm burstcountUnits WORDS
set_interface_property mm explicitAddressSpan 0
set_interface_property mm holdTime 0
set_interface_property mm linewrapBursts false
set_interface_property mm maximumPendingReadTransactions 0
set_interface_property mm maximumPendingWriteTransactions 0
set_interface_property mm readLatency 0
set_interface_property mm readWaitTime 1
set_interface_property mm setupTime 0
set_interface_property mm timingUnits Cycles
set_interface_property mm writeWaitTime 0
set_interface_property mm ENABLED true
set_interface_property mm EXPORT_OF ""
set_interface_property mm PORT_NAME_MAP ""
set_interface_property mm CMSIS_SVD_VARIABLES ""
set_interface_property mm SVD_ADDRESS_GROUP ""

add_interface_port mm mm_readdata readdata Output 32
set_interface_assignment mm embeddedsw.configuration.isFlash 0
set_interface_assignment mm embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment mm embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment mm embeddedsw.configuration.isPrintableDevice 0

