# TCL File Generated by Component Editor 19.1
# Thu Oct 03 22:48:40 CEST 2019
# DO NOT MODIFY


# 
# sfp_port "SFP Port" v1.0
# bluecmd 2019.10.03.22:48:40
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module sfp_port
# 
set_module_property DESCRIPTION ""
set_module_property NAME sfp_port
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR bluecmd
set_module_property DISPLAY_NAME "SFP Port"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sfp_port
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file sfp_port.sv SYSTEM_VERILOG PATH sfp_port.sv TOP_LEVEL_FILE


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
# connection point sfp
# 
add_interface sfp conduit end
set_interface_property sfp associatedClock clk
set_interface_property sfp associatedReset ""
set_interface_property sfp ENABLED true
set_interface_property sfp EXPORT_OF ""
set_interface_property sfp PORT_NAME_MAP ""
set_interface_property sfp CMSIS_SVD_VARIABLES ""
set_interface_property sfp SVD_ADDRESS_GROUP ""

add_interface_port sfp los los Input 1
add_interface_port sfp mod0_prsnt_n prsnt_n Input 1
add_interface_port sfp tx_disable txdis Output 1
add_interface_port sfp mod1_scl scl Bidir 1
add_interface_port sfp mod2_sda sda Bidir 1
add_interface_port sfp ratesel ratesel Output 2
add_interface_port sfp tx_fault txfail Input 1


# 
# connection point mm
# 
add_interface mm avalon end
set_interface_property mm addressUnits WORDS
set_interface_property mm associatedClock clk
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
set_interface_property mm readWaitStates 0
set_interface_property mm readWaitTime 0
set_interface_property mm setupTime 0
set_interface_property mm timingUnits Cycles
set_interface_property mm writeWaitTime 0
set_interface_property mm ENABLED true
set_interface_property mm EXPORT_OF ""
set_interface_property mm PORT_NAME_MAP ""
set_interface_property mm CMSIS_SVD_VARIABLES ""
set_interface_property mm SVD_ADDRESS_GROUP ""

add_interface_port mm mm_address address Input 4
add_interface_port mm mm_read read Input 1
add_interface_port mm mm_readdata readdata Output 8
add_interface_port mm mm_write write Input 1
add_interface_port mm mm_writedata writedata Input 8
add_interface_port mm mm_response response Output 2
set_interface_assignment mm embeddedsw.configuration.isFlash 0
set_interface_assignment mm embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment mm embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment mm embeddedsw.configuration.isPrintableDevice 0


# 
# connection point i2c
# 
add_interface i2c conduit end
set_interface_property i2c associatedClock ""
set_interface_property i2c associatedReset ""
set_interface_property i2c ENABLED true
set_interface_property i2c EXPORT_OF ""
set_interface_property i2c PORT_NAME_MAP ""
set_interface_property i2c CMSIS_SVD_VARIABLES ""
set_interface_property i2c SVD_ADDRESS_GROUP ""

add_interface_port i2c sda_in sda_in Output 1
add_interface_port i2c sda_oe sda_oe Input 1
add_interface_port i2c scl_in scl_in Output 1
add_interface_port i2c scl_oe scl_oe Input 1

