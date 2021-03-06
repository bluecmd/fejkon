# TCL File Generated by Component Editor 20.1
# Sat Sep 26 21:44:36 CEST 2020
# DO NOT MODIFY


# 
# fejkon_fc_debug "Fejkon FC Debug and Generation" v1.0
#  2020.09.26.21:44:36
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module fejkon_fc_debug
# 
set_module_property DESCRIPTION ""
set_module_property NAME fejkon_fc_debug
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Fejkon FC Debug and Generation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL fejkon_fc_debug
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file fejkon_fc_debug.sv SYSTEM_VERILOG PATH fejkon_fc_debug.sv TOP_LEVEL_FILE
add_fileset_file generator.sv SYSTEM_VERILOG PATH generator.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL fejkon_fc_debug
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file fejkon_fc_debug.sv SYSTEM_VERILOG PATH fejkon_fc_debug.sv
add_fileset_file generator.sv SYSTEM_VERILOG PATH generator.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point st_in
# 
add_interface st_in avalon_streaming end
set_interface_property st_in associatedClock clk
set_interface_property st_in associatedReset reset
set_interface_property st_in dataBitsPerSymbol 8
set_interface_property st_in errorDescriptor ""
set_interface_property st_in firstSymbolInHighOrderBits true
set_interface_property st_in maxChannel 3
set_interface_property st_in readyLatency 0
set_interface_property st_in ENABLED true
set_interface_property st_in EXPORT_OF ""
set_interface_property st_in PORT_NAME_MAP ""
set_interface_property st_in CMSIS_SVD_VARIABLES ""
set_interface_property st_in SVD_ADDRESS_GROUP ""

add_interface_port st_in st_in_channel channel Input 2
add_interface_port st_in st_in_data data Input 256
add_interface_port st_in st_in_startofpacket startofpacket Input 1
add_interface_port st_in st_in_endofpacket endofpacket Input 1
add_interface_port st_in st_in_ready ready Output 1
add_interface_port st_in st_in_empty empty Input 5
add_interface_port st_in st_in_valid valid Input 1


# 
# connection point st_out
# 
add_interface st_out avalon_streaming start
set_interface_property st_out associatedClock clk
set_interface_property st_out associatedReset reset
set_interface_property st_out dataBitsPerSymbol 8
set_interface_property st_out errorDescriptor ""
set_interface_property st_out firstSymbolInHighOrderBits true
set_interface_property st_out maxChannel 0
set_interface_property st_out readyLatency 0
set_interface_property st_out ENABLED true
set_interface_property st_out EXPORT_OF ""
set_interface_property st_out PORT_NAME_MAP ""
set_interface_property st_out CMSIS_SVD_VARIABLES ""
set_interface_property st_out SVD_ADDRESS_GROUP ""

add_interface_port st_out st_out_channel channel Output 2
add_interface_port st_out st_out_data data Output 256
add_interface_port st_out st_out_endofpacket endofpacket Output 1
add_interface_port st_out st_out_startofpacket startofpacket Output 1
add_interface_port st_out st_out_valid valid Output 1
add_interface_port st_out st_out_ready ready Input 1
add_interface_port st_out st_out_empty empty Output 5


# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point csr
# 
add_interface csr avalon end
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock clk
set_interface_property csr associatedReset reset
set_interface_property csr bitsPerSymbol 8
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr maximumPendingWriteTransactions 0
set_interface_property csr readLatency 0
set_interface_property csr readWaitTime 1
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr CMSIS_SVD_VARIABLES ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr csr_address address Input 4
add_interface_port csr csr_write write Input 1
add_interface_port csr csr_read read Input 1
add_interface_port csr csr_writedata writedata Input 32
add_interface_port csr csr_readdata readdata Output 32
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0

