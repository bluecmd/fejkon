# TCL File Generated by Component Editor 19.1
# Thu Dec 12 20:35:48 CET 2019
# DO NOT MODIFY


# 
# fejkon_pcie_data "Fejkon PCIe Data Facility" v1.0
# bluecmd 2019.12.12.20:35:48
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
# connection point rx_st
# 
add_interface rx_st avalon_streaming end
set_interface_property rx_st associatedClock clk
set_interface_property rx_st associatedReset reset
set_interface_property rx_st dataBitsPerSymbol 256
set_interface_property rx_st errorDescriptor ""
set_interface_property rx_st firstSymbolInHighOrderBits true
set_interface_property rx_st maxChannel 0
set_interface_property rx_st readyLatency 0
set_interface_property rx_st ENABLED true
set_interface_property rx_st EXPORT_OF ""
set_interface_property rx_st PORT_NAME_MAP ""
set_interface_property rx_st CMSIS_SVD_VARIABLES ""
set_interface_property rx_st SVD_ADDRESS_GROUP ""

add_interface_port rx_st rx_st_data data Input 256
add_interface_port rx_st rx_st_empty empty Input 2
add_interface_port rx_st rx_st_error error Input 1
add_interface_port rx_st rx_st_startofpacket startofpacket Input 1
add_interface_port rx_st rx_st_endofpacket endofpacket Input 1
add_interface_port rx_st rx_st_ready ready Output 1
add_interface_port rx_st rx_st_valid valid Input 1


# 
# connection point tx_st
# 
add_interface tx_st avalon_streaming start
set_interface_property tx_st associatedClock clk
set_interface_property tx_st associatedReset reset
set_interface_property tx_st dataBitsPerSymbol 256
set_interface_property tx_st errorDescriptor ""
set_interface_property tx_st firstSymbolInHighOrderBits true
set_interface_property tx_st maxChannel 0
set_interface_property tx_st readyLatency 0
set_interface_property tx_st ENABLED true
set_interface_property tx_st EXPORT_OF ""
set_interface_property tx_st PORT_NAME_MAP ""
set_interface_property tx_st CMSIS_SVD_VARIABLES ""
set_interface_property tx_st SVD_ADDRESS_GROUP ""

add_interface_port tx_st tx_st_data data Output 256
add_interface_port tx_st tx_st_startofpacket startofpacket Output 1
add_interface_port tx_st tx_st_endofpacket endofpacket Output 1
add_interface_port tx_st tx_st_error error Output 1
add_interface_port tx_st tx_st_empty empty Output 2
add_interface_port tx_st tx_st_valid valid Output 1


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
# connection point data_tx
# 
add_interface data_tx avalon_streaming end
set_interface_property data_tx associatedClock clk
set_interface_property data_tx associatedReset reset
set_interface_property data_tx dataBitsPerSymbol 8
set_interface_property data_tx errorDescriptor ""
set_interface_property data_tx firstSymbolInHighOrderBits true
set_interface_property data_tx maxChannel 0
set_interface_property data_tx readyLatency 0
set_interface_property data_tx ENABLED true
set_interface_property data_tx EXPORT_OF ""
set_interface_property data_tx PORT_NAME_MAP ""
set_interface_property data_tx CMSIS_SVD_VARIABLES ""
set_interface_property data_tx SVD_ADDRESS_GROUP ""

add_interface_port data_tx data_tx_data data Input 256
add_interface_port data_tx data_tx_valid valid Input 1
add_interface_port data_tx data_tx_ready ready Output 1
add_interface_port data_tx data_tx_channel channel Input 2
add_interface_port data_tx data_tx_endofpacket endofpacket Input 1
add_interface_port data_tx data_tx_startofpacket startofpacket Input 1
add_interface_port data_tx data_tx_empty empty Input 5


# 
# connection point config_tl
# 
add_interface config_tl conduit end
set_interface_property config_tl associatedClock ""
set_interface_property config_tl associatedReset ""
set_interface_property config_tl ENABLED true
set_interface_property config_tl EXPORT_OF ""
set_interface_property config_tl PORT_NAME_MAP ""
set_interface_property config_tl CMSIS_SVD_VARIABLES ""
set_interface_property config_tl SVD_ADDRESS_GROUP ""

add_interface_port config_tl tl_cfg_add tl_cfg_add Input 4
add_interface_port config_tl tl_cfg_ctl tl_cfg_ctl Input 32
add_interface_port config_tl tl_cfg_sts tl_cfg_sts Input 53
add_interface_port config_tl hpg_ctrler hpg_ctrler Output 5
add_interface_port config_tl cpl_err cpl_err Output 7
add_interface_port config_tl cpl_pending cpl_pending Output 1


# 
# connection point mem_access_req
# 
add_interface mem_access_req avalon_streaming start
set_interface_property mem_access_req associatedClock clk
set_interface_property mem_access_req associatedReset reset
set_interface_property mem_access_req dataBitsPerSymbol 128
set_interface_property mem_access_req errorDescriptor ""
set_interface_property mem_access_req firstSymbolInHighOrderBits true
set_interface_property mem_access_req maxChannel 0
set_interface_property mem_access_req readyLatency 0
set_interface_property mem_access_req ENABLED true
set_interface_property mem_access_req EXPORT_OF ""
set_interface_property mem_access_req PORT_NAME_MAP ""
set_interface_property mem_access_req CMSIS_SVD_VARIABLES ""
set_interface_property mem_access_req SVD_ADDRESS_GROUP ""

add_interface_port mem_access_req mem_access_req_data data Output 128
add_interface_port mem_access_req mem_access_req_ready ready Input 1
add_interface_port mem_access_req mem_access_req_valid valid Output 1


# 
# connection point mem_access_resp
# 
add_interface mem_access_resp avalon_streaming end
set_interface_property mem_access_resp associatedClock clk
set_interface_property mem_access_resp associatedReset reset
set_interface_property mem_access_resp dataBitsPerSymbol 128
set_interface_property mem_access_resp errorDescriptor ""
set_interface_property mem_access_resp firstSymbolInHighOrderBits true
set_interface_property mem_access_resp maxChannel 0
set_interface_property mem_access_resp readyLatency 0
set_interface_property mem_access_resp ENABLED true
set_interface_property mem_access_resp EXPORT_OF ""
set_interface_property mem_access_resp PORT_NAME_MAP ""
set_interface_property mem_access_resp CMSIS_SVD_VARIABLES ""
set_interface_property mem_access_resp SVD_ADDRESS_GROUP ""

add_interface_port mem_access_resp mem_access_resp_data data Input 128
add_interface_port mem_access_resp mem_access_resp_ready ready Output 1
add_interface_port mem_access_resp mem_access_resp_valid valid Input 1


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

add_interface_port csr csr_read read Input 1
add_interface_port csr csr_readdata readdata Output 32
add_interface_port csr csr_address address Input 4
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0

