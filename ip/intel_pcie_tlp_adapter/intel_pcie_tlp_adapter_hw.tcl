# TCL File Generated by Component Editor 20.1
# Sun Aug 30 15:32:46 CEST 2020
# DO NOT MODIFY


# 
# intel_pcie_tlp_adapter "Intel PCIe Avalon-ST Adapter" v1.0
# bluecmd 2020.08.30.15:32:46
# Make PCIe Avalon-ST interface compatible with Avalon specification
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module intel_pcie_tlp_adapter
# 
set_module_property DESCRIPTION "Make PCIe Avalon-ST interface compatible with Avalon specification"
set_module_property NAME intel_pcie_tlp_adapter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR bluecmd
set_module_property DISPLAY_NAME "Intel PCIe Avalon-ST Adapter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL intel_pcie_tlp_adapter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file intel_pcie_tlp_adapter.sv SYSTEM_VERILOG PATH intel_pcie_tlp_adapter.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL intel_pcie_tlp_adapter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file intel_pcie_tlp_adapter.sv SYSTEM_VERILOG PATH intel_pcie_tlp_adapter.sv TOP_LEVEL_FILE


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
# connection point phy_tx_st
# 
add_interface phy_tx_st avalon_streaming start
set_interface_property phy_tx_st associatedClock clk
set_interface_property phy_tx_st associatedReset reset
set_interface_property phy_tx_st dataBitsPerSymbol 256
set_interface_property phy_tx_st errorDescriptor ""
set_interface_property phy_tx_st firstSymbolInHighOrderBits true
set_interface_property phy_tx_st maxChannel 0
set_interface_property phy_tx_st readyLatency 3
set_interface_property phy_tx_st ENABLED true
set_interface_property phy_tx_st EXPORT_OF ""
set_interface_property phy_tx_st PORT_NAME_MAP ""
set_interface_property phy_tx_st CMSIS_SVD_VARIABLES ""
set_interface_property phy_tx_st SVD_ADDRESS_GROUP ""

add_interface_port phy_tx_st phy_tx_st_data data Output 256
add_interface_port phy_tx_st phy_tx_st_startofpacket startofpacket Output 1
add_interface_port phy_tx_st phy_tx_st_endofpacket endofpacket Output 1
add_interface_port phy_tx_st phy_tx_st_error error Output 1
add_interface_port phy_tx_st phy_tx_st_empty empty Output 2
add_interface_port phy_tx_st phy_tx_st_valid valid Output 1
add_interface_port phy_tx_st phy_tx_st_ready ready Input 1


# 
# connection point phy_rx_st
# 
add_interface phy_rx_st avalon_streaming end
set_interface_property phy_rx_st associatedClock clk
set_interface_property phy_rx_st associatedReset reset
set_interface_property phy_rx_st dataBitsPerSymbol 256
set_interface_property phy_rx_st errorDescriptor ""
set_interface_property phy_rx_st firstSymbolInHighOrderBits true
set_interface_property phy_rx_st maxChannel 0
set_interface_property phy_rx_st readyLatency 3
set_interface_property phy_rx_st ENABLED true
set_interface_property phy_rx_st EXPORT_OF ""
set_interface_property phy_rx_st PORT_NAME_MAP ""
set_interface_property phy_rx_st CMSIS_SVD_VARIABLES ""
set_interface_property phy_rx_st SVD_ADDRESS_GROUP ""

add_interface_port phy_rx_st phy_rx_st_data data Input 256
add_interface_port phy_rx_st phy_rx_st_empty empty Input 2
add_interface_port phy_rx_st phy_rx_st_error error Input 1
add_interface_port phy_rx_st phy_rx_st_startofpacket startofpacket Input 1
add_interface_port phy_rx_st phy_rx_st_endofpacket endofpacket Input 1
add_interface_port phy_rx_st phy_rx_st_ready ready Output 1
add_interface_port phy_rx_st phy_rx_st_valid valid Input 1


# 
# connection point tlp_rx_st
# 
add_interface tlp_rx_st avalon_streaming start
set_interface_property tlp_rx_st associatedClock clk
set_interface_property tlp_rx_st associatedReset reset
set_interface_property tlp_rx_st dataBitsPerSymbol 8
set_interface_property tlp_rx_st errorDescriptor ""
set_interface_property tlp_rx_st firstSymbolInHighOrderBits true
set_interface_property tlp_rx_st maxChannel 0
set_interface_property tlp_rx_st readyLatency 3
set_interface_property tlp_rx_st ENABLED true
set_interface_property tlp_rx_st EXPORT_OF ""
set_interface_property tlp_rx_st PORT_NAME_MAP ""
set_interface_property tlp_rx_st CMSIS_SVD_VARIABLES ""
set_interface_property tlp_rx_st SVD_ADDRESS_GROUP ""

add_interface_port tlp_rx_st tlp_rx_st_data data Output 256
add_interface_port tlp_rx_st tlp_rx_st_empty empty Output 5
add_interface_port tlp_rx_st tlp_rx_st_endofpacket endofpacket Output 1
add_interface_port tlp_rx_st tlp_rx_st_error error Output 1
add_interface_port tlp_rx_st tlp_rx_st_startofpacket startofpacket Output 1
add_interface_port tlp_rx_st tlp_rx_st_valid valid Output 1
add_interface_port tlp_rx_st tlp_rx_st_ready ready Input 1


# 
# connection point tlp_tx_st
# 
add_interface tlp_tx_st avalon_streaming end
set_interface_property tlp_tx_st associatedClock clk
set_interface_property tlp_tx_st associatedReset reset
set_interface_property tlp_tx_st dataBitsPerSymbol 8
set_interface_property tlp_tx_st errorDescriptor ""
set_interface_property tlp_tx_st firstSymbolInHighOrderBits true
set_interface_property tlp_tx_st maxChannel 255
set_interface_property tlp_tx_st readyLatency 3
set_interface_property tlp_tx_st ENABLED true
set_interface_property tlp_tx_st EXPORT_OF ""
set_interface_property tlp_tx_st PORT_NAME_MAP ""
set_interface_property tlp_tx_st CMSIS_SVD_VARIABLES ""
set_interface_property tlp_tx_st SVD_ADDRESS_GROUP ""

add_interface_port tlp_tx_st tlp_tx_st_data data Input 256
add_interface_port tlp_tx_st tlp_tx_st_empty empty Input 5
add_interface_port tlp_tx_st tlp_tx_st_endofpacket endofpacket Input 1
add_interface_port tlp_tx_st tlp_tx_st_startofpacket startofpacket Input 1
add_interface_port tlp_tx_st tlp_tx_st_ready ready Output 1
add_interface_port tlp_tx_st tlp_tx_st_valid valid Input 1
add_interface_port tlp_tx_st tlp_tx_st_channel channel Input 8

