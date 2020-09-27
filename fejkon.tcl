# qsys scripting (.tcl) file for fejkon
package require -exact qsys 16.0

create_system {fejkon}

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

add_instance bar0_cdc altera_avalon_mm_clock_crossing_bridge 20.1
set_instance_parameter_value bar0_cdc {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value bar0_cdc {ADDRESS_WIDTH} {16}
set_instance_parameter_value bar0_cdc {COMMAND_FIFO_DEPTH} {4}
set_instance_parameter_value bar0_cdc {DATA_WIDTH} {32}
set_instance_parameter_value bar0_cdc {MASTER_SYNC_DEPTH} {2}
set_instance_parameter_value bar0_cdc {MAX_BURST_SIZE} {1}
set_instance_parameter_value bar0_cdc {RESPONSE_FIFO_DEPTH} {4}
set_instance_parameter_value bar0_cdc {SLAVE_SYNC_DEPTH} {2}
set_instance_parameter_value bar0_cdc {SYMBOL_WIDTH} {8}
set_instance_parameter_value bar0_cdc {USE_AUTO_ADDRESS_WIDTH} {0}

add_instance datapath fejkon_datapath 1.0
set_instance_parameter_value datapath {LOOPBACK_01} {false}

add_instance ext0 clock_source 20.1
set_instance_parameter_value ext0 {clockFrequency} {50000000.0}
set_instance_parameter_value ext0 {clockFrequencyKnown} {1}
set_instance_parameter_value ext0 {resetSynchronousEdges} {NONE}

add_instance ident fejkon_identity 1.0
set_instance_parameter_value ident {EthPorts} {2}
set_instance_parameter_value ident {FcPorts} {2}

add_instance jtagm altera_jtag_avalon_master 20.1
set_instance_parameter_value jtagm {FAST_VER} {0}
set_instance_parameter_value jtagm {FIFO_DEPTHS} {2}
set_instance_parameter_value jtagm {PLI_PORT} {50000}
set_instance_parameter_value jtagm {USE_PLI} {0}

add_instance led fejkon_led 1.0

add_instance msi_intr pcie_msi_intr 1.0

add_instance pcie_clk_gauge freq_gauge 1.0

add_instance pcie_phy altera_pcie_sv_hip_ast 20.1
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_atomic_malformed} {true}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_atomic_op_completer_32bit} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_atomic_op_completer_64bit} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_atomic_op_routing} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_bridge_port_ssid_support} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_bridge_port_vga_enable} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_bypass_cdc} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_cas_completer_128bit} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_cdc_dummy_insert_limit} {11}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_d0_pme} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_d1_pme} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_d1_support} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_d2_pme} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_d2_support} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_d3_cold_pme} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_d3_hot_pme} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_data_pack_rx} {disable}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_deskew_comma} {com_deskw}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_device_number} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_disable_link_x2_support} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_disable_snoop_packet} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_ei_delay_powerdown_count} {10}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_eie_before_nfts_count} {4}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_enable_adapter_half_rate_mode} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_enable_l1_aspm} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_enable_rx_buffer_checking} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_extended_format_field} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_extended_tag_reset} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_fc_init_timer} {1024}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_flow_control_timeout_count} {200}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_flow_control_update_count} {30}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_flr_capability} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_gen2_diffclock_nfts_count} {255}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_gen2_sameclock_nfts_count} {255}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_hot_plug_support} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_interrupt_pin} {inta}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_l01_entry_latency} {31}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_l0_exit_latency_diffclock} {6}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_l0_exit_latency_sameclock} {6}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_l1_exit_latency_diffclock} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_l1_exit_latency_sameclock} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_low_priority_vc} {single_vc}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_ltr_mechanism} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_ltssm_1ms_timeout} {disable}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_ltssm_freqlocked_check} {disable}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_maximum_current} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_no_command_completed} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_no_soft_reset} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_pclk_out_sel} {pclk}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_pipex1_debug_sel} {disable}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_register_pipe_signals} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_reserved_debug} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_retry_buffer_last_active_address} {2047}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_rx_l0s_count_idl} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_set_l0s} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_skp_os_gen3_count} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_skp_os_schedule_count} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_ssid} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_ssvid} {0}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_tph_completer} {false}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_tx_cdc_almost_empty} {5}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_vc0_clk_enable} {true}
set_instance_parameter_value pcie_phy {advanced_default_hwtcl_wrong_device_id} {disable}
set_instance_parameter_value pcie_phy {advanced_default_parameter_override} {0}
set_instance_parameter_value pcie_phy {ast_width_hwtcl} {Avalon-ST 256-bit}
set_instance_parameter_value pcie_phy {bar0_size_mask_hwtcl} {16}
set_instance_parameter_value pcie_phy {bar0_type_hwtcl} {2}
set_instance_parameter_value pcie_phy {bar1_size_mask_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar1_type_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar2_size_mask_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar2_type_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar3_size_mask_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar3_type_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar4_size_mask_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar4_type_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar5_size_mask_hwtcl} {0}
set_instance_parameter_value pcie_phy {bar5_type_hwtcl} {0}
set_instance_parameter_value pcie_phy {change_deemphasis_hwtcl} {1}
set_instance_parameter_value pcie_phy {class_code_hwtcl} {787456}
set_instance_parameter_value pcie_phy {completion_timeout_hwtcl} {A}
set_instance_parameter_value pcie_phy {device_id_hwtcl} {3557}
set_instance_parameter_value pcie_phy {dll_active_report_support_hwtcl} {0}
set_instance_parameter_value pcie_phy {ecrc_check_capable_hwtcl} {1}
set_instance_parameter_value pcie_phy {ecrc_gen_capable_hwtcl} {1}
set_instance_parameter_value pcie_phy {enable_completion_timeout_disable_hwtcl} {1}
set_instance_parameter_value pcie_phy {enable_function_msix_support_hwtcl} {0}
set_instance_parameter_value pcie_phy {enable_pcisigtest_hwtcl} {0}
set_instance_parameter_value pcie_phy {enable_pipe32_phyip_ser_driver_hwtcl} {0}
set_instance_parameter_value pcie_phy {enable_pipe32_sim_hwtcl} {0}
set_instance_parameter_value pcie_phy {enable_power_on_rst_pulse_hwtcl} {1}
set_instance_parameter_value pcie_phy {enable_slot_register_hwtcl} {0}
set_instance_parameter_value pcie_phy {enable_tl_only_sim_hwtcl} {0}
set_instance_parameter_value pcie_phy {endpoint_l0_latency_hwtcl} {0}
set_instance_parameter_value pcie_phy {endpoint_l1_latency_hwtcl} {0}
set_instance_parameter_value pcie_phy {expansion_base_address_register_hwtcl} {0}
set_instance_parameter_value pcie_phy {extend_tag_field_hwtcl} {64}
set_instance_parameter_value pcie_phy {fixed_preset_on} {0}
set_instance_parameter_value pcie_phy {force_hrc} {0}
set_instance_parameter_value pcie_phy {force_src} {0}
set_instance_parameter_value pcie_phy {full_swing_hwtcl} {35}
set_instance_parameter_value pcie_phy {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value pcie_phy {gen3_coeff_10_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_10_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_10_nxtber_less_hwtcl} {g3_coeff_10_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_10_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_10_nxtber_more_hwtcl} {g3_coeff_10_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_10_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_10_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_10_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_10_sel_hwtcl} {preset_10}
set_instance_parameter_value pcie_phy {gen3_coeff_11_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_11_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_11_nxtber_less_hwtcl} {g3_coeff_11_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_11_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_11_nxtber_more_hwtcl} {g3_coeff_11_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_11_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_11_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_11_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_11_sel_hwtcl} {preset_11}
set_instance_parameter_value pcie_phy {gen3_coeff_12_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_12_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_12_nxtber_less_hwtcl} {g3_coeff_12_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_12_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_12_nxtber_more_hwtcl} {g3_coeff_12_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_12_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_12_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_12_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_12_sel_hwtcl} {preset_12}
set_instance_parameter_value pcie_phy {gen3_coeff_13_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_13_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_13_nxtber_less_hwtcl} {g3_coeff_13_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_13_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_13_nxtber_more_hwtcl} {g3_coeff_13_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_13_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_13_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_13_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_13_sel_hwtcl} {preset_13}
set_instance_parameter_value pcie_phy {gen3_coeff_14_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_14_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_14_nxtber_less_hwtcl} {g3_coeff_14_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_14_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_14_nxtber_more_hwtcl} {g3_coeff_14_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_14_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_14_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_14_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_14_sel_hwtcl} {preset_14}
set_instance_parameter_value pcie_phy {gen3_coeff_15_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_15_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_15_nxtber_less_hwtcl} {g3_coeff_15_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_15_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_15_nxtber_more_hwtcl} {g3_coeff_15_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_15_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_15_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_15_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_15_sel_hwtcl} {preset_15}
set_instance_parameter_value pcie_phy {gen3_coeff_16_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_16_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_16_nxtber_less_hwtcl} {g3_coeff_16_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_16_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_16_nxtber_more_hwtcl} {g3_coeff_16_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_16_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_16_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_16_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_16_sel_hwtcl} {preset_16}
set_instance_parameter_value pcie_phy {gen3_coeff_17_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_17_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_17_nxtber_less_hwtcl} {g3_coeff_17_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_17_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_17_nxtber_more_hwtcl} {g3_coeff_17_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_17_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_17_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_17_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_17_sel_hwtcl} {preset_17}
set_instance_parameter_value pcie_phy {gen3_coeff_18_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_18_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_18_nxtber_less_hwtcl} {g3_coeff_18_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_18_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_18_nxtber_more_hwtcl} {g3_coeff_18_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_18_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_18_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_18_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_18_sel_hwtcl} {preset_18}
set_instance_parameter_value pcie_phy {gen3_coeff_19_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_19_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_19_nxtber_less_hwtcl} {g3_coeff_19_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_19_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_19_nxtber_more_hwtcl} {g3_coeff_19_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_19_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_19_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_19_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_19_sel_hwtcl} {preset_19}
set_instance_parameter_value pcie_phy {gen3_coeff_1_ber_meas_hwtcl} {2}
set_instance_parameter_value pcie_phy {gen3_coeff_1_hwtcl} {7}
set_instance_parameter_value pcie_phy {gen3_coeff_1_nxtber_less_hwtcl} {g3_coeff_1_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_1_nxtber_less_ptr_hwtcl} {1}
set_instance_parameter_value pcie_phy {gen3_coeff_1_nxtber_more_hwtcl} {g3_coeff_1_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_1_nxtber_more_ptr_hwtcl} {1}
set_instance_parameter_value pcie_phy {gen3_coeff_1_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_1_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_1_sel_hwtcl} {preset_1}
set_instance_parameter_value pcie_phy {gen3_coeff_20_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_20_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_20_nxtber_less_hwtcl} {g3_coeff_20_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_20_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_20_nxtber_more_hwtcl} {g3_coeff_20_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_20_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_20_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_20_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_20_sel_hwtcl} {preset_20}
set_instance_parameter_value pcie_phy {gen3_coeff_21_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_21_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_21_nxtber_less_hwtcl} {g3_coeff_21_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_21_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_21_nxtber_more_hwtcl} {g3_coeff_21_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_21_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_21_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_21_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_21_sel_hwtcl} {preset_21}
set_instance_parameter_value pcie_phy {gen3_coeff_22_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_22_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_22_nxtber_less_hwtcl} {g3_coeff_22_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_22_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_22_nxtber_more_hwtcl} {g3_coeff_22_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_22_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_22_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_22_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_22_sel_hwtcl} {preset_22}
set_instance_parameter_value pcie_phy {gen3_coeff_23_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_23_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_23_nxtber_less_hwtcl} {g3_coeff_23_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_23_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_23_nxtber_more_hwtcl} {g3_coeff_23_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_23_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_23_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_23_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_23_sel_hwtcl} {preset_23}
set_instance_parameter_value pcie_phy {gen3_coeff_24_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_24_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_24_nxtber_less_hwtcl} {g3_coeff_24_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_24_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_24_nxtber_more_hwtcl} {g3_coeff_24_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_24_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_24_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_24_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_24_sel_hwtcl} {preset_24}
set_instance_parameter_value pcie_phy {gen3_coeff_2_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_2_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_2_nxtber_less_hwtcl} {g3_coeff_2_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_2_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_2_nxtber_more_hwtcl} {g3_coeff_2_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_2_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_2_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_2_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_2_sel_hwtcl} {preset_2}
set_instance_parameter_value pcie_phy {gen3_coeff_3_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_3_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_3_nxtber_less_hwtcl} {g3_coeff_3_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_3_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_3_nxtber_more_hwtcl} {g3_coeff_3_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_3_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_3_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_3_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_3_sel_hwtcl} {preset_3}
set_instance_parameter_value pcie_phy {gen3_coeff_4_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_4_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_4_nxtber_less_hwtcl} {g3_coeff_4_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_4_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_4_nxtber_more_hwtcl} {g3_coeff_4_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_4_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_4_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_4_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_4_sel_hwtcl} {preset_4}
set_instance_parameter_value pcie_phy {gen3_coeff_5_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_5_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_5_nxtber_less_hwtcl} {g3_coeff_5_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_5_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_5_nxtber_more_hwtcl} {g3_coeff_5_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_5_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_5_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_5_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_5_sel_hwtcl} {preset_5}
set_instance_parameter_value pcie_phy {gen3_coeff_6_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_6_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_6_nxtber_less_hwtcl} {g3_coeff_6_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_6_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_6_nxtber_more_hwtcl} {g3_coeff_6_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_6_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_6_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_6_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_6_sel_hwtcl} {preset_6}
set_instance_parameter_value pcie_phy {gen3_coeff_7_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_7_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_7_nxtber_less_hwtcl} {g3_coeff_7_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_7_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_7_nxtber_more_hwtcl} {g3_coeff_7_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_7_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_7_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_7_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_7_sel_hwtcl} {preset_7}
set_instance_parameter_value pcie_phy {gen3_coeff_8_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_8_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_8_nxtber_less_hwtcl} {g3_coeff_8_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_8_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_8_nxtber_more_hwtcl} {g3_coeff_8_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_8_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_8_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_8_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_8_sel_hwtcl} {preset_8}
set_instance_parameter_value pcie_phy {gen3_coeff_9_ber_meas_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_9_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_9_nxtber_less_hwtcl} {g3_coeff_9_nxtber_less}
set_instance_parameter_value pcie_phy {gen3_coeff_9_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_9_nxtber_more_hwtcl} {g3_coeff_9_nxtber_more}
set_instance_parameter_value pcie_phy {gen3_coeff_9_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_9_preset_hint_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_9_reqber_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_coeff_9_sel_hwtcl} {preset_9}
set_instance_parameter_value pcie_phy {gen3_full_swing_hwtcl} {35}
set_instance_parameter_value pcie_phy {gen3_low_freq_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_10_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_11_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_1_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_2_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_3_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_4_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_5_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_6_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_7_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_8_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_preset_coeff_9_hwtcl} {0}
set_instance_parameter_value pcie_phy {gen3_rxfreqlock_counter_hwtcl} {0}
set_instance_parameter_value pcie_phy {hip_reconfig_hwtcl} {0}
set_instance_parameter_value pcie_phy {hip_tag_checking_hwtcl} {1}
set_instance_parameter_value pcie_phy {hwtcl_override_g2_txvod} {1}
set_instance_parameter_value pcie_phy {hwtcl_override_g3rxcoef} {0}
set_instance_parameter_value pcie_phy {hwtcl_override_g3txcoef} {0}
set_instance_parameter_value pcie_phy {in_cvp_mode_hwtcl} {0}
set_instance_parameter_value pcie_phy {io_window_addr_width_hwtcl} {0}
set_instance_parameter_value pcie_phy {lane_mask_hwtcl} {x8}
set_instance_parameter_value pcie_phy {low_latency_mode_hwtcl} {0}
set_instance_parameter_value pcie_phy {max_payload_size_hwtcl} {512}
set_instance_parameter_value pcie_phy {msi_64bit_addressing_capable_hwtcl} {true}
set_instance_parameter_value pcie_phy {msi_masking_capable_hwtcl} {false}
set_instance_parameter_value pcie_phy {msi_multi_message_capable_hwtcl} {32}
set_instance_parameter_value pcie_phy {msi_support_hwtcl} {true}
set_instance_parameter_value pcie_phy {msix_pba_bir_hwtcl} {0}
set_instance_parameter_value pcie_phy {msix_pba_offset_hwtcl} {0.0}
set_instance_parameter_value pcie_phy {msix_table_bir_hwtcl} {0}
set_instance_parameter_value pcie_phy {msix_table_offset_hwtcl} {0.0}
set_instance_parameter_value pcie_phy {msix_table_size_hwtcl} {0}
set_instance_parameter_value pcie_phy {multiple_packets_per_cycle_hwtcl} {0}
set_instance_parameter_value pcie_phy {override_rxbuffer_cred_preset} {0}
set_instance_parameter_value pcie_phy {override_tbpartner_driver_setting_hwtcl} {0}
set_instance_parameter_value pcie_phy {pcie_inspector_hwtcl} {0}
set_instance_parameter_value pcie_phy {pcie_qsys} {1}
set_instance_parameter_value pcie_phy {pcie_spec_version_hwtcl} {3.0}
set_instance_parameter_value pcie_phy {pll_refclk_freq_hwtcl} {100 MHz}
set_instance_parameter_value pcie_phy {port_link_number_hwtcl} {1}
set_instance_parameter_value pcie_phy {port_type_hwtcl} {Native endpoint}
set_instance_parameter_value pcie_phy {prefetchable_mem_window_addr_width_hwtcl} {0}
set_instance_parameter_value pcie_phy {revision_id_hwtcl} {1}
set_instance_parameter_value pcie_phy {rpre_emph_a_val_hwtcl} {9}
set_instance_parameter_value pcie_phy {rpre_emph_b_val_hwtcl} {0}
set_instance_parameter_value pcie_phy {rpre_emph_c_val_hwtcl} {16}
set_instance_parameter_value pcie_phy {rpre_emph_d_val_hwtcl} {13}
set_instance_parameter_value pcie_phy {rpre_emph_e_val_hwtcl} {5}
set_instance_parameter_value pcie_phy {rvod_sel_a_val_hwtcl} {42}
set_instance_parameter_value pcie_phy {rvod_sel_b_val_hwtcl} {38}
set_instance_parameter_value pcie_phy {rvod_sel_c_val_hwtcl} {38}
set_instance_parameter_value pcie_phy {rvod_sel_d_val_hwtcl} {43}
set_instance_parameter_value pcie_phy {rvod_sel_e_val_hwtcl} {15}
set_instance_parameter_value pcie_phy {rxbuffer_rxreq_hwtcl} {Balanced}
set_instance_parameter_value pcie_phy {serial_sim_hwtcl} {1}
set_instance_parameter_value pcie_phy {set_pld_clk_x1_625MHz_hwtcl} {0}
set_instance_parameter_value pcie_phy {slot_number_hwtcl} {0}
set_instance_parameter_value pcie_phy {slot_power_limit_hwtcl} {0}
set_instance_parameter_value pcie_phy {slot_power_scale_hwtcl} {0}
set_instance_parameter_value pcie_phy {slotclkcfg_hwtcl} {1}
set_instance_parameter_value pcie_phy {subsystem_device_id_hwtcl} {3557}
set_instance_parameter_value pcie_phy {subsystem_vendor_id_hwtcl} {61888}
set_instance_parameter_value pcie_phy {surprise_down_error_support_hwtcl} {0}
set_instance_parameter_value pcie_phy {tlp_insp_trg_dw0_hwtcl} {2049}
set_instance_parameter_value pcie_phy {tlp_insp_trg_dw1_hwtcl} {0}
set_instance_parameter_value pcie_phy {tlp_insp_trg_dw2_hwtcl} {0}
set_instance_parameter_value pcie_phy {tlp_insp_trg_dw3_hwtcl} {0}
set_instance_parameter_value pcie_phy {tlp_inspector_hwtcl} {0}
set_instance_parameter_value pcie_phy {tlp_inspector_use_signal_probe_hwtcl} {0}
set_instance_parameter_value pcie_phy {track_rxfc_cplbuf_ovf_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_aer_hwtcl} {1}
set_instance_parameter_value pcie_phy {use_ast_parity} {0}
set_instance_parameter_value pcie_phy {use_atx_pll_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_config_bypass_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_crc_forwarding_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_cvp_update_core_pof_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_pci_ext_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_pcie_ext_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_rx_st_be_hwtcl} {0}
set_instance_parameter_value pcie_phy {use_tx_cons_cred_sel_hwtcl} {1}
set_instance_parameter_value pcie_phy {user_id_hwtcl} {0}
set_instance_parameter_value pcie_phy {vendor_id_hwtcl} {61888}
set_instance_parameter_value pcie_phy {vsec_id_hwtcl} {4466}
set_instance_parameter_value pcie_phy {vsec_rev_hwtcl} {0}

add_instance pcie_reconfig altera_pcie_reconfig_driver 20.1
set_instance_parameter_value pcie_reconfig {enable_cal_busy_hwtcl} {0}
set_instance_parameter_value pcie_reconfig {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value pcie_reconfig {number_of_reconfig_interfaces} {11}

add_instance pcie_reset pcie_reset 1.0

add_instance pcie_status intel_pcie_status 1.0

add_instance phy_clk altera_clock_bridge 20.1
set_instance_parameter_value phy_clk {EXPLICIT_CLOCK_RATE} {106250000.0}
set_instance_parameter_value phy_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance phy_clk_gauge freq_gauge 1.0

add_instance phy_clk_out altera_clock_bridge 20.1
set_instance_parameter_value phy_clk_out {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value phy_clk_out {NUM_CLOCK_OUTPUTS} {1}

add_instance reset_ctrl altera_reset_controller 20.1
set_instance_parameter_value reset_ctrl {MIN_RST_ASSERTION_TIME} {3}
set_instance_parameter_value reset_ctrl {NUM_RESET_INPUTS} {3}
set_instance_parameter_value reset_ctrl {OUTPUT_RESET_SYNC_EDGES} {deassert}
set_instance_parameter_value reset_ctrl {RESET_REQUEST_PRESENT} {0}
set_instance_parameter_value reset_ctrl {RESET_REQ_EARLY_DSRT_TIME} {1}
set_instance_parameter_value reset_ctrl {RESET_REQ_WAIT_TIME} {1}
set_instance_parameter_value reset_ctrl {SYNC_DEPTH} {2}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN0} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN1} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN10} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN11} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN12} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN13} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN14} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN15} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN2} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN3} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN4} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN5} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN6} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN7} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN8} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_IN9} {0}
set_instance_parameter_value reset_ctrl {USE_RESET_REQUEST_INPUT} {0}

add_instance reset_seqencer altera_reset_sequencer 20.1
set_instance_parameter_value reset_seqencer {ENABLE_CSR} {0}
set_instance_parameter_value reset_seqencer {ENABLE_RESET_REQUEST_INPUT} {0}
set_instance_parameter_value reset_seqencer {LIST_ASRT_DELAY} {0 0 0 0 0 0 0 0 0 0}
set_instance_parameter_value reset_seqencer {LIST_ASRT_SEQ} {0 1 2 3 4 5 6 7 8 9}
set_instance_parameter_value reset_seqencer {LIST_DSRT_DELAY} {0 0 0 0 0 0 0 0 0 0}
set_instance_parameter_value reset_seqencer {LIST_DSRT_SEQ} {0 1 2 3 4 5 6 7 8 9}
set_instance_parameter_value reset_seqencer {MIN_ASRT_TIME} {0}
set_instance_parameter_value reset_seqencer {NUM_INPUTS} {1}
set_instance_parameter_value reset_seqencer {NUM_OUTPUTS} {4}
set_instance_parameter_value reset_seqencer {USE_DSRT_QUAL} {0 0 0 0 0 0 0 0 0 0}

add_instance sfp0 fejkon_sfp 1.0

add_instance sfp1 fejkon_sfp 1.0

add_instance sfp2 fejkon_sfp 1.0

add_instance sfp3 fejkon_sfp 1.0

add_instance si570_ctrl si570_ctrl 1.0
set_instance_parameter_value si570_ctrl {I2CAddress} {0}
set_instance_parameter_value si570_ctrl {RecallFrequency} {100000000}
set_instance_parameter_value si570_ctrl {TargetFrequency} {106250000}

add_instance temp intel_temp 1.0
set_instance_parameter_value temp {FanInvOut} {0}
set_instance_parameter_value temp {FanOut} {1}
set_instance_parameter_value temp {FanTemp} {60}

add_instance temp_sense altera_temp_sense 20.1
set_instance_parameter_value temp_sense {CBX_AUTO_BLACKBOX} {ALL}
set_instance_parameter_value temp_sense {CE_CHECK} {0}
set_instance_parameter_value temp_sense {CLK_FREQUENCY} {50.0}
set_instance_parameter_value temp_sense {CLOCK_DIVIDER_VALUE} {80}
set_instance_parameter_value temp_sense {CLR_CHECK} {1}
set_instance_parameter_value temp_sense {NUMBER_OF_SAMPLES} {128}
set_instance_parameter_value temp_sense {POI_CAL_TEMPERATURE} {85}
set_instance_parameter_value temp_sense {SIM_TSDCALO} {0}
set_instance_parameter_value temp_sense {USER_OFFSET_ENABLE} {off}
set_instance_parameter_value temp_sense {USE_WYS} {on}

add_instance tlp_adapter intel_pcie_tlp_adapter 1.0

add_instance xcvr0 fc_8g_xcvr 1.0

add_instance xcvr1 fc_8g_xcvr 1.0

add_instance xcvr_reconfig alt_xcvr_reconfig 19.1
set_instance_parameter_value xcvr_reconfig {ber_en} {0}
set_instance_parameter_value xcvr_reconfig {enable_adce} {0}
set_instance_parameter_value xcvr_reconfig {enable_analog} {1}
set_instance_parameter_value xcvr_reconfig {enable_dcd} {0}
set_instance_parameter_value xcvr_reconfig {enable_dcd_power_up} {1}
set_instance_parameter_value xcvr_reconfig {enable_dfe} {0}
set_instance_parameter_value xcvr_reconfig {enable_eyemon} {0}
set_instance_parameter_value xcvr_reconfig {enable_mif} {0}
set_instance_parameter_value xcvr_reconfig {enable_offset} {1}
set_instance_parameter_value xcvr_reconfig {gui_cal_status_port} {0}
set_instance_parameter_value xcvr_reconfig {gui_enable_pll} {0}
set_instance_parameter_value xcvr_reconfig {gui_split_sizes} {2,2}
set_instance_parameter_value xcvr_reconfig {number_of_reconfig_interfaces} {4}

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF ext0.clk_in
add_interface fan conduit end
set_interface_property fan EXPORT_OF temp.fan
add_interface led conduit end
set_interface_property led EXPORT_OF led.led
add_interface pcie_refclk clock sink
set_interface_property pcie_refclk EXPORT_OF pcie_phy.refclk
add_interface pcie_reset_pin conduit end
set_interface_property pcie_reset_pin EXPORT_OF pcie_reset.pin
add_interface pcie_serial conduit end
set_interface_property pcie_serial EXPORT_OF pcie_phy.hip_serial
add_interface phy_clk clock sink
set_interface_property phy_clk EXPORT_OF phy_clk.in_clk
add_interface phy_clk_out clock source
set_interface_property phy_clk_out EXPORT_OF phy_clk_out.out_clk
add_interface port0_line_rd conduit end
set_interface_property port0_line_rd EXPORT_OF xcvr0.line_rd
add_interface port0_line_td conduit end
set_interface_property port0_line_td EXPORT_OF xcvr0.line_td
add_interface port1_line_rd conduit end
set_interface_property port1_line_rd EXPORT_OF xcvr1.line_rd
add_interface port1_line_td conduit end
set_interface_property port1_line_td EXPORT_OF xcvr1.line_td
add_interface reset reset sink
set_interface_property reset EXPORT_OF ext0.clk_in_reset
add_interface sfp0_sfp conduit end
set_interface_property sfp0_sfp EXPORT_OF sfp0.sfp
add_interface sfp1_sfp conduit end
set_interface_property sfp1_sfp EXPORT_OF sfp1.sfp
add_interface sfp2_sfp conduit end
set_interface_property sfp2_sfp EXPORT_OF sfp2.sfp
add_interface sfp3_sfp conduit end
set_interface_property sfp3_sfp EXPORT_OF sfp3.sfp
add_interface si570_i2c conduit end
set_interface_property si570_i2c EXPORT_OF si570_ctrl.si570_i2c

# connections and connection parameters
add_connection alt_xcvr_reconfig_0.reconfig_busy pcie_reconfig.reconfig_busy
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_busy/pcie_reconfig.reconfig_busy endPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_busy/pcie_reconfig.reconfig_busy endPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_busy/pcie_reconfig.reconfig_busy startPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_busy/pcie_reconfig.reconfig_busy startPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_busy/pcie_reconfig.reconfig_busy width {0}

add_connection alt_xcvr_reconfig_0.reconfig_from_xcvr pcie_phy.reconfig_from_xcvr
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_phy.reconfig_from_xcvr endPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_phy.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_phy.reconfig_from_xcvr startPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_phy.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_phy.reconfig_from_xcvr width {0}

add_connection alt_xcvr_reconfig_0.reconfig_to_xcvr pcie_phy.reconfig_to_xcvr
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_phy.reconfig_to_xcvr endPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_phy.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_phy.reconfig_to_xcvr startPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_phy.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_phy.reconfig_to_xcvr width {0}

add_connection bar0_cdc.m0 datapath.csr_fc0_rx
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_rx arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_rx baseAddress {0x9000}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_rx defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_fc0_rx_cdc
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_rx_cdc arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_rx_cdc baseAddress {0x9100}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_rx_cdc defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_fc0_tx
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_tx arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_tx baseAddress {0x9020}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc0_tx defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_fc1_rx
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_rx arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_rx baseAddress {0xb000}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_rx defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_fc1_rx_cdc
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_rx_cdc arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_rx_cdc baseAddress {0xb100}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_rx_cdc defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_fc1_tx
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_tx arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_tx baseAddress {0xb020}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc1_tx defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_fc_debug
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc_debug arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc_debug baseAddress {0x0040}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_fc_debug defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_pcie_data
set_connection_parameter_value bar0_cdc.m0/datapath.csr_pcie_data arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_pcie_data baseAddress {0x0800}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_pcie_data defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_tlp_data_fifo
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_data_fifo arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_data_fifo baseAddress {0x0900}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_data_fifo defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_tlp_instant_fifo
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_instant_fifo arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_instant_fifo baseAddress {0x0910}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_instant_fifo defaultConnection {0}

add_connection bar0_cdc.m0 datapath.csr_tlp_response_fifo
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_response_fifo arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_response_fifo baseAddress {0x0920}
set_connection_parameter_value bar0_cdc.m0/datapath.csr_tlp_response_fifo defaultConnection {0}

add_connection bar0_cdc.m0 ident.mm
set_connection_parameter_value bar0_cdc.m0/ident.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/ident.mm baseAddress {0x0000}
set_connection_parameter_value bar0_cdc.m0/ident.mm defaultConnection {0}

add_connection bar0_cdc.m0 pcie_clk_gauge.mm
set_connection_parameter_value bar0_cdc.m0/pcie_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/pcie_clk_gauge.mm baseAddress {0x0024}
set_connection_parameter_value bar0_cdc.m0/pcie_clk_gauge.mm defaultConnection {0}

add_connection bar0_cdc.m0 pcie_status.mm
set_connection_parameter_value bar0_cdc.m0/pcie_status.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/pcie_status.mm baseAddress {0x0980}
set_connection_parameter_value bar0_cdc.m0/pcie_status.mm defaultConnection {0}

add_connection bar0_cdc.m0 phy_clk_gauge.mm
set_connection_parameter_value bar0_cdc.m0/phy_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/phy_clk_gauge.mm baseAddress {0x0020}
set_connection_parameter_value bar0_cdc.m0/phy_clk_gauge.mm defaultConnection {0}

add_connection bar0_cdc.m0 sfp0.mm
set_connection_parameter_value bar0_cdc.m0/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/sfp0.mm baseAddress {0x0100}
set_connection_parameter_value bar0_cdc.m0/sfp0.mm defaultConnection {0}

add_connection bar0_cdc.m0 sfp1.mm
set_connection_parameter_value bar0_cdc.m0/sfp1.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/sfp1.mm baseAddress {0x0200}
set_connection_parameter_value bar0_cdc.m0/sfp1.mm defaultConnection {0}

add_connection bar0_cdc.m0 sfp2.mm
set_connection_parameter_value bar0_cdc.m0/sfp2.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/sfp2.mm baseAddress {0x0300}
set_connection_parameter_value bar0_cdc.m0/sfp2.mm defaultConnection {0}

add_connection bar0_cdc.m0 sfp3.mm
set_connection_parameter_value bar0_cdc.m0/sfp3.mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/sfp3.mm baseAddress {0x0400}
set_connection_parameter_value bar0_cdc.m0/sfp3.mm defaultConnection {0}

add_connection bar0_cdc.m0 temp.temp_mm
set_connection_parameter_value bar0_cdc.m0/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value bar0_cdc.m0/temp.temp_mm defaultConnection {0}

add_connection bar0_cdc.m0 xcvr0.mgmt_mm
set_connection_parameter_value bar0_cdc.m0/xcvr0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/xcvr0.mgmt_mm baseAddress {0x8000}
set_connection_parameter_value bar0_cdc.m0/xcvr0.mgmt_mm defaultConnection {0}

add_connection bar0_cdc.m0 xcvr1.mgmt_mm
set_connection_parameter_value bar0_cdc.m0/xcvr1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value bar0_cdc.m0/xcvr1.mgmt_mm baseAddress {0xa000}
set_connection_parameter_value bar0_cdc.m0/xcvr1.mgmt_mm defaultConnection {0}

add_connection datapath.bar0_mm bar0_cdc.s0
set_connection_parameter_value datapath.bar0_mm/bar0_cdc.s0 arbitrationPriority {1}
set_connection_parameter_value datapath.bar0_mm/bar0_cdc.s0 baseAddress {0x0000}
set_connection_parameter_value datapath.bar0_mm/bar0_cdc.s0 defaultConnection {0}

add_connection datapath.fc0_active led.fcport0_active
set_connection_parameter_value datapath.fc0_active/led.fcport0_active endPort {}
set_connection_parameter_value datapath.fc0_active/led.fcport0_active endPortLSB {0}
set_connection_parameter_value datapath.fc0_active/led.fcport0_active startPort {}
set_connection_parameter_value datapath.fc0_active/led.fcport0_active startPortLSB {0}
set_connection_parameter_value datapath.fc0_active/led.fcport0_active width {0}

add_connection datapath.pcie_data_config_tl pcie_phy.config_tl
set_connection_parameter_value datapath.pcie_data_config_tl/pcie_phy.config_tl endPort {}
set_connection_parameter_value datapath.pcie_data_config_tl/pcie_phy.config_tl endPortLSB {0}
set_connection_parameter_value datapath.pcie_data_config_tl/pcie_phy.config_tl startPort {}
set_connection_parameter_value datapath.pcie_data_config_tl/pcie_phy.config_tl startPortLSB {0}
set_connection_parameter_value datapath.pcie_data_config_tl/pcie_phy.config_tl width {0}

add_connection datapath.pcie_data_rx_bar_be pcie_phy.rx_bar_be
set_connection_parameter_value datapath.pcie_data_rx_bar_be/pcie_phy.rx_bar_be endPort {}
set_connection_parameter_value datapath.pcie_data_rx_bar_be/pcie_phy.rx_bar_be endPortLSB {0}
set_connection_parameter_value datapath.pcie_data_rx_bar_be/pcie_phy.rx_bar_be startPort {}
set_connection_parameter_value datapath.pcie_data_rx_bar_be/pcie_phy.rx_bar_be startPortLSB {0}
set_connection_parameter_value datapath.pcie_data_rx_bar_be/pcie_phy.rx_bar_be width {0}

add_connection datapath.pcie_tlp_tx tlp_adapter.tlp_tx_st

add_connection datapath.xcvr0_avtx xcvr0.avtx

add_connection datapath.xcvr1_avtx xcvr1.avtx

add_connection ext0.clk alt_xcvr_reconfig_0.mgmt_clk_clk

add_connection ext0.clk bar0_cdc.m0_clk

add_connection ext0.clk datapath.mgmt_clk

add_connection ext0.clk ident.clk

add_connection ext0.clk jtagm.clk

add_connection ext0.clk led.clk

add_connection ext0.clk pcie_clk_gauge.ref_clk

add_connection ext0.clk pcie_reconfig.pld_clk

add_connection ext0.clk pcie_reconfig.reconfig_xcvr_clk

add_connection ext0.clk pcie_reset.clk

add_connection ext0.clk phy_clk_gauge.ref_clk

add_connection ext0.clk reset_ctrl.clk

add_connection ext0.clk reset_seqencer.clk

add_connection ext0.clk sfp0.clk

add_connection ext0.clk sfp1.clk

add_connection ext0.clk sfp2.clk

add_connection ext0.clk sfp3.clk

add_connection ext0.clk si570_ctrl.clk

add_connection ext0.clk temp.clk

add_connection ext0.clk temp_sense.clk

add_connection ext0.clk xcvr0.mgmt_clk

add_connection ext0.clk xcvr1.mgmt_clk

add_connection ext0.clk xcvr_reconfig.mgmt_clk_clk

add_connection ext0.clk_reset jtagm.clk_reset

add_connection ext0.clk_reset reset_ctrl.reset_in0

add_connection ext0.clk_reset si570_ctrl.reset

add_connection jtagm.master datapath.csr_fc0_rx
set_connection_parameter_value jtagm.master/datapath.csr_fc0_rx arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_fc0_rx baseAddress {0x9000}
set_connection_parameter_value jtagm.master/datapath.csr_fc0_rx defaultConnection {0}

add_connection jtagm.master datapath.csr_fc0_rx_cdc
set_connection_parameter_value jtagm.master/datapath.csr_fc0_rx_cdc arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_fc0_rx_cdc baseAddress {0x9100}
set_connection_parameter_value jtagm.master/datapath.csr_fc0_rx_cdc defaultConnection {0}

add_connection jtagm.master datapath.csr_fc0_tx
set_connection_parameter_value jtagm.master/datapath.csr_fc0_tx arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_fc0_tx baseAddress {0x9020}
set_connection_parameter_value jtagm.master/datapath.csr_fc0_tx defaultConnection {0}

add_connection jtagm.master datapath.csr_fc1_rx
set_connection_parameter_value jtagm.master/datapath.csr_fc1_rx arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_fc1_rx baseAddress {0xb000}
set_connection_parameter_value jtagm.master/datapath.csr_fc1_rx defaultConnection {0}

add_connection jtagm.master datapath.csr_fc1_rx_cdc
set_connection_parameter_value jtagm.master/datapath.csr_fc1_rx_cdc arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_fc1_rx_cdc baseAddress {0xb100}
set_connection_parameter_value jtagm.master/datapath.csr_fc1_rx_cdc defaultConnection {0}

add_connection jtagm.master datapath.csr_fc1_tx
set_connection_parameter_value jtagm.master/datapath.csr_fc1_tx arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_fc1_tx baseAddress {0xb020}
set_connection_parameter_value jtagm.master/datapath.csr_fc1_tx defaultConnection {0}

add_connection jtagm.master datapath.csr_fc_debug
set_connection_parameter_value jtagm.master/datapath.csr_fc_debug arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_fc_debug baseAddress {0x0040}
set_connection_parameter_value jtagm.master/datapath.csr_fc_debug defaultConnection {0}

add_connection jtagm.master datapath.csr_pcie_data
set_connection_parameter_value jtagm.master/datapath.csr_pcie_data arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_pcie_data baseAddress {0x0800}
set_connection_parameter_value jtagm.master/datapath.csr_pcie_data defaultConnection {0}

add_connection jtagm.master datapath.csr_tlp_data_fifo
set_connection_parameter_value jtagm.master/datapath.csr_tlp_data_fifo arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_tlp_data_fifo baseAddress {0x0900}
set_connection_parameter_value jtagm.master/datapath.csr_tlp_data_fifo defaultConnection {0}

add_connection jtagm.master datapath.csr_tlp_instant_fifo
set_connection_parameter_value jtagm.master/datapath.csr_tlp_instant_fifo arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_tlp_instant_fifo baseAddress {0x0910}
set_connection_parameter_value jtagm.master/datapath.csr_tlp_instant_fifo defaultConnection {0}

add_connection jtagm.master datapath.csr_tlp_response_fifo
set_connection_parameter_value jtagm.master/datapath.csr_tlp_response_fifo arbitrationPriority {1}
set_connection_parameter_value jtagm.master/datapath.csr_tlp_response_fifo baseAddress {0x0920}
set_connection_parameter_value jtagm.master/datapath.csr_tlp_response_fifo defaultConnection {0}

add_connection jtagm.master ident.mm
set_connection_parameter_value jtagm.master/ident.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/ident.mm baseAddress {0x0000}
set_connection_parameter_value jtagm.master/ident.mm defaultConnection {0}

add_connection jtagm.master pcie_clk_gauge.mm
set_connection_parameter_value jtagm.master/pcie_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/pcie_clk_gauge.mm baseAddress {0x0024}
set_connection_parameter_value jtagm.master/pcie_clk_gauge.mm defaultConnection {0}

add_connection jtagm.master pcie_status.mm
set_connection_parameter_value jtagm.master/pcie_status.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/pcie_status.mm baseAddress {0x0980}
set_connection_parameter_value jtagm.master/pcie_status.mm defaultConnection {0}

add_connection jtagm.master phy_clk_gauge.mm
set_connection_parameter_value jtagm.master/phy_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/phy_clk_gauge.mm baseAddress {0x0020}
set_connection_parameter_value jtagm.master/phy_clk_gauge.mm defaultConnection {0}

add_connection jtagm.master sfp0.mm
set_connection_parameter_value jtagm.master/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp0.mm baseAddress {0x0100}
set_connection_parameter_value jtagm.master/sfp0.mm defaultConnection {0}

add_connection jtagm.master sfp1.mm
set_connection_parameter_value jtagm.master/sfp1.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp1.mm baseAddress {0x0200}
set_connection_parameter_value jtagm.master/sfp1.mm defaultConnection {0}

add_connection jtagm.master sfp2.mm
set_connection_parameter_value jtagm.master/sfp2.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp2.mm baseAddress {0x0300}
set_connection_parameter_value jtagm.master/sfp2.mm defaultConnection {0}

add_connection jtagm.master sfp3.mm
set_connection_parameter_value jtagm.master/sfp3.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp3.mm baseAddress {0x0400}
set_connection_parameter_value jtagm.master/sfp3.mm defaultConnection {0}

add_connection jtagm.master temp.temp_mm
set_connection_parameter_value jtagm.master/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value jtagm.master/temp.temp_mm defaultConnection {0}

add_connection jtagm.master xcvr0.mgmt_mm
set_connection_parameter_value jtagm.master/xcvr0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/xcvr0.mgmt_mm baseAddress {0x8000}
set_connection_parameter_value jtagm.master/xcvr0.mgmt_mm defaultConnection {0}

add_connection jtagm.master xcvr1.mgmt_mm
set_connection_parameter_value jtagm.master/xcvr1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/xcvr1.mgmt_mm baseAddress {0xa000}
set_connection_parameter_value jtagm.master/xcvr1.mgmt_mm defaultConnection {0}

add_connection jtagm.master xcvr_reconfig.reconfig_mgmt
set_connection_parameter_value jtagm.master/xcvr_reconfig.reconfig_mgmt arbitrationPriority {1}
set_connection_parameter_value jtagm.master/xcvr_reconfig.reconfig_mgmt baseAddress {0xfe00}
set_connection_parameter_value jtagm.master/xcvr_reconfig.reconfig_mgmt defaultConnection {0}

add_connection jtagm.master_reset reset_ctrl.reset_in1

add_connection led.fcport0_aligned xcvr0.aligned
set_connection_parameter_value led.fcport0_aligned/xcvr0.aligned endPort {}
set_connection_parameter_value led.fcport0_aligned/xcvr0.aligned endPortLSB {0}
set_connection_parameter_value led.fcport0_aligned/xcvr0.aligned startPort {}
set_connection_parameter_value led.fcport0_aligned/xcvr0.aligned startPortLSB {0}
set_connection_parameter_value led.fcport0_aligned/xcvr0.aligned width {0}

add_connection led.fcport1_active datapath.fc1_active
set_connection_parameter_value led.fcport1_active/datapath.fc1_active endPort {}
set_connection_parameter_value led.fcport1_active/datapath.fc1_active endPortLSB {0}
set_connection_parameter_value led.fcport1_active/datapath.fc1_active startPort {}
set_connection_parameter_value led.fcport1_active/datapath.fc1_active startPortLSB {0}
set_connection_parameter_value led.fcport1_active/datapath.fc1_active width {0}

add_connection led.fcport1_aligned xcvr1.aligned
set_connection_parameter_value led.fcport1_aligned/xcvr1.aligned endPort {}
set_connection_parameter_value led.fcport1_aligned/xcvr1.aligned endPortLSB {0}
set_connection_parameter_value led.fcport1_aligned/xcvr1.aligned startPort {}
set_connection_parameter_value led.fcport1_aligned/xcvr1.aligned startPortLSB {0}
set_connection_parameter_value led.fcport1_aligned/xcvr1.aligned width {0}

add_connection led.xcvr_reconfig xcvr_reconfig.reconfig_busy
set_connection_parameter_value led.xcvr_reconfig/xcvr_reconfig.reconfig_busy endPort {}
set_connection_parameter_value led.xcvr_reconfig/xcvr_reconfig.reconfig_busy endPortLSB {0}
set_connection_parameter_value led.xcvr_reconfig/xcvr_reconfig.reconfig_busy startPort {}
set_connection_parameter_value led.xcvr_reconfig/xcvr_reconfig.reconfig_busy startPortLSB {0}
set_connection_parameter_value led.xcvr_reconfig/xcvr_reconfig.reconfig_busy width {0}

add_connection msi_intr.int_msi pcie_phy.int_msi
set_connection_parameter_value msi_intr.int_msi/pcie_phy.int_msi endPort {}
set_connection_parameter_value msi_intr.int_msi/pcie_phy.int_msi endPortLSB {0}
set_connection_parameter_value msi_intr.int_msi/pcie_phy.int_msi startPort {}
set_connection_parameter_value msi_intr.int_msi/pcie_phy.int_msi startPortLSB {0}
set_connection_parameter_value msi_intr.int_msi/pcie_phy.int_msi width {0}

add_connection msi_intr.irq datapath.irq_c2h_avail
set_connection_parameter_value msi_intr.irq/datapath.irq_c2h_avail irqNumber {1}

add_connection msi_intr.irq datapath.irq_c2h_drop
set_connection_parameter_value msi_intr.irq/datapath.irq_c2h_drop irqNumber {2}

add_connection msi_intr.irq sfp0.i2c_irq
set_connection_parameter_value msi_intr.irq/sfp0.i2c_irq irqNumber {3}

add_connection msi_intr.irq sfp1.i2c_irq
set_connection_parameter_value msi_intr.irq/sfp1.i2c_irq irqNumber {4}

add_connection msi_intr.irq sfp2.i2c_irq
set_connection_parameter_value msi_intr.irq/sfp2.i2c_irq irqNumber {5}

add_connection msi_intr.irq sfp3.i2c_irq
set_connection_parameter_value msi_intr.irq/sfp3.i2c_irq irqNumber {6}

add_connection pcie_phy.coreclkout_hip bar0_cdc.s0_clk

add_connection pcie_phy.coreclkout_hip datapath.data_clk

add_connection pcie_phy.coreclkout_hip msi_intr.clk

add_connection pcie_phy.coreclkout_hip pcie_clk_gauge.probe_clk

add_connection pcie_phy.coreclkout_hip pcie_phy.pld_clk

add_connection pcie_phy.coreclkout_hip pcie_status.clk

add_connection pcie_phy.coreclkout_hip tlp_adapter.clk

add_connection pcie_phy.rx_st tlp_adapter.phy_rx_st

add_connection pcie_reconfig.hip_currentspeed pcie_phy.hip_currentspeed
set_connection_parameter_value pcie_reconfig.hip_currentspeed/pcie_phy.hip_currentspeed endPort {}
set_connection_parameter_value pcie_reconfig.hip_currentspeed/pcie_phy.hip_currentspeed endPortLSB {0}
set_connection_parameter_value pcie_reconfig.hip_currentspeed/pcie_phy.hip_currentspeed startPort {}
set_connection_parameter_value pcie_reconfig.hip_currentspeed/pcie_phy.hip_currentspeed startPortLSB {0}
set_connection_parameter_value pcie_reconfig.hip_currentspeed/pcie_phy.hip_currentspeed width {0}

add_connection pcie_reconfig.reconfig_mgmt alt_xcvr_reconfig_0.reconfig_mgmt
set_connection_parameter_value pcie_reconfig.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt arbitrationPriority {1}
set_connection_parameter_value pcie_reconfig.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt baseAddress {0x0000}
set_connection_parameter_value pcie_reconfig.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt defaultConnection {0}

add_connection pcie_reset.npor pcie_phy.npor
set_connection_parameter_value pcie_reset.npor/pcie_phy.npor endPort {}
set_connection_parameter_value pcie_reset.npor/pcie_phy.npor endPortLSB {0}
set_connection_parameter_value pcie_reset.npor/pcie_phy.npor startPort {}
set_connection_parameter_value pcie_reset.npor/pcie_phy.npor startPortLSB {0}
set_connection_parameter_value pcie_reset.npor/pcie_phy.npor width {0}

add_connection pcie_status.hip_status_drv pcie_phy.hip_status
set_connection_parameter_value pcie_status.hip_status_drv/pcie_phy.hip_status endPort {}
set_connection_parameter_value pcie_status.hip_status_drv/pcie_phy.hip_status endPortLSB {0}
set_connection_parameter_value pcie_status.hip_status_drv/pcie_phy.hip_status startPort {}
set_connection_parameter_value pcie_status.hip_status_drv/pcie_phy.hip_status startPortLSB {0}
set_connection_parameter_value pcie_status.hip_status_drv/pcie_phy.hip_status width {0}

add_connection pcie_status.hip_status_out pcie_reconfig.hip_status_drv
set_connection_parameter_value pcie_status.hip_status_out/pcie_reconfig.hip_status_drv endPort {}
set_connection_parameter_value pcie_status.hip_status_out/pcie_reconfig.hip_status_drv endPortLSB {0}
set_connection_parameter_value pcie_status.hip_status_out/pcie_reconfig.hip_status_drv startPort {}
set_connection_parameter_value pcie_status.hip_status_out/pcie_reconfig.hip_status_drv startPortLSB {0}
set_connection_parameter_value pcie_status.hip_status_out/pcie_reconfig.hip_status_drv width {0}

add_connection phy_clk.out_clk phy_clk_gauge.probe_clk

add_connection phy_clk.out_clk phy_clk_out.in_clk

add_connection phy_clk.out_clk xcvr0.phy_clk

add_connection phy_clk.out_clk xcvr1.phy_clk

add_connection reset_ctrl.reset_out reset_seqencer.reset_in0

add_connection reset_seqencer.reset_out0 alt_xcvr_reconfig_0.mgmt_rst_reset

add_connection reset_seqencer.reset_out0 ident.reset

add_connection reset_seqencer.reset_out0 pcie_clk_gauge.reset

add_connection reset_seqencer.reset_out0 pcie_reconfig.reconfig_xcvr_rst

add_connection reset_seqencer.reset_out0 phy_clk_gauge.reset

add_connection reset_seqencer.reset_out0 sfp0.reset

add_connection reset_seqencer.reset_out0 sfp1.reset

add_connection reset_seqencer.reset_out0 sfp2.reset

add_connection reset_seqencer.reset_out0 sfp3.reset

add_connection reset_seqencer.reset_out0 temp.reset

add_connection reset_seqencer.reset_out0 xcvr_reconfig.mgmt_rst_reset

add_connection reset_seqencer.reset_out1 msi_intr.reset

add_connection reset_seqencer.reset_out1 pcie_reset.reset

add_connection reset_seqencer.reset_out1 pcie_status.reset

add_connection reset_seqencer.reset_out1 tlp_adapter.reset

add_connection reset_seqencer.reset_out2 bar0_cdc.m0_reset

add_connection reset_seqencer.reset_out2 bar0_cdc.s0_reset

add_connection reset_seqencer.reset_out2 datapath.reset

add_connection reset_seqencer.reset_out3 xcvr0.reset

add_connection reset_seqencer.reset_out3 xcvr1.reset

add_connection si570_ctrl.reset_out reset_ctrl.reset_in2

add_connection temp.clr temp_sense.clr

add_connection temp.tsdcaldone temp_sense.tsdcaldone
set_connection_parameter_value temp.tsdcaldone/temp_sense.tsdcaldone endPort {}
set_connection_parameter_value temp.tsdcaldone/temp_sense.tsdcaldone endPortLSB {0}
set_connection_parameter_value temp.tsdcaldone/temp_sense.tsdcaldone startPort {}
set_connection_parameter_value temp.tsdcaldone/temp_sense.tsdcaldone startPortLSB {0}
set_connection_parameter_value temp.tsdcaldone/temp_sense.tsdcaldone width {0}

add_connection temp_sense.tsdcalo temp.tsdcalo
set_connection_parameter_value temp_sense.tsdcalo/temp.tsdcalo endPort {}
set_connection_parameter_value temp_sense.tsdcalo/temp.tsdcalo endPortLSB {0}
set_connection_parameter_value temp_sense.tsdcalo/temp.tsdcalo startPort {}
set_connection_parameter_value temp_sense.tsdcalo/temp.tsdcalo startPortLSB {0}
set_connection_parameter_value temp_sense.tsdcalo/temp.tsdcalo width {0}

add_connection tlp_adapter.phy_tx_st pcie_phy.tx_st

add_connection tlp_adapter.tlp_rx_st datapath.pcie_tlp_rx

add_connection xcvr0.avrx datapath.xcvr0_avrx

add_connection xcvr0.reconfig_from_xcvr xcvr_reconfig.ch0_1_from_xcvr
set_connection_parameter_value xcvr0.reconfig_from_xcvr/xcvr_reconfig.ch0_1_from_xcvr endPort {}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/xcvr_reconfig.ch0_1_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/xcvr_reconfig.ch0_1_from_xcvr startPort {}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/xcvr_reconfig.ch0_1_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/xcvr_reconfig.ch0_1_from_xcvr width {0}

add_connection xcvr0.reconfig_to_xcvr xcvr_reconfig.ch0_1_to_xcvr
set_connection_parameter_value xcvr0.reconfig_to_xcvr/xcvr_reconfig.ch0_1_to_xcvr endPort {}
set_connection_parameter_value xcvr0.reconfig_to_xcvr/xcvr_reconfig.ch0_1_to_xcvr endPortLSB {0}
set_connection_parameter_value xcvr0.reconfig_to_xcvr/xcvr_reconfig.ch0_1_to_xcvr startPort {}
set_connection_parameter_value xcvr0.reconfig_to_xcvr/xcvr_reconfig.ch0_1_to_xcvr startPortLSB {0}
set_connection_parameter_value xcvr0.reconfig_to_xcvr/xcvr_reconfig.ch0_1_to_xcvr width {0}

add_connection xcvr0.rx_clk datapath.xcvr0_rx_clk

add_connection xcvr0.tx_clk datapath.xcvr0_tx_clk

add_connection xcvr1.avrx datapath.xcvr1_avrx

add_connection xcvr1.reconfig_from_xcvr xcvr_reconfig.ch2_3_from_xcvr
set_connection_parameter_value xcvr1.reconfig_from_xcvr/xcvr_reconfig.ch2_3_from_xcvr endPort {}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/xcvr_reconfig.ch2_3_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/xcvr_reconfig.ch2_3_from_xcvr startPort {}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/xcvr_reconfig.ch2_3_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/xcvr_reconfig.ch2_3_from_xcvr width {0}

add_connection xcvr1.reconfig_to_xcvr xcvr_reconfig.ch2_3_to_xcvr
set_connection_parameter_value xcvr1.reconfig_to_xcvr/xcvr_reconfig.ch2_3_to_xcvr endPort {}
set_connection_parameter_value xcvr1.reconfig_to_xcvr/xcvr_reconfig.ch2_3_to_xcvr endPortLSB {0}
set_connection_parameter_value xcvr1.reconfig_to_xcvr/xcvr_reconfig.ch2_3_to_xcvr startPort {}
set_connection_parameter_value xcvr1.reconfig_to_xcvr/xcvr_reconfig.ch2_3_to_xcvr startPortLSB {0}
set_connection_parameter_value xcvr1.reconfig_to_xcvr/xcvr_reconfig.ch2_3_to_xcvr width {0}

add_connection xcvr1.rx_clk datapath.xcvr1_rx_clk

add_connection xcvr1.tx_clk datapath.xcvr1_tx_clk

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.enableInstrumentation} {TRUE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {fc.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {ident.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.bar0_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.csr_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie_phy_clk_gauge.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {sfp0.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {sfp1.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {temp.temp_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}

save_system {fejkon.qsys}
