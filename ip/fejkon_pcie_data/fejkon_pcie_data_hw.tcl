# TCL File Generated by Component Editor 20.1
# Sat Aug 22 21:25:50 CEST 2020
# DO NOT MODIFY


# 
# fejkon_pcie_data "Fejkon PCIe Data Facility" v1.0
# bluecmd 2020.08.22.21:25:50
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
add_fileset_file ../pcie_data_fifo/pcie_data_fifo.v VERILOG PATH ../pcie_data_fifo/pcie_data_fifo.v
add_fileset_file tl_cfg_module.sv SYSTEM_VERILOG PATH tl_cfg_module.sv
add_fileset_file fejkon_pcie_data.sv SYSTEM_VERILOG PATH fejkon_pcie_data.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL fejkon_pcie_data
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file ../pcie_data_fifo/pcie_data_fifo.v VERILOG PATH ../pcie_data_fifo/pcie_data_fifo.v
add_fileset_file tl_cfg_module.sv SYSTEM_VERILOG PATH tl_cfg_module.sv
add_fileset_file fejkon_pcie_data.sv SYSTEM_VERILOG PATH fejkon_pcie_data.sv TOP_LEVEL_FILE


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
# connection point tlp_rx_st
# 
add_interface tlp_rx_st avalon_streaming end
set_interface_property tlp_rx_st associatedClock clk
set_interface_property tlp_rx_st associatedReset reset
set_interface_property tlp_rx_st dataBitsPerSymbol 32
set_interface_property tlp_rx_st errorDescriptor ""
set_interface_property tlp_rx_st firstSymbolInHighOrderBits true
set_interface_property tlp_rx_st maxChannel 0
set_interface_property tlp_rx_st readyLatency 0
set_interface_property tlp_rx_st ENABLED true
set_interface_property tlp_rx_st EXPORT_OF ""
set_interface_property tlp_rx_st PORT_NAME_MAP ""
set_interface_property tlp_rx_st CMSIS_SVD_VARIABLES ""
set_interface_property tlp_rx_st SVD_ADDRESS_GROUP ""

add_interface_port tlp_rx_st tlp_rx_st_data data Input 256
add_interface_port tlp_rx_st tlp_rx_st_empty empty Input 3
add_interface_port tlp_rx_st tlp_rx_st_error error Input 1
add_interface_port tlp_rx_st tlp_rx_st_startofpacket startofpacket Input 1
add_interface_port tlp_rx_st tlp_rx_st_endofpacket endofpacket Input 1
add_interface_port tlp_rx_st tlp_rx_st_ready ready Output 1
add_interface_port tlp_rx_st tlp_rx_st_valid valid Input 1


# 
# connection point tlp_tx_instant_st
# 
add_interface tlp_tx_instant_st avalon_streaming start
set_interface_property tlp_tx_instant_st associatedClock clk
set_interface_property tlp_tx_instant_st associatedReset reset
set_interface_property tlp_tx_instant_st dataBitsPerSymbol 32
set_interface_property tlp_tx_instant_st errorDescriptor ""
set_interface_property tlp_tx_instant_st firstSymbolInHighOrderBits true
set_interface_property tlp_tx_instant_st maxChannel 0
set_interface_property tlp_tx_instant_st readyLatency 0
set_interface_property tlp_tx_instant_st ENABLED true
set_interface_property tlp_tx_instant_st EXPORT_OF ""
set_interface_property tlp_tx_instant_st PORT_NAME_MAP ""
set_interface_property tlp_tx_instant_st CMSIS_SVD_VARIABLES ""
set_interface_property tlp_tx_instant_st SVD_ADDRESS_GROUP ""

add_interface_port tlp_tx_instant_st tlp_tx_instant_st_data data Output 256
add_interface_port tlp_tx_instant_st tlp_tx_instant_st_startofpacket startofpacket Output 1
add_interface_port tlp_tx_instant_st tlp_tx_instant_st_endofpacket endofpacket Output 1
add_interface_port tlp_tx_instant_st tlp_tx_instant_st_empty empty Output 3
add_interface_port tlp_tx_instant_st tlp_tx_instant_st_valid valid Output 1
add_interface_port tlp_tx_instant_st tlp_tx_instant_st_ready ready Input 1


# 
# connection point tlp_tx_response_st
# 
add_interface tlp_tx_response_st avalon_streaming start
set_interface_property tlp_tx_response_st associatedClock clk
set_interface_property tlp_tx_response_st associatedReset reset
set_interface_property tlp_tx_response_st dataBitsPerSymbol 32
set_interface_property tlp_tx_response_st errorDescriptor ""
set_interface_property tlp_tx_response_st firstSymbolInHighOrderBits true
set_interface_property tlp_tx_response_st maxChannel 0
set_interface_property tlp_tx_response_st readyLatency 0
set_interface_property tlp_tx_response_st ENABLED true
set_interface_property tlp_tx_response_st EXPORT_OF ""
set_interface_property tlp_tx_response_st PORT_NAME_MAP ""
set_interface_property tlp_tx_response_st CMSIS_SVD_VARIABLES ""
set_interface_property tlp_tx_response_st SVD_ADDRESS_GROUP ""

add_interface_port tlp_tx_response_st tlp_tx_response_st_data data Output 256
add_interface_port tlp_tx_response_st tlp_tx_response_st_startofpacket startofpacket Output 1
add_interface_port tlp_tx_response_st tlp_tx_response_st_endofpacket endofpacket Output 1
add_interface_port tlp_tx_response_st tlp_tx_response_st_empty empty Output 3
add_interface_port tlp_tx_response_st tlp_tx_response_st_valid valid Output 1
add_interface_port tlp_tx_response_st tlp_tx_response_st_ready ready Input 1


# 
# connection point tlp_tx_data_st
# 
add_interface tlp_tx_data_st avalon_streaming start
set_interface_property tlp_tx_data_st associatedClock clk
set_interface_property tlp_tx_data_st associatedReset reset
set_interface_property tlp_tx_data_st dataBitsPerSymbol 32
set_interface_property tlp_tx_data_st errorDescriptor ""
set_interface_property tlp_tx_data_st firstSymbolInHighOrderBits true
set_interface_property tlp_tx_data_st maxChannel 0
set_interface_property tlp_tx_data_st readyLatency 0
set_interface_property tlp_tx_data_st ENABLED true
set_interface_property tlp_tx_data_st EXPORT_OF ""
set_interface_property tlp_tx_data_st PORT_NAME_MAP ""
set_interface_property tlp_tx_data_st CMSIS_SVD_VARIABLES ""
set_interface_property tlp_tx_data_st SVD_ADDRESS_GROUP ""

add_interface_port tlp_tx_data_st tlp_tx_data_st_data data Output 256
add_interface_port tlp_tx_data_st tlp_tx_data_st_startofpacket startofpacket Output 1
add_interface_port tlp_tx_data_st tlp_tx_data_st_endofpacket endofpacket Output 1
add_interface_port tlp_tx_data_st tlp_tx_data_st_empty empty Output 3
add_interface_port tlp_tx_data_st tlp_tx_data_st_valid valid Output 1
add_interface_port tlp_tx_data_st tlp_tx_data_st_ready ready Input 1


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
add_interface_port csr csr_address address Input 6
add_interface_port csr csr_write write Input 1
add_interface_port csr csr_writedata writedata Input 32
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0

