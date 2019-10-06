# qsys scripting (.tcl) file for fejkon_pcie
package require -exact qsys 16.0

create_system {fejkon_pcie}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance alt_xcvr_reconfig_0 alt_xcvr_reconfig 19.1
set_instance_parameter_value alt_xcvr_reconfig_0 {ber_en} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_adce} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_analog} {1}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dcd} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dcd_power_up} {1}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dfe} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_eyemon} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_mif} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {enable_offset} {1}
set_instance_parameter_value alt_xcvr_reconfig_0 {gui_cal_status_port} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {gui_enable_pll} {0}
set_instance_parameter_value alt_xcvr_reconfig_0 {gui_split_sizes} {}
set_instance_parameter_value alt_xcvr_reconfig_0 {number_of_reconfig_interfaces} {11}

add_instance bar2_cdc altera_avalon_mm_clock_crossing_bridge 19.1
set_instance_parameter_value bar2_cdc {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value bar2_cdc {ADDRESS_WIDTH} {24}
set_instance_parameter_value bar2_cdc {COMMAND_FIFO_DEPTH} {4}
set_instance_parameter_value bar2_cdc {DATA_WIDTH} {32}
set_instance_parameter_value bar2_cdc {MASTER_SYNC_DEPTH} {2}
set_instance_parameter_value bar2_cdc {MAX_BURST_SIZE} {1}
set_instance_parameter_value bar2_cdc {RESPONSE_FIFO_DEPTH} {4}
set_instance_parameter_value bar2_cdc {SLAVE_SYNC_DEPTH} {2}
set_instance_parameter_value bar2_cdc {SYMBOL_WIDTH} {8}
set_instance_parameter_value bar2_cdc {USE_AUTO_ADDRESS_WIDTH} {1}

add_instance dma_descr altera_avalon_onchip_memory2 19.1
set_instance_parameter_value dma_descr {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value dma_descr {blockType} {AUTO}
set_instance_parameter_value dma_descr {copyInitFile} {0}
set_instance_parameter_value dma_descr {dataWidth} {256}
set_instance_parameter_value dma_descr {dataWidth2} {32}
set_instance_parameter_value dma_descr {dualPort} {1}
set_instance_parameter_value dma_descr {ecc_enabled} {0}
set_instance_parameter_value dma_descr {enPRInitMode} {0}
set_instance_parameter_value dma_descr {enableDiffWidth} {0}
set_instance_parameter_value dma_descr {initMemContent} {0}
set_instance_parameter_value dma_descr {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value dma_descr {instanceID} {NONE}
set_instance_parameter_value dma_descr {memorySize} {4096.0}
set_instance_parameter_value dma_descr {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value dma_descr {resetrequest_enabled} {1}
set_instance_parameter_value dma_descr {simAllowMRAMContentsFile} {0}
set_instance_parameter_value dma_descr {simMemInitOnlyFilename} {0}
set_instance_parameter_value dma_descr {singleClockOperation} {0}
set_instance_parameter_value dma_descr {slave1Latency} {1}
set_instance_parameter_value dma_descr {slave2Latency} {1}
set_instance_parameter_value dma_descr {useNonDefaultInitFile} {0}
set_instance_parameter_value dma_descr {useShallowMemBlocks} {0}
set_instance_parameter_value dma_descr {writable} {1}

add_instance dma_rd_pipeline altera_avalon_mm_bridge 19.1
set_instance_parameter_value dma_rd_pipeline {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value dma_rd_pipeline {ADDRESS_WIDTH} {10}
set_instance_parameter_value dma_rd_pipeline {DATA_WIDTH} {256}
set_instance_parameter_value dma_rd_pipeline {LINEWRAPBURSTS} {0}
set_instance_parameter_value dma_rd_pipeline {MAX_BURST_SIZE} {16}
set_instance_parameter_value dma_rd_pipeline {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value dma_rd_pipeline {PIPELINE_COMMAND} {1}
set_instance_parameter_value dma_rd_pipeline {PIPELINE_RESPONSE} {1}
set_instance_parameter_value dma_rd_pipeline {SYMBOL_WIDTH} {8}
set_instance_parameter_value dma_rd_pipeline {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value dma_rd_pipeline {USE_RESPONSE} {0}

add_instance dma_wr_pipeline altera_avalon_mm_bridge 19.1
set_instance_parameter_value dma_wr_pipeline {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value dma_wr_pipeline {ADDRESS_WIDTH} {10}
set_instance_parameter_value dma_wr_pipeline {DATA_WIDTH} {256}
set_instance_parameter_value dma_wr_pipeline {LINEWRAPBURSTS} {0}
set_instance_parameter_value dma_wr_pipeline {MAX_BURST_SIZE} {16}
set_instance_parameter_value dma_wr_pipeline {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value dma_wr_pipeline {PIPELINE_COMMAND} {1}
set_instance_parameter_value dma_wr_pipeline {PIPELINE_RESPONSE} {1}
set_instance_parameter_value dma_wr_pipeline {SYMBOL_WIDTH} {8}
set_instance_parameter_value dma_wr_pipeline {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value dma_wr_pipeline {USE_RESPONSE} {0}

add_instance mgmt_clk altera_clock_bridge 19.1
set_instance_parameter_value mgmt_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value mgmt_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance mgmt_rst altera_reset_bridge 19.1
set_instance_parameter_value mgmt_rst {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value mgmt_rst {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value mgmt_rst {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value mgmt_rst {USE_RESET_REQUEST} {0}

add_instance pcie_reconfig_driver_0 altera_pcie_reconfig_driver 19.1
set_instance_parameter_value pcie_reconfig_driver_0 {enable_cal_busy_hwtcl} {0}
set_instance_parameter_value pcie_reconfig_driver_0 {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value pcie_reconfig_driver_0 {number_of_reconfig_interfaces} {11}

add_instance pcie_reset pcie_reset 1.0

add_instance phy altera_pcie_256_hip_avmm 19.1
set_instance_parameter_value phy {CB_P2A_AVALON_ADDR_B0} {0}
set_instance_parameter_value phy {CB_P2A_AVALON_ADDR_B1} {0}
set_instance_parameter_value phy {CB_P2A_AVALON_ADDR_B2} {0}
set_instance_parameter_value phy {CB_P2A_AVALON_ADDR_B3} {0}
set_instance_parameter_value phy {CB_P2A_AVALON_ADDR_B4} {0}
set_instance_parameter_value phy {CB_P2A_AVALON_ADDR_B5} {0}
set_instance_parameter_value phy {CB_P2A_FIXED_AVALON_ADDR_B0} {0}
set_instance_parameter_value phy {CB_P2A_FIXED_AVALON_ADDR_B1} {0}
set_instance_parameter_value phy {CB_P2A_FIXED_AVALON_ADDR_B2} {0}
set_instance_parameter_value phy {CB_P2A_FIXED_AVALON_ADDR_B3} {0}
set_instance_parameter_value phy {CB_P2A_FIXED_AVALON_ADDR_B4} {0}
set_instance_parameter_value phy {CB_P2A_FIXED_AVALON_ADDR_B5} {0}
set_instance_parameter_value phy {CG_COMMON_CLOCK_MODE} {1}
set_instance_parameter_value phy {CG_RXM_IRQ_NUM} {16}
set_instance_parameter_value phy {NUM_PREFETCH_MASTERS} {1}
set_instance_parameter_value phy {TX_S_ADDR_WIDTH} {32}
set_instance_parameter_value phy {add_pll_to_hip_coreclkout} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_atomic_malformed} {true}
set_instance_parameter_value phy {advanced_default_hwtcl_atomic_op_completer_32bit} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_atomic_op_completer_64bit} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_atomic_op_routing} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_bridge_port_ssid_support} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_bridge_port_vga_enable} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_bypass_cdc} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_cas_completer_128bit} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_cdc_dummy_insert_limit} {11}
set_instance_parameter_value phy {advanced_default_hwtcl_d0_pme} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_d1_pme} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_d1_support} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_d2_pme} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_d2_support} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_d3_cold_pme} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_d3_hot_pme} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_data_pack_rx} {disable}
set_instance_parameter_value phy {advanced_default_hwtcl_deskew_comma} {com_deskw}
set_instance_parameter_value phy {advanced_default_hwtcl_device_number} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_disable_link_x2_support} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_disable_snoop_packet} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_ei_delay_powerdown_count} {10}
set_instance_parameter_value phy {advanced_default_hwtcl_eie_before_nfts_count} {4}
set_instance_parameter_value phy {advanced_default_hwtcl_enable_adapter_half_rate_mode} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_enable_l1_aspm} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_enable_rx_buffer_checking} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_extended_format_field} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_extended_tag_reset} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_fc_init_timer} {1024}
set_instance_parameter_value phy {advanced_default_hwtcl_flow_control_timeout_count} {200}
set_instance_parameter_value phy {advanced_default_hwtcl_flow_control_update_count} {30}
set_instance_parameter_value phy {advanced_default_hwtcl_flr_capability} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_gen2_diffclock_nfts_count} {255}
set_instance_parameter_value phy {advanced_default_hwtcl_gen2_sameclock_nfts_count} {255}
set_instance_parameter_value phy {advanced_default_hwtcl_hot_plug_support} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_interrupt_pin} {inta}
set_instance_parameter_value phy {advanced_default_hwtcl_l01_entry_latency} {31}
set_instance_parameter_value phy {advanced_default_hwtcl_l0_exit_latency_diffclock} {6}
set_instance_parameter_value phy {advanced_default_hwtcl_l0_exit_latency_sameclock} {6}
set_instance_parameter_value phy {advanced_default_hwtcl_l1_exit_latency_diffclock} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_l1_exit_latency_sameclock} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_low_priority_vc} {single_vc}
set_instance_parameter_value phy {advanced_default_hwtcl_ltr_mechanism} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_ltssm_1ms_timeout} {disable}
set_instance_parameter_value phy {advanced_default_hwtcl_ltssm_freqlocked_check} {disable}
set_instance_parameter_value phy {advanced_default_hwtcl_maximum_current} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_no_command_completed} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_no_soft_reset} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_pclk_out_sel} {pclk}
set_instance_parameter_value phy {advanced_default_hwtcl_pipex1_debug_sel} {disable}
set_instance_parameter_value phy {advanced_default_hwtcl_register_pipe_signals} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_reserved_debug} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_retry_buffer_last_active_address} {2047}
set_instance_parameter_value phy {advanced_default_hwtcl_rx_l0s_count_idl} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_set_l0s} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_skp_os_gen3_count} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_skp_os_schedule_count} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_ssid} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_ssvid} {0}
set_instance_parameter_value phy {advanced_default_hwtcl_tph_completer} {false}
set_instance_parameter_value phy {advanced_default_hwtcl_tx_cdc_almost_empty} {5}
set_instance_parameter_value phy {advanced_default_hwtcl_vc0_clk_enable} {true}
set_instance_parameter_value phy {advanced_default_hwtcl_wrong_device_id} {disable}
set_instance_parameter_value phy {advanced_default_parameter_override} {0}
set_instance_parameter_value phy {altpcie_avmm_hwtcl} {1}
set_instance_parameter_value phy {app_interface_width_hwtcl} {256}
set_instance_parameter_value phy {av_rpre_emph_a_val_hwtcl} {12}
set_instance_parameter_value phy {av_rpre_emph_b_val_hwtcl} {0}
set_instance_parameter_value phy {av_rpre_emph_c_val_hwtcl} {19}
set_instance_parameter_value phy {av_rpre_emph_d_val_hwtcl} {13}
set_instance_parameter_value phy {av_rpre_emph_e_val_hwtcl} {21}
set_instance_parameter_value phy {av_rvod_sel_a_val_hwtcl} {42}
set_instance_parameter_value phy {av_rvod_sel_b_val_hwtcl} {30}
set_instance_parameter_value phy {av_rvod_sel_c_val_hwtcl} {43}
set_instance_parameter_value phy {av_rvod_sel_d_val_hwtcl} {43}
set_instance_parameter_value phy {av_rvod_sel_e_val_hwtcl} {9}
set_instance_parameter_value phy {avmm_width_hwtcl} {256}
set_instance_parameter_value phy {bar0_type_hwtcl} {64}
set_instance_parameter_value phy {bar1_type_hwtcl} {1}
set_instance_parameter_value phy {bar2_type_hwtcl} {32}
set_instance_parameter_value phy {bar3_type_hwtcl} {32}
set_instance_parameter_value phy {bar4_type_hwtcl} {1}
set_instance_parameter_value phy {bar5_type_hwtcl} {1}
set_instance_parameter_value phy {cdc_dummy_insert_limit_advanced_default_hwtcl} {11}
set_instance_parameter_value phy {class_code_hwtcl} {787456}
set_instance_parameter_value phy {completion_timeout_hwtcl} {NONE}
set_instance_parameter_value phy {cv_rpre_emph_a_val_hwtcl} {11}
set_instance_parameter_value phy {cv_rpre_emph_b_val_hwtcl} {0}
set_instance_parameter_value phy {cv_rpre_emph_c_val_hwtcl} {22}
set_instance_parameter_value phy {cv_rpre_emph_d_val_hwtcl} {12}
set_instance_parameter_value phy {cv_rpre_emph_e_val_hwtcl} {21}
set_instance_parameter_value phy {cv_rvod_sel_a_val_hwtcl} {50}
set_instance_parameter_value phy {cv_rvod_sel_b_val_hwtcl} {34}
set_instance_parameter_value phy {cv_rvod_sel_c_val_hwtcl} {50}
set_instance_parameter_value phy {cv_rvod_sel_d_val_hwtcl} {50}
set_instance_parameter_value phy {cv_rvod_sel_e_val_hwtcl} {9}
set_instance_parameter_value phy {d0_pme_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {d1_pme_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {d1_support_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {d2_pme_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {d2_support_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {d3_cold_pme_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {d3_hot_pme_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {deemphasis_enable_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {device_id_hwtcl} {3557}
set_instance_parameter_value phy {device_number_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {diffclock_nfts_count_advanced_default_hwtcl} {255}
set_instance_parameter_value phy {disable_link_x2_support_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {dll_active_report_support_hwtcl} {0}
set_instance_parameter_value phy {dma_use_scfifo_ext_hwtcl} {0}
set_instance_parameter_value phy {ecrc_check_capable_hwtcl} {0}
set_instance_parameter_value phy {ecrc_gen_capable_hwtcl} {0}
set_instance_parameter_value phy {ei_delay_powerdown_count_advanced_default_hwtcl} {10}
set_instance_parameter_value phy {eie_before_nfts_count_advanced_default_hwtcl} {4}
set_instance_parameter_value phy {enable_completion_timeout_disable_hwtcl} {1}
set_instance_parameter_value phy {enable_cra_hwtcl} {1}
set_instance_parameter_value phy {enable_function_msix_support_hwtcl} {0}
set_instance_parameter_value phy {enable_l1_aspm_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {enable_pcisigtest_hwtcl} {0}
set_instance_parameter_value phy {enable_power_on_rst_pulse_hwtcl} {0}
set_instance_parameter_value phy {enable_rx_buffer_checking_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {enable_rxm_burst_hwtcl} {0}
set_instance_parameter_value phy {enable_slot_register_hwtcl} {0}
set_instance_parameter_value phy {enable_tl_only_sim_hwtcl} {0}
set_instance_parameter_value phy {endpoint_l0_latency_hwtcl} {0}
set_instance_parameter_value phy {endpoint_l1_latency_hwtcl} {0}
set_instance_parameter_value phy {expansion_base_address_register_hwtcl} {0}
set_instance_parameter_value phy {extend_tag_field_hwtcl} {32}
set_instance_parameter_value phy {fc_init_timer_advanced_default_hwtcl} {1024}
set_instance_parameter_value phy {fixed_address_mode} {0}
set_instance_parameter_value phy {flow_control_timeout_count_advanced_default_hwtcl} {200}
set_instance_parameter_value phy {flow_control_update_count_advanced_default_hwtcl} {30}
set_instance_parameter_value phy {force_hrc} {0}
set_instance_parameter_value phy {force_src} {0}
set_instance_parameter_value phy {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value phy {gen2_diffclock_nfts_count_advanced_default_hwtcl} {255}
set_instance_parameter_value phy {gen2_sameclock_nfts_count_advanced_default_hwtcl} {255}
set_instance_parameter_value phy {gen3_rxfreqlock_counter_hwtcl} {0}
set_instance_parameter_value phy {generate_sdc_for_qsys_design_example} {0}
set_instance_parameter_value phy {hip_reconfig_hwtcl} {0}
set_instance_parameter_value phy {hip_tag_checking_hwtcl} {1}
set_instance_parameter_value phy {hot_plug_support_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {hwtcl_override_g2_txvod} {1}
set_instance_parameter_value phy {in_cvp_mode_hwtcl} {0}
set_instance_parameter_value phy {indicator_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {internal_controller_hwtcl} {1}
set_instance_parameter_value phy {io_window_addr_width_hwtcl} {0}
set_instance_parameter_value phy {l01_entry_latency_advanced_default_hwtcl} {31}
set_instance_parameter_value phy {l0_exit_latency_diffclock_advanced_default_hwtcl} {6}
set_instance_parameter_value phy {l0_exit_latency_sameclock_advanced_default_hwtcl} {6}
set_instance_parameter_value phy {l1_exit_latency_diffclock_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {l1_exit_latency_sameclock_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {l2_async_logic_advanced_default_hwtcl} {disable}
set_instance_parameter_value phy {lane_mask_hwtcl} {x8}
set_instance_parameter_value phy {low_priority_vc_advanced_default_hwtcl} {single_vc}
set_instance_parameter_value phy {max_payload_size_hwtcl} {256}
set_instance_parameter_value phy {msi_64bit_addressing_capable_hwtcl} {true}
set_instance_parameter_value phy {msi_masking_capable_hwtcl} {false}
set_instance_parameter_value phy {msi_multi_message_capable_hwtcl} {32}
set_instance_parameter_value phy {msi_support_hwtcl} {true}
set_instance_parameter_value phy {msix_pba_bir_hwtcl} {0}
set_instance_parameter_value phy {msix_pba_offset_hwtcl} {0.0}
set_instance_parameter_value phy {msix_table_bir_hwtcl} {0}
set_instance_parameter_value phy {msix_table_offset_hwtcl} {0.0}
set_instance_parameter_value phy {msix_table_size_hwtcl} {0}
set_instance_parameter_value phy {no_command_completed_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {no_soft_reset_advanced_default_hwtcl} {false}
set_instance_parameter_value phy {override_rxbuffer_cred_preset} {0}
set_instance_parameter_value phy {override_tbpartner_driver_setting_hwtcl} {0}
set_instance_parameter_value phy {pcie_inspector_hwtcl} {0}
set_instance_parameter_value phy {pcie_qsys} {1}
set_instance_parameter_value phy {pclk_out_sel_advanced_default_hwtcl} {pclk}
set_instance_parameter_value phy {pipex1_debug_sel_advanced_default_hwtcl} {disable}
set_instance_parameter_value phy {pll_refclk_freq_hwtcl} {100 MHz}
set_instance_parameter_value phy {port_link_number_hwtcl} {1}
set_instance_parameter_value phy {port_type_hwtcl} {Native endpoint}
set_instance_parameter_value phy {prefetchable_mem_window_addr_width_hwtcl} {0}
set_instance_parameter_value phy {register_pipe_signals_advanced_default_hwtcl} {true}
set_instance_parameter_value phy {reserved_debug_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {retry_buffer_last_active_address_advanced_default_hwtcl} {255}
set_instance_parameter_value phy {revision_id_hwtcl} {1}
set_instance_parameter_value phy {rpre_emph_a_val_hwtcl} {9}
set_instance_parameter_value phy {rpre_emph_b_val_hwtcl} {0}
set_instance_parameter_value phy {rpre_emph_c_val_hwtcl} {16}
set_instance_parameter_value phy {rpre_emph_d_val_hwtcl} {13}
set_instance_parameter_value phy {rpre_emph_e_val_hwtcl} {5}
set_instance_parameter_value phy {rvod_sel_a_val_hwtcl} {42}
set_instance_parameter_value phy {rvod_sel_b_val_hwtcl} {38}
set_instance_parameter_value phy {rvod_sel_c_val_hwtcl} {38}
set_instance_parameter_value phy {rvod_sel_d_val_hwtcl} {43}
set_instance_parameter_value phy {rvod_sel_e_val_hwtcl} {15}
set_instance_parameter_value phy {rx_cdc_almost_full_advanced_default_hwtcl} {12}
set_instance_parameter_value phy {rx_l0s_count_idl_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {rxbuffer_rxreq_hwtcl} {Low}
set_instance_parameter_value phy {sameclock_nfts_count_advanced_default_hwtcl} {255}
set_instance_parameter_value phy {serial_sim_hwtcl} {1}
set_instance_parameter_value phy {set_pld_clk_x1_625MHz_hwtcl} {0}
set_instance_parameter_value phy {set_pll_coreclkout_slack} {10}
set_instance_parameter_value phy {skp_os_schedule_count_advanced_default_hwtcl} {0}
set_instance_parameter_value phy {slot_number_hwtcl} {0}
set_instance_parameter_value phy {slot_power_limit_hwtcl} {0}
set_instance_parameter_value phy {slot_power_scale_hwtcl} {0}
set_instance_parameter_value phy {slotclkcfg_hwtcl} {1}
set_instance_parameter_value phy {subsystem_device_id_hwtcl} {3557}
set_instance_parameter_value phy {subsystem_vendor_id_hwtcl} {61888}
set_instance_parameter_value phy {surprise_down_error_support_hwtcl} {0}
set_instance_parameter_value phy {tlp_insp_trg_dw0_hwtcl} {2049}
set_instance_parameter_value phy {tlp_insp_trg_dw1_hwtcl} {0}
set_instance_parameter_value phy {tlp_insp_trg_dw2_hwtcl} {0}
set_instance_parameter_value phy {tlp_insp_trg_dw3_hwtcl} {0}
set_instance_parameter_value phy {tlp_inspector_hwtcl} {0}
set_instance_parameter_value phy {tlp_inspector_use_signal_probe_hwtcl} {0}
set_instance_parameter_value phy {tx_cdc_almost_empty_advanced_default_hwtcl} {5}
set_instance_parameter_value phy {tx_cdc_almost_full_advanced_default_hwtcl} {11}
set_instance_parameter_value phy {use_aer_hwtcl} {0}
set_instance_parameter_value phy {use_ast_parity} {0}
set_instance_parameter_value phy {use_atx_pll_hwtcl} {0}
set_instance_parameter_value phy {use_crc_forwarding_hwtcl} {0}
set_instance_parameter_value phy {use_cvp_update_core_pof_hwtcl} {0}
set_instance_parameter_value phy {use_rx_st_be_hwtcl} {0}
set_instance_parameter_value phy {use_tl_cfg_sync_advanced_default_hwtcl} {1}
set_instance_parameter_value phy {vc0_clk_enable_advanced_default_hwtcl} {true}
set_instance_parameter_value phy {vendor_id_hwtcl} {61888}
set_instance_parameter_value phy {vsec_id_hwtcl} {40960}
set_instance_parameter_value phy {vsec_rev_hwtcl} {0}

add_instance read_mem altera_avalon_onchip_memory2 19.1
set_instance_parameter_value read_mem {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value read_mem {blockType} {AUTO}
set_instance_parameter_value read_mem {copyInitFile} {0}
set_instance_parameter_value read_mem {dataWidth} {256}
set_instance_parameter_value read_mem {dataWidth2} {32}
set_instance_parameter_value read_mem {dualPort} {1}
set_instance_parameter_value read_mem {ecc_enabled} {0}
set_instance_parameter_value read_mem {enPRInitMode} {0}
set_instance_parameter_value read_mem {enableDiffWidth} {0}
set_instance_parameter_value read_mem {initMemContent} {0}
set_instance_parameter_value read_mem {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value read_mem {instanceID} {NONE}
set_instance_parameter_value read_mem {memorySize} {1048576.0}
set_instance_parameter_value read_mem {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value read_mem {resetrequest_enabled} {0}
set_instance_parameter_value read_mem {simAllowMRAMContentsFile} {0}
set_instance_parameter_value read_mem {simMemInitOnlyFilename} {0}
set_instance_parameter_value read_mem {singleClockOperation} {0}
set_instance_parameter_value read_mem {slave1Latency} {1}
set_instance_parameter_value read_mem {slave2Latency} {1}
set_instance_parameter_value read_mem {useNonDefaultInitFile} {0}
set_instance_parameter_value read_mem {useShallowMemBlocks} {0}
set_instance_parameter_value read_mem {writable} {1}

add_instance read_mem_cb altera_clock_bridge 19.1
set_instance_parameter_value read_mem_cb {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value read_mem_cb {NUM_CLOCK_OUTPUTS} {1}

add_instance read_s2_pipeline altera_avalon_mm_bridge 19.1
set_instance_parameter_value read_s2_pipeline {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value read_s2_pipeline {ADDRESS_WIDTH} {10}
set_instance_parameter_value read_s2_pipeline {DATA_WIDTH} {256}
set_instance_parameter_value read_s2_pipeline {LINEWRAPBURSTS} {0}
set_instance_parameter_value read_s2_pipeline {MAX_BURST_SIZE} {32}
set_instance_parameter_value read_s2_pipeline {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value read_s2_pipeline {PIPELINE_COMMAND} {1}
set_instance_parameter_value read_s2_pipeline {PIPELINE_RESPONSE} {1}
set_instance_parameter_value read_s2_pipeline {SYMBOL_WIDTH} {8}
set_instance_parameter_value read_s2_pipeline {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value read_s2_pipeline {USE_RESPONSE} {0}

add_instance write_mem altera_avalon_onchip_memory2 19.1
set_instance_parameter_value write_mem {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value write_mem {blockType} {AUTO}
set_instance_parameter_value write_mem {copyInitFile} {0}
set_instance_parameter_value write_mem {dataWidth} {256}
set_instance_parameter_value write_mem {dataWidth2} {32}
set_instance_parameter_value write_mem {dualPort} {1}
set_instance_parameter_value write_mem {ecc_enabled} {0}
set_instance_parameter_value write_mem {enPRInitMode} {0}
set_instance_parameter_value write_mem {enableDiffWidth} {0}
set_instance_parameter_value write_mem {initMemContent} {0}
set_instance_parameter_value write_mem {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value write_mem {instanceID} {NONE}
set_instance_parameter_value write_mem {memorySize} {1048576.0}
set_instance_parameter_value write_mem {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value write_mem {resetrequest_enabled} {0}
set_instance_parameter_value write_mem {simAllowMRAMContentsFile} {0}
set_instance_parameter_value write_mem {simMemInitOnlyFilename} {0}
set_instance_parameter_value write_mem {singleClockOperation} {0}
set_instance_parameter_value write_mem {slave1Latency} {1}
set_instance_parameter_value write_mem {slave2Latency} {1}
set_instance_parameter_value write_mem {useNonDefaultInitFile} {0}
set_instance_parameter_value write_mem {useShallowMemBlocks} {0}
set_instance_parameter_value write_mem {writable} {1}

add_instance write_mem_cb altera_clock_bridge 19.1
set_instance_parameter_value write_mem_cb {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value write_mem_cb {NUM_CLOCK_OUTPUTS} {1}

add_instance write_s2_pipeline altera_avalon_mm_bridge 19.1
set_instance_parameter_value write_s2_pipeline {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value write_s2_pipeline {ADDRESS_WIDTH} {10}
set_instance_parameter_value write_s2_pipeline {DATA_WIDTH} {256}
set_instance_parameter_value write_s2_pipeline {LINEWRAPBURSTS} {0}
set_instance_parameter_value write_s2_pipeline {MAX_BURST_SIZE} {32}
set_instance_parameter_value write_s2_pipeline {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value write_s2_pipeline {PIPELINE_COMMAND} {1}
set_instance_parameter_value write_s2_pipeline {PIPELINE_RESPONSE} {1}
set_instance_parameter_value write_s2_pipeline {SYMBOL_WIDTH} {8}
set_instance_parameter_value write_s2_pipeline {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value write_s2_pipeline {USE_RESPONSE} {0}

# exported interfaces
add_interface bar2_clk clock sink
set_interface_property bar2_clk EXPORT_OF bar2_cdc.m0_clk
add_interface bar2_mm avalon master
set_interface_property bar2_mm EXPORT_OF bar2_cdc.m0
add_interface bar2_reset reset sink
set_interface_property bar2_reset EXPORT_OF bar2_cdc.m0_reset
add_interface mgmt_clk clock sink
set_interface_property mgmt_clk EXPORT_OF mgmt_clk.in_clk
add_interface mgmt_rst reset sink
set_interface_property mgmt_rst EXPORT_OF mgmt_rst.in_reset
add_interface pcie_refclk clock sink
set_interface_property pcie_refclk EXPORT_OF phy.refclk
add_interface pcie_reset_pin conduit end
set_interface_property pcie_reset_pin EXPORT_OF pcie_reset.pin
add_interface phy_serial conduit end
set_interface_property phy_serial EXPORT_OF phy.hip_serial
add_interface read_mem_clk clock sink
set_interface_property read_mem_clk EXPORT_OF read_mem_cb.in_clk
add_interface read_mem_mm avalon slave
set_interface_property read_mem_mm EXPORT_OF read_s2_pipeline.s0
add_interface write_mem_clk clock sink
set_interface_property write_mem_clk EXPORT_OF write_mem_cb.in_clk
add_interface write_mem_mm avalon slave
set_interface_property write_mem_mm EXPORT_OF write_s2_pipeline.s0

# connections and connection parameters
add_connection alt_xcvr_reconfig_0.reconfig_to_xcvr phy.reconfig_to_xcvr
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/phy.reconfig_to_xcvr endPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/phy.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/phy.reconfig_to_xcvr startPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/phy.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/phy.reconfig_to_xcvr width {0}

add_connection dma_rd_pipeline.m0 read_mem.s1
set_connection_parameter_value dma_rd_pipeline.m0/read_mem.s1 arbitrationPriority {1}
set_connection_parameter_value dma_rd_pipeline.m0/read_mem.s1 baseAddress {0x00800000}
set_connection_parameter_value dma_rd_pipeline.m0/read_mem.s1 defaultConnection {0}

add_connection dma_wr_pipeline.m0 write_mem.s1
set_connection_parameter_value dma_wr_pipeline.m0/write_mem.s1 arbitrationPriority {1}
set_connection_parameter_value dma_wr_pipeline.m0/write_mem.s1 baseAddress {0x00c00000}
set_connection_parameter_value dma_wr_pipeline.m0/write_mem.s1 defaultConnection {0}

add_connection mgmt_clk.out_clk alt_xcvr_reconfig_0.mgmt_clk_clk

add_connection mgmt_clk.out_clk mgmt_rst.clk

add_connection mgmt_clk.out_clk pcie_reconfig_driver_0.reconfig_xcvr_clk

add_connection mgmt_clk.out_clk pcie_reset.clk

add_connection mgmt_rst.out_reset alt_xcvr_reconfig_0.mgmt_rst_reset

add_connection mgmt_rst.out_reset dma_descr.reset2

add_connection mgmt_rst.out_reset pcie_reconfig_driver_0.reconfig_xcvr_rst

add_connection mgmt_rst.out_reset pcie_reset.reset

add_connection mgmt_rst.out_reset read_mem.reset1

add_connection mgmt_rst.out_reset read_mem.reset2

add_connection mgmt_rst.out_reset read_s2_pipeline.reset

add_connection mgmt_rst.out_reset write_mem.reset1

add_connection mgmt_rst.out_reset write_mem.reset2

add_connection mgmt_rst.out_reset write_s2_pipeline.reset

add_connection pcie_reconfig_driver_0.reconfig_busy alt_xcvr_reconfig_0.reconfig_busy
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy endPort {}
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy endPortLSB {0}
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy startPort {}
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy startPortLSB {0}
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy width {0}

add_connection pcie_reconfig_driver_0.reconfig_mgmt alt_xcvr_reconfig_0.reconfig_mgmt
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt arbitrationPriority {1}
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt baseAddress {0x0000}
set_connection_parameter_value pcie_reconfig_driver_0.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt defaultConnection {0}

add_connection pcie_reset.npor phy.npor
set_connection_parameter_value pcie_reset.npor/phy.npor endPort {}
set_connection_parameter_value pcie_reset.npor/phy.npor endPortLSB {0}
set_connection_parameter_value pcie_reset.npor/phy.npor startPort {}
set_connection_parameter_value pcie_reset.npor/phy.npor startPortLSB {0}
set_connection_parameter_value pcie_reset.npor/phy.npor width {0}

add_connection phy.Rxm_BAR2 bar2_cdc.s0
set_connection_parameter_value phy.Rxm_BAR2/bar2_cdc.s0 arbitrationPriority {1}
set_connection_parameter_value phy.Rxm_BAR2/bar2_cdc.s0 baseAddress {0x0000}
set_connection_parameter_value phy.Rxm_BAR2/bar2_cdc.s0 defaultConnection {0}

add_connection phy.Rxm_BAR3 dma_descr.s2
set_connection_parameter_value phy.Rxm_BAR3/dma_descr.s2 arbitrationPriority {1}
set_connection_parameter_value phy.Rxm_BAR3/dma_descr.s2 baseAddress {0x0f000000}
set_connection_parameter_value phy.Rxm_BAR3/dma_descr.s2 defaultConnection {0}

add_connection phy.coreclkout bar2_cdc.s0_clk

add_connection phy.coreclkout dma_descr.clk1

add_connection phy.coreclkout dma_descr.clk2

add_connection phy.coreclkout dma_rd_pipeline.clk

add_connection phy.coreclkout dma_wr_pipeline.clk

add_connection phy.coreclkout pcie_reconfig_driver_0.pld_clk

add_connection phy.coreclkout read_mem.clk1

add_connection phy.coreclkout write_mem.clk1

add_connection phy.dma_rd_master dma_descr.s2
set_connection_parameter_value phy.dma_rd_master/dma_descr.s2 arbitrationPriority {1}
set_connection_parameter_value phy.dma_rd_master/dma_descr.s2 baseAddress {0x0f000000}
set_connection_parameter_value phy.dma_rd_master/dma_descr.s2 defaultConnection {0}

add_connection phy.dma_rd_master dma_rd_pipeline.s0
set_connection_parameter_value phy.dma_rd_master/dma_rd_pipeline.s0 arbitrationPriority {1}
set_connection_parameter_value phy.dma_rd_master/dma_rd_pipeline.s0 baseAddress {0x0000}
set_connection_parameter_value phy.dma_rd_master/dma_rd_pipeline.s0 defaultConnection {0}

add_connection phy.dma_rd_master phy.rd_dts_slave
set_connection_parameter_value phy.dma_rd_master/phy.rd_dts_slave arbitrationPriority {1}
set_connection_parameter_value phy.dma_rd_master/phy.rd_dts_slave baseAddress {0x01002000}
set_connection_parameter_value phy.dma_rd_master/phy.rd_dts_slave defaultConnection {0}

add_connection phy.dma_rd_master phy.wr_dts_slave
set_connection_parameter_value phy.dma_rd_master/phy.wr_dts_slave arbitrationPriority {1}
set_connection_parameter_value phy.dma_rd_master/phy.wr_dts_slave baseAddress {0x01000000}
set_connection_parameter_value phy.dma_rd_master/phy.wr_dts_slave defaultConnection {0}

add_connection phy.dma_wr_master dma_descr.s1
set_connection_parameter_value phy.dma_wr_master/dma_descr.s1 arbitrationPriority {1}
set_connection_parameter_value phy.dma_wr_master/dma_descr.s1 baseAddress {0x0f000000}
set_connection_parameter_value phy.dma_wr_master/dma_descr.s1 defaultConnection {0}

add_connection phy.dma_wr_master dma_wr_pipeline.s0
set_connection_parameter_value phy.dma_wr_master/dma_wr_pipeline.s0 arbitrationPriority {1}
set_connection_parameter_value phy.dma_wr_master/dma_wr_pipeline.s0 baseAddress {0x0000}
set_connection_parameter_value phy.dma_wr_master/dma_wr_pipeline.s0 defaultConnection {0}

add_connection phy.hip_currentspeed pcie_reconfig_driver_0.hip_currentspeed
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed endPort {}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed endPortLSB {0}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed startPort {}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed startPortLSB {0}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed width {0}

add_connection phy.hip_status pcie_reconfig_driver_0.hip_status_drv
set_connection_parameter_value phy.hip_status/pcie_reconfig_driver_0.hip_status_drv endPort {}
set_connection_parameter_value phy.hip_status/pcie_reconfig_driver_0.hip_status_drv endPortLSB {0}
set_connection_parameter_value phy.hip_status/pcie_reconfig_driver_0.hip_status_drv startPort {}
set_connection_parameter_value phy.hip_status/pcie_reconfig_driver_0.hip_status_drv startPortLSB {0}
set_connection_parameter_value phy.hip_status/pcie_reconfig_driver_0.hip_status_drv width {0}

add_connection phy.nreset_status bar2_cdc.s0_reset

add_connection phy.nreset_status dma_descr.reset1

add_connection phy.nreset_status dma_rd_pipeline.reset

add_connection phy.nreset_status dma_wr_pipeline.reset

add_connection phy.rd_dcm_master phy.Txs
set_connection_parameter_value phy.rd_dcm_master/phy.Txs arbitrationPriority {1}
set_connection_parameter_value phy.rd_dcm_master/phy.Txs baseAddress {0x0000}
set_connection_parameter_value phy.rd_dcm_master/phy.Txs defaultConnection {0}

add_connection phy.reconfig_from_xcvr alt_xcvr_reconfig_0.reconfig_from_xcvr
set_connection_parameter_value phy.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPort {}
set_connection_parameter_value phy.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value phy.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPort {}
set_connection_parameter_value phy.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value phy.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr width {0}

add_connection phy.wr_dcm_master phy.Txs
set_connection_parameter_value phy.wr_dcm_master/phy.Txs arbitrationPriority {1}
set_connection_parameter_value phy.wr_dcm_master/phy.Txs baseAddress {0x0000}
set_connection_parameter_value phy.wr_dcm_master/phy.Txs defaultConnection {0}

add_connection read_mem_cb.out_clk read_mem.clk2

add_connection read_mem_cb.out_clk read_s2_pipeline.clk

add_connection read_s2_pipeline.m0 read_mem.s2
set_connection_parameter_value read_s2_pipeline.m0/read_mem.s2 arbitrationPriority {1}
set_connection_parameter_value read_s2_pipeline.m0/read_mem.s2 baseAddress {0x0000}
set_connection_parameter_value read_s2_pipeline.m0/read_mem.s2 defaultConnection {0}

add_connection write_mem_cb.out_clk write_mem.clk2

add_connection write_mem_cb.out_clk write_s2_pipeline.clk

add_connection write_s2_pipeline.m0 write_mem.s2
set_connection_parameter_value write_s2_pipeline.m0/write_mem.s2 arbitrationPriority {1}
set_connection_parameter_value write_s2_pipeline.m0/write_mem.s2 baseAddress {0x0000}
set_connection_parameter_value write_s2_pipeline.m0/write_mem.s2 defaultConnection {0}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon_pcie.qsys}
