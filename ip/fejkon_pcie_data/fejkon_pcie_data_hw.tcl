# TCL File Generated by Component Editor 19.1
# Tue Nov 05 19:09:22 CET 2019
# DO NOT MODIFY


# 
# fejkon_pcie_data "Fejkon PCIe Data Facility" v1.0
# bluecmd 2019.11.05.19:09:22
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module fejkon_pcie_data
# 
set_module_property DESCRIPTION ""
set_module_property NAME fejkon_pcie_data
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR bluecmd
set_module_property DISPLAY_NAME "Fejkon PCIe Data Facility"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL fejkon_pcie_data
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file fejkon_pcie_data.sv SYSTEM_VERILOG PATH fejkon_pcie_data.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL fejkon_pcie_data
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file fejkon_pcie_data.sv SYSTEM_VERILOG PATH fejkon_pcie_data.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point bar2_mm
# 
add_interface bar2_mm avalon start
set_interface_property bar2_mm addressUnits SYMBOLS
set_interface_property bar2_mm associatedClock clk
set_interface_property bar2_mm associatedReset reset
set_interface_property bar2_mm bitsPerSymbol 8
set_interface_property bar2_mm burstOnBurstBoundariesOnly false
set_interface_property bar2_mm burstcountUnits WORDS
set_interface_property bar2_mm doStreamReads false
set_interface_property bar2_mm doStreamWrites false
set_interface_property bar2_mm holdTime 0
set_interface_property bar2_mm linewrapBursts false
set_interface_property bar2_mm maximumPendingReadTransactions 0
set_interface_property bar2_mm maximumPendingWriteTransactions 0
set_interface_property bar2_mm readLatency 0
set_interface_property bar2_mm readWaitTime 1
set_interface_property bar2_mm setupTime 0
set_interface_property bar2_mm timingUnits Cycles
set_interface_property bar2_mm writeWaitTime 0
set_interface_property bar2_mm ENABLED true
set_interface_property bar2_mm EXPORT_OF ""
set_interface_property bar2_mm PORT_NAME_MAP ""
set_interface_property bar2_mm CMSIS_SVD_VARIABLES ""
set_interface_property bar2_mm SVD_ADDRESS_GROUP ""

add_interface_port bar2_mm bar2_mm_address address Output 32
add_interface_port bar2_mm bar2_mm_readdatavalid readdatavalid Input 1
add_interface_port bar2_mm bar2_mm_readdata readdata Input 32
add_interface_port bar2_mm bar2_mm_read read Output 1
add_interface_port bar2_mm bar2_mm_write write Output 1
add_interface_port bar2_mm bar2_mm_writedata writedata Output 32
add_interface_port bar2_mm bar2_mm_waitrequest waitrequest Input 1


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
# connection point pcie_rx
# 
add_interface pcie_rx avalon_streaming end
set_interface_property pcie_rx associatedClock clk
set_interface_property pcie_rx associatedReset reset
set_interface_property pcie_rx dataBitsPerSymbol 256
set_interface_property pcie_rx errorDescriptor ""
set_interface_property pcie_rx firstSymbolInHighOrderBits true
set_interface_property pcie_rx maxChannel 0
set_interface_property pcie_rx readyLatency 0
set_interface_property pcie_rx ENABLED true
set_interface_property pcie_rx EXPORT_OF ""
set_interface_property pcie_rx PORT_NAME_MAP ""
set_interface_property pcie_rx CMSIS_SVD_VARIABLES ""
set_interface_property pcie_rx SVD_ADDRESS_GROUP ""

add_interface_port pcie_rx pcie_rx_data data Input 256
add_interface_port pcie_rx pcie_rx_empty empty Input 1
add_interface_port pcie_rx pcie_rx_error error Input 1
add_interface_port pcie_rx pcie_rx_startofpacket startofpacket Input 1
add_interface_port pcie_rx pcie_rx_endofpacket endofpacket Input 1
add_interface_port pcie_rx pcie_rx_ready ready Output 1
add_interface_port pcie_rx pcie_rx_valid valid Input 1


# 
# connection point pcie_tx
# 
add_interface pcie_tx avalon_streaming start
set_interface_property pcie_tx associatedClock clk
set_interface_property pcie_tx associatedReset reset
set_interface_property pcie_tx dataBitsPerSymbol 256
set_interface_property pcie_tx errorDescriptor ""
set_interface_property pcie_tx firstSymbolInHighOrderBits true
set_interface_property pcie_tx maxChannel 0
set_interface_property pcie_tx readyLatency 0
set_interface_property pcie_tx ENABLED true
set_interface_property pcie_tx EXPORT_OF ""
set_interface_property pcie_tx PORT_NAME_MAP ""
set_interface_property pcie_tx CMSIS_SVD_VARIABLES ""
set_interface_property pcie_tx SVD_ADDRESS_GROUP ""

add_interface_port pcie_tx pcie_tx_data data Output 256
add_interface_port pcie_tx pcie_tx_startofpacket startofpacket Output 1
add_interface_port pcie_tx pcie_tx_endofpacket endofpacket Output 1
add_interface_port pcie_tx pcie_tx_error error Output 1
add_interface_port pcie_tx pcie_tx_empty empty Output 1
add_interface_port pcie_tx pcie_tx_valid valid Output 1


# 
# connection point rx_bar_be
# 
add_interface rx_bar_be conduit end
set_interface_property rx_bar_be associatedClock ""
set_interface_property rx_bar_be associatedReset ""
set_interface_property rx_bar_be ENABLED true
set_interface_property rx_bar_be EXPORT_OF ""
set_interface_property rx_bar_be PORT_NAME_MAP ""
set_interface_property rx_bar_be CMSIS_SVD_VARIABLES ""
set_interface_property rx_bar_be SVD_ADDRESS_GROUP ""

add_interface_port rx_bar_be rx_st_bar rx_st_bar Input 8
add_interface_port rx_bar_be rx_st_mask rx_st_mask Output 1


# 
# connection point pcie_data_tx
# 
add_interface pcie_data_tx avalon_streaming end
set_interface_property pcie_data_tx associatedClock clk
set_interface_property pcie_data_tx associatedReset reset
set_interface_property pcie_data_tx dataBitsPerSymbol 8
set_interface_property pcie_data_tx errorDescriptor ""
set_interface_property pcie_data_tx firstSymbolInHighOrderBits true
set_interface_property pcie_data_tx maxChannel 0
set_interface_property pcie_data_tx readyLatency 0
set_interface_property pcie_data_tx ENABLED true
set_interface_property pcie_data_tx EXPORT_OF ""
set_interface_property pcie_data_tx PORT_NAME_MAP ""
set_interface_property pcie_data_tx CMSIS_SVD_VARIABLES ""
set_interface_property pcie_data_tx SVD_ADDRESS_GROUP ""

add_interface_port pcie_data_tx pcie_data_tx_data data Input 256
add_interface_port pcie_data_tx pcie_data_tx_valid valid Input 1
add_interface_port pcie_data_tx pcie_data_tx_ready ready Output 1
add_interface_port pcie_data_tx pcie_data_tx_channel channel Input 2
add_interface_port pcie_data_tx pcie_data_tx_endofpacket endofpacket Input 1
add_interface_port pcie_data_tx pcie_data_tx_startofpacket startofpacket Input 1
add_interface_port pcie_data_tx pcie_data_tx_empty empty Input 5

