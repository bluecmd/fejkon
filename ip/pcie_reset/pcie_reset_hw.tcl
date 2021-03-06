# TCL File Generated by Component Editor 19.1
# Thu Oct 10 22:22:52 CEST 2019
# DO NOT MODIFY


# 
# pcie_reset "PCIe Reset" v1.0
# bluecmd 2019.10.10.22:22:52
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module pcie_reset
# 
set_module_property DESCRIPTION ""
set_module_property NAME pcie_reset
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR bluecmd
set_module_property DISPLAY_NAME "PCIe Reset"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pcie_reset
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file pcie_reset.sv SYSTEM_VERILOG PATH pcie_reset.sv TOP_LEVEL_FILE
add_fileset_file pcie_reset.sdc SDC PATH pcie_reset.sdc

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL pcie_reset
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file pcie_reset.sv SYSTEM_VERILOG PATH pcie_reset.sv


# 
# parameters
# 


# 
# display items
# 


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
# connection point npor
# 
add_interface npor conduit end
set_interface_property npor associatedClock ""
set_interface_property npor associatedReset ""
set_interface_property npor ENABLED true
set_interface_property npor EXPORT_OF ""
set_interface_property npor PORT_NAME_MAP ""
set_interface_property npor CMSIS_SVD_VARIABLES ""
set_interface_property npor SVD_ADDRESS_GROUP ""

add_interface_port npor pin_perst pin_perst Output 1
add_interface_port npor npor npor Output 1


# 
# connection point pin
# 
add_interface pin conduit end
set_interface_property pin associatedClock ""
set_interface_property pin associatedReset ""
set_interface_property pin ENABLED true
set_interface_property pin EXPORT_OF ""
set_interface_property pin PORT_NAME_MAP ""
set_interface_property pin CMSIS_SVD_VARIABLES ""
set_interface_property pin SVD_ADDRESS_GROUP ""

add_interface_port pin perst_n perst_n Input 1


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

