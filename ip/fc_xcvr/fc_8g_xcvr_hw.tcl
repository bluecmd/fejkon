# TCL File Generated by Component Editor 19.1
# Fri Nov 01 20:22:47 CET 2019
# DO NOT MODIFY


# 
# fc_8g_xcvr "Fibre Chnannel 8G Transceiver" v1.0
# bluecmd 2019.11.01.20:22:47
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module fc_8g_xcvr
# 
set_module_property DESCRIPTION ""
set_module_property NAME fc_8g_xcvr
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR bluecmd
set_module_property DISPLAY_NAME "Fibre Chnannel 8G Transceiver"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL fc_8g_xcvr
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file fc.sv SYSTEM_VERILOG PATH ../fc.sv
add_fileset_file fc_8g_xcvr.sdc SDC PATH fc_8g_xcvr.sdc
add_fileset_file fc_phy.v VERILOG PATH ../altera_fc_phy/fc_phy_sim/fc_phy.v
add_fileset_file altera_xcvr_functions.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/altera_xcvr_functions.sv
add_fileset_file altera_xcvr_custom.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/altera_xcvr_custom.sv
add_fileset_file sv_xcvr_custom_nr.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_custom_nr.sv
add_fileset_file sv_xcvr_custom_native.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_custom_native.sv
add_fileset_file alt_xcvr_resync.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_resync.sv
add_fileset_file alt_xcvr_csr_common_h.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_csr_common_h.sv
add_fileset_file alt_xcvr_csr_common.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_csr_common.sv
add_fileset_file alt_xcvr_csr_pcs8g_h.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_csr_pcs8g_h.sv
add_fileset_file alt_xcvr_csr_pcs8g.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_csr_pcs8g.sv
add_fileset_file alt_xcvr_csr_selector.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_csr_selector.sv
add_fileset_file alt_xcvr_mgmt2dec.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_mgmt2dec.sv
add_fileset_file altera_wait_generate.v SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/altera_wait_generate.v
add_fileset_file sv_pcs.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_pcs.sv
add_fileset_file sv_pcs_ch.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_pcs_ch.sv
add_fileset_file sv_pma.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_pma.sv
add_fileset_file sv_reconfig_bundle_to_xcvr.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_reconfig_bundle_to_xcvr.sv
add_fileset_file sv_reconfig_bundle_to_ip.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_reconfig_bundle_to_ip.sv
add_fileset_file sv_reconfig_bundle_merger.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_reconfig_bundle_merger.sv
add_fileset_file sv_rx_pma.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_rx_pma.sv
add_fileset_file sv_tx_pma.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_tx_pma.sv
add_fileset_file sv_tx_pma_ch.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_tx_pma_ch.sv
add_fileset_file sv_xcvr_h.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_h.sv
add_fileset_file sv_xcvr_avmm_csr.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_avmm_csr.sv
add_fileset_file sv_xcvr_avmm_dcd.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_avmm_dcd.sv
add_fileset_file sv_xcvr_avmm.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_avmm.sv
add_fileset_file sv_xcvr_data_adapter.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_data_adapter.sv
add_fileset_file sv_xcvr_native.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_native.sv
add_fileset_file sv_xcvr_plls.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_xcvr_plls.sv
add_fileset_file sv_hssi_10g_rx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_10g_rx_pcs_rbc.sv
add_fileset_file sv_hssi_10g_tx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_10g_tx_pcs_rbc.sv
add_fileset_file sv_hssi_8g_rx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_8g_rx_pcs_rbc.sv
add_fileset_file sv_hssi_8g_tx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_8g_tx_pcs_rbc.sv
add_fileset_file sv_hssi_8g_pcs_aggregate_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_8g_pcs_aggregate_rbc.sv
add_fileset_file sv_hssi_common_pcs_pma_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_common_pcs_pma_interface_rbc.sv
add_fileset_file sv_hssi_common_pld_pcs_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_common_pld_pcs_interface_rbc.sv
add_fileset_file sv_hssi_pipe_gen1_2_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_pipe_gen1_2_rbc.sv
add_fileset_file sv_hssi_pipe_gen3_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_pipe_gen3_rbc.sv
add_fileset_file sv_hssi_rx_pcs_pma_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_rx_pcs_pma_interface_rbc.sv
add_fileset_file sv_hssi_rx_pld_pcs_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_rx_pld_pcs_interface_rbc.sv
add_fileset_file sv_hssi_tx_pcs_pma_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_tx_pcs_pma_interface_rbc.sv
add_fileset_file sv_hssi_tx_pld_pcs_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/sv_hssi_tx_pld_pcs_interface_rbc.sv
add_fileset_file altera_xcvr_reset_control.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/altera_xcvr_reset_control.sv
add_fileset_file alt_xcvr_reset_counter.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_reset_counter.sv
add_fileset_file alt_xcvr_arbiter.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_arbiter.sv
add_fileset_file alt_xcvr_m2s.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy/alt_xcvr_m2s.sv
add_fileset_file fc_8g_xcvr.sv SYSTEM_VERILOG PATH fc_8g_xcvr.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL fc_8g_xcvr
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file fc.sv SYSTEM_VERILOG PATH ../fc.sv
add_fileset_file fc_phy.v VERILOG PATH ../altera_fc_phy/fc_phy_sim/fc_phy.v
add_fileset_file altera_xcvr_functions.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/altera_xcvr_functions.sv MENTOR_SPECIFIC
add_fileset_file altera_xcvr_custom.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/altera_xcvr_custom.sv
add_fileset_file sv_xcvr_custom_nr.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/sv_xcvr_custom_nr.sv
add_fileset_file sv_xcvr_custom_native.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/sv_xcvr_custom_native.sv
add_fileset_file alt_xcvr_resync.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_resync.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_csr_common_h.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_csr_common_h.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_csr_common.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_csr_common.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_csr_pcs8g_h.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_csr_pcs8g_h.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_csr_pcs8g.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_csr_pcs8g.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_csr_selector.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_csr_selector.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_mgmt2dec.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_mgmt2dec.sv MENTOR_SPECIFIC
add_fileset_file altera_wait_generate.v VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/altera_wait_generate.v MENTOR_SPECIFIC
add_fileset_file sv_pcs.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_pcs.sv MENTOR_SPECIFIC
add_fileset_file sv_pcs_ch.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_pcs_ch.sv MENTOR_SPECIFIC
add_fileset_file sv_pma.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_pma.sv MENTOR_SPECIFIC
add_fileset_file sv_reconfig_bundle_to_xcvr.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_reconfig_bundle_to_xcvr.sv MENTOR_SPECIFIC
add_fileset_file sv_reconfig_bundle_to_ip.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_reconfig_bundle_to_ip.sv MENTOR_SPECIFIC
add_fileset_file sv_reconfig_bundle_merger.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_reconfig_bundle_merger.sv MENTOR_SPECIFIC
add_fileset_file sv_rx_pma.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_rx_pma.sv MENTOR_SPECIFIC
add_fileset_file sv_tx_pma.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_tx_pma.sv MENTOR_SPECIFIC
add_fileset_file sv_tx_pma_ch.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_tx_pma_ch.sv MENTOR_SPECIFIC
add_fileset_file sv_xcvr_h.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_xcvr_h.sv MENTOR_SPECIFIC
add_fileset_file sv_xcvr_avmm_csr.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_xcvr_avmm_csr.sv MENTOR_SPECIFIC
add_fileset_file sv_xcvr_avmm_dcd.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_xcvr_avmm_dcd.sv MENTOR_SPECIFIC
add_fileset_file sv_xcvr_avmm.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_xcvr_avmm.sv MENTOR_SPECIFIC
add_fileset_file sv_xcvr_data_adapter.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_xcvr_data_adapter.sv MENTOR_SPECIFIC
add_fileset_file sv_xcvr_native.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_xcvr_native.sv MENTOR_SPECIFIC
add_fileset_file sv_xcvr_plls.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_xcvr_plls.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_10g_rx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_10g_rx_pcs_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_10g_tx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_10g_tx_pcs_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_8g_rx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_8g_rx_pcs_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_8g_tx_pcs_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_8g_tx_pcs_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_8g_pcs_aggregate_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_8g_pcs_aggregate_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_common_pcs_pma_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_common_pcs_pma_interface_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_common_pld_pcs_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_common_pld_pcs_interface_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_pipe_gen1_2_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_pipe_gen1_2_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_pipe_gen3_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_pipe_gen3_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_rx_pcs_pma_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_rx_pcs_pma_interface_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_rx_pld_pcs_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_rx_pld_pcs_interface_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_tx_pcs_pma_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_tx_pcs_pma_interface_rbc.sv MENTOR_SPECIFIC
add_fileset_file sv_hssi_tx_pld_pcs_interface_rbc.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/sv_hssi_tx_pld_pcs_interface_rbc.sv MENTOR_SPECIFIC
add_fileset_file altera_xcvr_reset_control.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/altera_xcvr_reset_control.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_reset_counter.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_reset_counter.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_arbiter.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_arbiter.sv MENTOR_SPECIFIC
add_fileset_file alt_xcvr_m2s.sv SYSTEM_VERILOG PATH ../altera_fc_phy/fc_phy_sim/altera_xcvr_custom_phy/mentor/alt_xcvr_m2s.sv MENTOR_SPECIFIC
add_fileset_file fc_8g_xcvr.sv SYSTEM_VERILOG PATH fc_8g_xcvr.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point avtx
# 
add_interface avtx avalon_streaming end
set_interface_property avtx associatedClock tx_clk
set_interface_property avtx associatedReset reset
set_interface_property avtx dataBitsPerSymbol 9
set_interface_property avtx errorDescriptor ""
set_interface_property avtx firstSymbolInHighOrderBits true
set_interface_property avtx maxChannel 0
set_interface_property avtx readyLatency 0
set_interface_property avtx ENABLED true
set_interface_property avtx EXPORT_OF ""
set_interface_property avtx PORT_NAME_MAP ""
set_interface_property avtx CMSIS_SVD_VARIABLES ""
set_interface_property avtx SVD_ADDRESS_GROUP ""

add_interface_port avtx avtx_data data Input 36
add_interface_port avtx avtx_ready ready Output 1
add_interface_port avtx avtx_valid valid Input 1


# 
# connection point avrx
# 
add_interface avrx avalon_streaming start
set_interface_property avrx associatedClock rx_clk
set_interface_property avrx associatedReset reset
set_interface_property avrx dataBitsPerSymbol 9
set_interface_property avrx errorDescriptor ""
set_interface_property avrx firstSymbolInHighOrderBits true
set_interface_property avrx maxChannel 0
set_interface_property avrx readyLatency 0
set_interface_property avrx ENABLED true
set_interface_property avrx EXPORT_OF ""
set_interface_property avrx PORT_NAME_MAP ""
set_interface_property avrx CMSIS_SVD_VARIABLES ""
set_interface_property avrx SVD_ADDRESS_GROUP ""

add_interface_port avrx avrx_data data Output 36
add_interface_port avrx avrx_valid valid Output 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock mgmt_clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point mgmt_clk
# 
add_interface mgmt_clk clock end
set_interface_property mgmt_clk clockRate 0
set_interface_property mgmt_clk ENABLED true
set_interface_property mgmt_clk EXPORT_OF ""
set_interface_property mgmt_clk PORT_NAME_MAP ""
set_interface_property mgmt_clk CMSIS_SVD_VARIABLES ""
set_interface_property mgmt_clk SVD_ADDRESS_GROUP ""

add_interface_port mgmt_clk mgmt_clk clk Input 1


# 
# connection point mgmt_mm
# 
add_interface mgmt_mm avalon end
set_interface_property mgmt_mm addressUnits WORDS
set_interface_property mgmt_mm associatedClock mgmt_clk
set_interface_property mgmt_mm associatedReset reset
set_interface_property mgmt_mm bitsPerSymbol 8
set_interface_property mgmt_mm burstOnBurstBoundariesOnly false
set_interface_property mgmt_mm burstcountUnits WORDS
set_interface_property mgmt_mm explicitAddressSpan 0
set_interface_property mgmt_mm holdTime 0
set_interface_property mgmt_mm linewrapBursts false
set_interface_property mgmt_mm maximumPendingReadTransactions 0
set_interface_property mgmt_mm maximumPendingWriteTransactions 0
set_interface_property mgmt_mm readLatency 0
set_interface_property mgmt_mm readWaitTime 1
set_interface_property mgmt_mm setupTime 0
set_interface_property mgmt_mm timingUnits Cycles
set_interface_property mgmt_mm writeWaitTime 0
set_interface_property mgmt_mm ENABLED true
set_interface_property mgmt_mm EXPORT_OF ""
set_interface_property mgmt_mm PORT_NAME_MAP ""
set_interface_property mgmt_mm CMSIS_SVD_VARIABLES ""
set_interface_property mgmt_mm SVD_ADDRESS_GROUP ""

add_interface_port mgmt_mm mm_address address Input 10
add_interface_port mgmt_mm mm_waitrequest waitrequest Output 1
add_interface_port mgmt_mm mm_read read Input 1
add_interface_port mgmt_mm mm_write write Input 1
add_interface_port mgmt_mm mm_readdata readdata Output 32
add_interface_port mgmt_mm mm_writedata writedata Input 32
set_interface_assignment mgmt_mm embeddedsw.configuration.isFlash 0
set_interface_assignment mgmt_mm embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment mgmt_mm embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment mgmt_mm embeddedsw.configuration.isPrintableDevice 0


# 
# connection point tx_clk
# 
add_interface tx_clk clock start
set_interface_property tx_clk associatedDirectClock ""
set_interface_property tx_clk clockRate 0
set_interface_property tx_clk clockRateKnown false
set_interface_property tx_clk ENABLED true
set_interface_property tx_clk EXPORT_OF ""
set_interface_property tx_clk PORT_NAME_MAP ""
set_interface_property tx_clk CMSIS_SVD_VARIABLES ""
set_interface_property tx_clk SVD_ADDRESS_GROUP ""

add_interface_port tx_clk tx_clk clk Output 1


# 
# connection point rx_clk
# 
add_interface rx_clk clock start
set_interface_property rx_clk associatedDirectClock ""
set_interface_property rx_clk clockRate 0
set_interface_property rx_clk clockRateKnown false
set_interface_property rx_clk ENABLED true
set_interface_property rx_clk EXPORT_OF ""
set_interface_property rx_clk PORT_NAME_MAP ""
set_interface_property rx_clk CMSIS_SVD_VARIABLES ""
set_interface_property rx_clk SVD_ADDRESS_GROUP ""

add_interface_port rx_clk rx_clk clk Output 1


# 
# connection point line_td
# 
add_interface line_td conduit end
set_interface_property line_td associatedClock ""
set_interface_property line_td associatedReset ""
set_interface_property line_td ENABLED true
set_interface_property line_td EXPORT_OF ""
set_interface_property line_td PORT_NAME_MAP ""
set_interface_property line_td CMSIS_SVD_VARIABLES ""
set_interface_property line_td SVD_ADDRESS_GROUP ""

add_interface_port line_td td_p lvds Output 1


# 
# connection point line_rd
# 
add_interface line_rd conduit end
set_interface_property line_rd associatedClock ""
set_interface_property line_rd associatedReset ""
set_interface_property line_rd ENABLED true
set_interface_property line_rd EXPORT_OF ""
set_interface_property line_rd PORT_NAME_MAP ""
set_interface_property line_rd CMSIS_SVD_VARIABLES ""
set_interface_property line_rd SVD_ADDRESS_GROUP ""

add_interface_port line_rd rd_p lvds Input 1


# 
# connection point reconfig_from_xcvr
# 
add_interface reconfig_from_xcvr conduit end
set_interface_property reconfig_from_xcvr associatedClock ""
set_interface_property reconfig_from_xcvr associatedReset ""
set_interface_property reconfig_from_xcvr ENABLED true
set_interface_property reconfig_from_xcvr EXPORT_OF ""
set_interface_property reconfig_from_xcvr PORT_NAME_MAP ""
set_interface_property reconfig_from_xcvr CMSIS_SVD_VARIABLES ""
set_interface_property reconfig_from_xcvr SVD_ADDRESS_GROUP ""

add_interface_port reconfig_from_xcvr reconfig_from_xcvr reconfig_from_xcvr Output 92


# 
# connection point reconfig_to_xcvr
# 
add_interface reconfig_to_xcvr conduit end
set_interface_property reconfig_to_xcvr associatedClock ""
set_interface_property reconfig_to_xcvr associatedReset ""
set_interface_property reconfig_to_xcvr ENABLED true
set_interface_property reconfig_to_xcvr EXPORT_OF ""
set_interface_property reconfig_to_xcvr PORT_NAME_MAP ""
set_interface_property reconfig_to_xcvr CMSIS_SVD_VARIABLES ""
set_interface_property reconfig_to_xcvr SVD_ADDRESS_GROUP ""

add_interface_port reconfig_to_xcvr reconfig_to_xcvr reconfig_to_xcvr Input 140


# 
# connection point phy_clk
# 
add_interface phy_clk clock end
set_interface_property phy_clk clockRate 0
set_interface_property phy_clk ENABLED true
set_interface_property phy_clk EXPORT_OF ""
set_interface_property phy_clk PORT_NAME_MAP ""
set_interface_property phy_clk CMSIS_SVD_VARIABLES ""
set_interface_property phy_clk SVD_ADDRESS_GROUP ""

add_interface_port phy_clk phy_clk clk Input 1


# 
# connection point aligned
# 
add_interface aligned conduit end
set_interface_property aligned associatedClock ""
set_interface_property aligned associatedReset ""
set_interface_property aligned ENABLED true
set_interface_property aligned EXPORT_OF ""
set_interface_property aligned PORT_NAME_MAP ""
set_interface_property aligned CMSIS_SVD_VARIABLES ""
set_interface_property aligned SVD_ADDRESS_GROUP ""

add_interface_port aligned aligned aligned Output 1

