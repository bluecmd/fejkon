# TCL File Generated by Component Editor 19.1
# Tue Nov 05 19:42:13 CET 2019
# DO NOT MODIFY


# 
# pcie_msi_intr "PCIe MSI Interrupt Controller" v1.0
# bluecmd 2019.11.05.19:42:13
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module pcie_msi_intr
# 
set_module_property DESCRIPTION ""
set_module_property NAME pcie_msi_intr
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR bluecmd
set_module_property DISPLAY_NAME "PCIe MSI Interrupt Controller"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pcie_msi_intr
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file pcie_msi_intr.sv SYSTEM_VERILOG PATH pcie_msi_intr.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL pcie_msi_intr
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file pcie_msi_intr.sv SYSTEM_VERILOG PATH pcie_msi_intr.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point int_msi
# 
add_interface int_msi conduit end
set_interface_property int_msi associatedClock ""
set_interface_property int_msi associatedReset ""
set_interface_property int_msi ENABLED true
set_interface_property int_msi EXPORT_OF ""
set_interface_property int_msi PORT_NAME_MAP ""
set_interface_property int_msi CMSIS_SVD_VARIABLES ""
set_interface_property int_msi SVD_ADDRESS_GROUP ""

add_interface_port int_msi app_int_sts app_int_sts Output 1
add_interface_port int_msi app_msi_num app_msi_num Output 5
add_interface_port int_msi app_msi_req app_msi_req Output 1
add_interface_port int_msi app_msi_tc app_msi_tc Output 3
add_interface_port int_msi app_int_ack app_int_ack Input 1
add_interface_port int_msi app_msi_ack app_msi_ack Input 1


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
# connection point irq
# 
add_interface irq interrupt start
set_interface_property irq associatedAddressablePoint ""
set_interface_property irq associatedClock clk
set_interface_property irq associatedReset reset
set_interface_property irq irqScheme INDIVIDUAL_REQUESTS
set_interface_property irq ENABLED true
set_interface_property irq EXPORT_OF ""
set_interface_property irq PORT_NAME_MAP ""
set_interface_property irq CMSIS_SVD_VARIABLES ""
set_interface_property irq SVD_ADDRESS_GROUP ""

add_interface_port irq irq irq Input 8

