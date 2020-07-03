# qsys scripting (.tcl) file for svpcie_sim_tb
package require -exact qsys 16.0

create_system {svpcie_sim_tb}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance appclk altera_clock_bridge 20.1
set_instance_parameter_value appclk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value appclk {NUM_CLOCK_OUTPUTS} {1}

add_instance clk altera_avalon_clock_source 20.1
set_instance_parameter_value clk {CLOCK_RATE} {50000000}
set_instance_parameter_value clk {CLOCK_UNIT} {1}

add_instance data_bfm altera_avalon_st_source_bfm 20.1
set_instance_parameter_value data_bfm {ST_BEATSPERCYCLE} {1}
set_instance_parameter_value data_bfm {ST_CHANNEL_W} {1}
set_instance_parameter_value data_bfm {ST_ERROR_DESCRIPTOR} {}
set_instance_parameter_value data_bfm {ST_ERROR_W} {1}
set_instance_parameter_value data_bfm {ST_MAX_CHANNELS} {1}
set_instance_parameter_value data_bfm {ST_NUMSYMBOLS} {1}
set_instance_parameter_value data_bfm {ST_READY_LATENCY} {0}
set_instance_parameter_value data_bfm {ST_SYMBOL_W} {8}
set_instance_parameter_value data_bfm {USE_CHANNEL} {0}
set_instance_parameter_value data_bfm {USE_EMPTY} {0}
set_instance_parameter_value data_bfm {USE_ERROR} {0}
set_instance_parameter_value data_bfm {USE_PACKET} {1}
set_instance_parameter_value data_bfm {USE_READY} {1}
set_instance_parameter_value data_bfm {USE_VALID} {1}
set_instance_parameter_value data_bfm {VHDL_ID} {0}

add_instance endp0 altera_pcie_sv_hip_ast 20.1
set_instance_parameter_value endp0 {advanced_default_hwtcl_atomic_malformed} {true}
set_instance_parameter_value endp0 {advanced_default_hwtcl_atomic_op_completer_32bit} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_atomic_op_completer_64bit} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_atomic_op_routing} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_bridge_port_ssid_support} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_bridge_port_vga_enable} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_bypass_cdc} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_cas_completer_128bit} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_cdc_dummy_insert_limit} {11}
set_instance_parameter_value endp0 {advanced_default_hwtcl_d0_pme} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_d1_pme} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_d1_support} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_d2_pme} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_d2_support} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_d3_cold_pme} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_d3_hot_pme} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_data_pack_rx} {disable}
set_instance_parameter_value endp0 {advanced_default_hwtcl_deskew_comma} {com_deskw}
set_instance_parameter_value endp0 {advanced_default_hwtcl_device_number} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_disable_link_x2_support} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_disable_snoop_packet} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_ei_delay_powerdown_count} {10}
set_instance_parameter_value endp0 {advanced_default_hwtcl_eie_before_nfts_count} {4}
set_instance_parameter_value endp0 {advanced_default_hwtcl_enable_adapter_half_rate_mode} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_enable_l1_aspm} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_enable_rx_buffer_checking} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_extended_format_field} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_extended_tag_reset} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_fc_init_timer} {1024}
set_instance_parameter_value endp0 {advanced_default_hwtcl_flow_control_timeout_count} {200}
set_instance_parameter_value endp0 {advanced_default_hwtcl_flow_control_update_count} {30}
set_instance_parameter_value endp0 {advanced_default_hwtcl_flr_capability} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_gen2_diffclock_nfts_count} {255}
set_instance_parameter_value endp0 {advanced_default_hwtcl_gen2_sameclock_nfts_count} {255}
set_instance_parameter_value endp0 {advanced_default_hwtcl_hot_plug_support} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_interrupt_pin} {inta}
set_instance_parameter_value endp0 {advanced_default_hwtcl_l01_entry_latency} {31}
set_instance_parameter_value endp0 {advanced_default_hwtcl_l0_exit_latency_diffclock} {6}
set_instance_parameter_value endp0 {advanced_default_hwtcl_l0_exit_latency_sameclock} {6}
set_instance_parameter_value endp0 {advanced_default_hwtcl_l1_exit_latency_diffclock} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_l1_exit_latency_sameclock} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_low_priority_vc} {single_vc}
set_instance_parameter_value endp0 {advanced_default_hwtcl_ltr_mechanism} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_ltssm_1ms_timeout} {disable}
set_instance_parameter_value endp0 {advanced_default_hwtcl_ltssm_freqlocked_check} {disable}
set_instance_parameter_value endp0 {advanced_default_hwtcl_maximum_current} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_no_command_completed} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_no_soft_reset} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_pclk_out_sel} {pclk}
set_instance_parameter_value endp0 {advanced_default_hwtcl_pipex1_debug_sel} {disable}
set_instance_parameter_value endp0 {advanced_default_hwtcl_register_pipe_signals} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_reserved_debug} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_retry_buffer_last_active_address} {2047}
set_instance_parameter_value endp0 {advanced_default_hwtcl_rx_l0s_count_idl} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_set_l0s} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_skp_os_gen3_count} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_skp_os_schedule_count} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_ssid} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_ssvid} {0}
set_instance_parameter_value endp0 {advanced_default_hwtcl_tph_completer} {false}
set_instance_parameter_value endp0 {advanced_default_hwtcl_tx_cdc_almost_empty} {5}
set_instance_parameter_value endp0 {advanced_default_hwtcl_vc0_clk_enable} {true}
set_instance_parameter_value endp0 {advanced_default_hwtcl_wrong_device_id} {disable}
set_instance_parameter_value endp0 {advanced_default_parameter_override} {0}
set_instance_parameter_value endp0 {ast_width_hwtcl} {Avalon-ST 256-bit}
set_instance_parameter_value endp0 {bar0_size_mask_hwtcl} {16}
set_instance_parameter_value endp0 {bar0_type_hwtcl} {2}
set_instance_parameter_value endp0 {bar1_size_mask_hwtcl} {0}
set_instance_parameter_value endp0 {bar1_type_hwtcl} {0}
set_instance_parameter_value endp0 {bar2_size_mask_hwtcl} {0}
set_instance_parameter_value endp0 {bar2_type_hwtcl} {0}
set_instance_parameter_value endp0 {bar3_size_mask_hwtcl} {0}
set_instance_parameter_value endp0 {bar3_type_hwtcl} {0}
set_instance_parameter_value endp0 {bar4_size_mask_hwtcl} {0}
set_instance_parameter_value endp0 {bar4_type_hwtcl} {0}
set_instance_parameter_value endp0 {bar5_size_mask_hwtcl} {0}
set_instance_parameter_value endp0 {bar5_type_hwtcl} {0}
set_instance_parameter_value endp0 {change_deemphasis_hwtcl} {1}
set_instance_parameter_value endp0 {class_code_hwtcl} {787456}
set_instance_parameter_value endp0 {completion_timeout_hwtcl} {A}
set_instance_parameter_value endp0 {device_id_hwtcl} {3557}
set_instance_parameter_value endp0 {dll_active_report_support_hwtcl} {0}
set_instance_parameter_value endp0 {ecrc_check_capable_hwtcl} {1}
set_instance_parameter_value endp0 {ecrc_gen_capable_hwtcl} {1}
set_instance_parameter_value endp0 {enable_completion_timeout_disable_hwtcl} {1}
set_instance_parameter_value endp0 {enable_function_msix_support_hwtcl} {0}
set_instance_parameter_value endp0 {enable_pcisigtest_hwtcl} {0}
set_instance_parameter_value endp0 {enable_pipe32_phyip_ser_driver_hwtcl} {0}
set_instance_parameter_value endp0 {enable_pipe32_sim_hwtcl} {0}
set_instance_parameter_value endp0 {enable_power_on_rst_pulse_hwtcl} {1}
set_instance_parameter_value endp0 {enable_slot_register_hwtcl} {0}
set_instance_parameter_value endp0 {enable_tl_only_sim_hwtcl} {0}
set_instance_parameter_value endp0 {endpoint_l0_latency_hwtcl} {0}
set_instance_parameter_value endp0 {endpoint_l1_latency_hwtcl} {0}
set_instance_parameter_value endp0 {expansion_base_address_register_hwtcl} {0}
set_instance_parameter_value endp0 {extend_tag_field_hwtcl} {64}
set_instance_parameter_value endp0 {fixed_preset_on} {0}
set_instance_parameter_value endp0 {force_hrc} {0}
set_instance_parameter_value endp0 {force_src} {0}
set_instance_parameter_value endp0 {full_swing_hwtcl} {35}
set_instance_parameter_value endp0 {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value endp0 {gen3_coeff_10_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_10_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_10_nxtber_less_hwtcl} {g3_coeff_10_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_10_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_10_nxtber_more_hwtcl} {g3_coeff_10_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_10_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_10_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_10_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_10_sel_hwtcl} {preset_10}
set_instance_parameter_value endp0 {gen3_coeff_11_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_11_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_11_nxtber_less_hwtcl} {g3_coeff_11_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_11_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_11_nxtber_more_hwtcl} {g3_coeff_11_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_11_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_11_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_11_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_11_sel_hwtcl} {preset_11}
set_instance_parameter_value endp0 {gen3_coeff_12_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_12_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_12_nxtber_less_hwtcl} {g3_coeff_12_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_12_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_12_nxtber_more_hwtcl} {g3_coeff_12_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_12_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_12_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_12_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_12_sel_hwtcl} {preset_12}
set_instance_parameter_value endp0 {gen3_coeff_13_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_13_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_13_nxtber_less_hwtcl} {g3_coeff_13_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_13_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_13_nxtber_more_hwtcl} {g3_coeff_13_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_13_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_13_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_13_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_13_sel_hwtcl} {preset_13}
set_instance_parameter_value endp0 {gen3_coeff_14_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_14_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_14_nxtber_less_hwtcl} {g3_coeff_14_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_14_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_14_nxtber_more_hwtcl} {g3_coeff_14_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_14_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_14_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_14_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_14_sel_hwtcl} {preset_14}
set_instance_parameter_value endp0 {gen3_coeff_15_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_15_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_15_nxtber_less_hwtcl} {g3_coeff_15_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_15_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_15_nxtber_more_hwtcl} {g3_coeff_15_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_15_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_15_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_15_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_15_sel_hwtcl} {preset_15}
set_instance_parameter_value endp0 {gen3_coeff_16_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_16_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_16_nxtber_less_hwtcl} {g3_coeff_16_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_16_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_16_nxtber_more_hwtcl} {g3_coeff_16_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_16_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_16_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_16_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_16_sel_hwtcl} {preset_16}
set_instance_parameter_value endp0 {gen3_coeff_17_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_17_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_17_nxtber_less_hwtcl} {g3_coeff_17_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_17_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_17_nxtber_more_hwtcl} {g3_coeff_17_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_17_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_17_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_17_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_17_sel_hwtcl} {preset_17}
set_instance_parameter_value endp0 {gen3_coeff_18_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_18_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_18_nxtber_less_hwtcl} {g3_coeff_18_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_18_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_18_nxtber_more_hwtcl} {g3_coeff_18_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_18_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_18_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_18_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_18_sel_hwtcl} {preset_18}
set_instance_parameter_value endp0 {gen3_coeff_19_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_19_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_19_nxtber_less_hwtcl} {g3_coeff_19_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_19_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_19_nxtber_more_hwtcl} {g3_coeff_19_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_19_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_19_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_19_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_19_sel_hwtcl} {preset_19}
set_instance_parameter_value endp0 {gen3_coeff_1_ber_meas_hwtcl} {2}
set_instance_parameter_value endp0 {gen3_coeff_1_hwtcl} {7}
set_instance_parameter_value endp0 {gen3_coeff_1_nxtber_less_hwtcl} {g3_coeff_1_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_1_nxtber_less_ptr_hwtcl} {1}
set_instance_parameter_value endp0 {gen3_coeff_1_nxtber_more_hwtcl} {g3_coeff_1_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_1_nxtber_more_ptr_hwtcl} {1}
set_instance_parameter_value endp0 {gen3_coeff_1_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_1_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_1_sel_hwtcl} {preset_1}
set_instance_parameter_value endp0 {gen3_coeff_20_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_20_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_20_nxtber_less_hwtcl} {g3_coeff_20_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_20_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_20_nxtber_more_hwtcl} {g3_coeff_20_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_20_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_20_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_20_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_20_sel_hwtcl} {preset_20}
set_instance_parameter_value endp0 {gen3_coeff_21_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_21_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_21_nxtber_less_hwtcl} {g3_coeff_21_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_21_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_21_nxtber_more_hwtcl} {g3_coeff_21_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_21_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_21_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_21_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_21_sel_hwtcl} {preset_21}
set_instance_parameter_value endp0 {gen3_coeff_22_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_22_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_22_nxtber_less_hwtcl} {g3_coeff_22_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_22_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_22_nxtber_more_hwtcl} {g3_coeff_22_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_22_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_22_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_22_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_22_sel_hwtcl} {preset_22}
set_instance_parameter_value endp0 {gen3_coeff_23_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_23_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_23_nxtber_less_hwtcl} {g3_coeff_23_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_23_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_23_nxtber_more_hwtcl} {g3_coeff_23_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_23_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_23_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_23_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_23_sel_hwtcl} {preset_23}
set_instance_parameter_value endp0 {gen3_coeff_24_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_24_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_24_nxtber_less_hwtcl} {g3_coeff_24_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_24_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_24_nxtber_more_hwtcl} {g3_coeff_24_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_24_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_24_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_24_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_24_sel_hwtcl} {preset_24}
set_instance_parameter_value endp0 {gen3_coeff_2_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_2_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_2_nxtber_less_hwtcl} {g3_coeff_2_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_2_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_2_nxtber_more_hwtcl} {g3_coeff_2_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_2_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_2_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_2_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_2_sel_hwtcl} {preset_2}
set_instance_parameter_value endp0 {gen3_coeff_3_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_3_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_3_nxtber_less_hwtcl} {g3_coeff_3_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_3_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_3_nxtber_more_hwtcl} {g3_coeff_3_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_3_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_3_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_3_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_3_sel_hwtcl} {preset_3}
set_instance_parameter_value endp0 {gen3_coeff_4_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_4_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_4_nxtber_less_hwtcl} {g3_coeff_4_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_4_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_4_nxtber_more_hwtcl} {g3_coeff_4_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_4_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_4_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_4_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_4_sel_hwtcl} {preset_4}
set_instance_parameter_value endp0 {gen3_coeff_5_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_5_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_5_nxtber_less_hwtcl} {g3_coeff_5_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_5_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_5_nxtber_more_hwtcl} {g3_coeff_5_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_5_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_5_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_5_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_5_sel_hwtcl} {preset_5}
set_instance_parameter_value endp0 {gen3_coeff_6_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_6_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_6_nxtber_less_hwtcl} {g3_coeff_6_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_6_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_6_nxtber_more_hwtcl} {g3_coeff_6_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_6_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_6_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_6_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_6_sel_hwtcl} {preset_6}
set_instance_parameter_value endp0 {gen3_coeff_7_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_7_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_7_nxtber_less_hwtcl} {g3_coeff_7_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_7_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_7_nxtber_more_hwtcl} {g3_coeff_7_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_7_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_7_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_7_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_7_sel_hwtcl} {preset_7}
set_instance_parameter_value endp0 {gen3_coeff_8_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_8_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_8_nxtber_less_hwtcl} {g3_coeff_8_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_8_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_8_nxtber_more_hwtcl} {g3_coeff_8_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_8_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_8_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_8_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_8_sel_hwtcl} {preset_8}
set_instance_parameter_value endp0 {gen3_coeff_9_ber_meas_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_9_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_9_nxtber_less_hwtcl} {g3_coeff_9_nxtber_less}
set_instance_parameter_value endp0 {gen3_coeff_9_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_9_nxtber_more_hwtcl} {g3_coeff_9_nxtber_more}
set_instance_parameter_value endp0 {gen3_coeff_9_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_9_preset_hint_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_9_reqber_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_coeff_9_sel_hwtcl} {preset_9}
set_instance_parameter_value endp0 {gen3_full_swing_hwtcl} {35}
set_instance_parameter_value endp0 {gen3_low_freq_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_10_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_11_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_1_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_2_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_3_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_4_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_5_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_6_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_7_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_8_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_preset_coeff_9_hwtcl} {0}
set_instance_parameter_value endp0 {gen3_rxfreqlock_counter_hwtcl} {0}
set_instance_parameter_value endp0 {hip_reconfig_hwtcl} {0}
set_instance_parameter_value endp0 {hip_tag_checking_hwtcl} {1}
set_instance_parameter_value endp0 {hwtcl_override_g2_txvod} {1}
set_instance_parameter_value endp0 {hwtcl_override_g3rxcoef} {0}
set_instance_parameter_value endp0 {hwtcl_override_g3txcoef} {0}
set_instance_parameter_value endp0 {in_cvp_mode_hwtcl} {0}
set_instance_parameter_value endp0 {io_window_addr_width_hwtcl} {0}
set_instance_parameter_value endp0 {lane_mask_hwtcl} {x8}
set_instance_parameter_value endp0 {low_latency_mode_hwtcl} {0}
set_instance_parameter_value endp0 {max_payload_size_hwtcl} {512}
set_instance_parameter_value endp0 {msi_64bit_addressing_capable_hwtcl} {true}
set_instance_parameter_value endp0 {msi_masking_capable_hwtcl} {false}
set_instance_parameter_value endp0 {msi_multi_message_capable_hwtcl} {32}
set_instance_parameter_value endp0 {msi_support_hwtcl} {true}
set_instance_parameter_value endp0 {msix_pba_bir_hwtcl} {0}
set_instance_parameter_value endp0 {msix_pba_offset_hwtcl} {0.0}
set_instance_parameter_value endp0 {msix_table_bir_hwtcl} {0}
set_instance_parameter_value endp0 {msix_table_offset_hwtcl} {0.0}
set_instance_parameter_value endp0 {msix_table_size_hwtcl} {0}
set_instance_parameter_value endp0 {multiple_packets_per_cycle_hwtcl} {0}
set_instance_parameter_value endp0 {override_rxbuffer_cred_preset} {0}
set_instance_parameter_value endp0 {override_tbpartner_driver_setting_hwtcl} {0}
set_instance_parameter_value endp0 {pcie_inspector_hwtcl} {0}
set_instance_parameter_value endp0 {pcie_qsys} {1}
set_instance_parameter_value endp0 {pcie_spec_version_hwtcl} {3.0}
set_instance_parameter_value endp0 {pll_refclk_freq_hwtcl} {100 MHz}
set_instance_parameter_value endp0 {port_link_number_hwtcl} {1}
set_instance_parameter_value endp0 {port_type_hwtcl} {Native endpoint}
set_instance_parameter_value endp0 {prefetchable_mem_window_addr_width_hwtcl} {0}
set_instance_parameter_value endp0 {revision_id_hwtcl} {1}
set_instance_parameter_value endp0 {rpre_emph_a_val_hwtcl} {9}
set_instance_parameter_value endp0 {rpre_emph_b_val_hwtcl} {0}
set_instance_parameter_value endp0 {rpre_emph_c_val_hwtcl} {16}
set_instance_parameter_value endp0 {rpre_emph_d_val_hwtcl} {13}
set_instance_parameter_value endp0 {rpre_emph_e_val_hwtcl} {5}
set_instance_parameter_value endp0 {rvod_sel_a_val_hwtcl} {42}
set_instance_parameter_value endp0 {rvod_sel_b_val_hwtcl} {38}
set_instance_parameter_value endp0 {rvod_sel_c_val_hwtcl} {38}
set_instance_parameter_value endp0 {rvod_sel_d_val_hwtcl} {43}
set_instance_parameter_value endp0 {rvod_sel_e_val_hwtcl} {15}
set_instance_parameter_value endp0 {rxbuffer_rxreq_hwtcl} {Balanced}
set_instance_parameter_value endp0 {serial_sim_hwtcl} {1}
set_instance_parameter_value endp0 {set_pld_clk_x1_625MHz_hwtcl} {0}
set_instance_parameter_value endp0 {slot_number_hwtcl} {0}
set_instance_parameter_value endp0 {slot_power_limit_hwtcl} {0}
set_instance_parameter_value endp0 {slot_power_scale_hwtcl} {0}
set_instance_parameter_value endp0 {slotclkcfg_hwtcl} {1}
set_instance_parameter_value endp0 {subsystem_device_id_hwtcl} {3557}
set_instance_parameter_value endp0 {subsystem_vendor_id_hwtcl} {61888}
set_instance_parameter_value endp0 {surprise_down_error_support_hwtcl} {0}
set_instance_parameter_value endp0 {tlp_insp_trg_dw0_hwtcl} {2049}
set_instance_parameter_value endp0 {tlp_insp_trg_dw1_hwtcl} {0}
set_instance_parameter_value endp0 {tlp_insp_trg_dw2_hwtcl} {0}
set_instance_parameter_value endp0 {tlp_insp_trg_dw3_hwtcl} {0}
set_instance_parameter_value endp0 {tlp_inspector_hwtcl} {0}
set_instance_parameter_value endp0 {tlp_inspector_use_signal_probe_hwtcl} {0}
set_instance_parameter_value endp0 {track_rxfc_cplbuf_ovf_hwtcl} {0}
set_instance_parameter_value endp0 {use_aer_hwtcl} {1}
set_instance_parameter_value endp0 {use_ast_parity} {0}
set_instance_parameter_value endp0 {use_atx_pll_hwtcl} {0}
set_instance_parameter_value endp0 {use_config_bypass_hwtcl} {0}
set_instance_parameter_value endp0 {use_crc_forwarding_hwtcl} {0}
set_instance_parameter_value endp0 {use_cvp_update_core_pof_hwtcl} {0}
set_instance_parameter_value endp0 {use_pci_ext_hwtcl} {0}
set_instance_parameter_value endp0 {use_pcie_ext_hwtcl} {0}
set_instance_parameter_value endp0 {use_rx_st_be_hwtcl} {0}
set_instance_parameter_value endp0 {use_tx_cons_cred_sel_hwtcl} {1}
set_instance_parameter_value endp0 {user_id_hwtcl} {0}
set_instance_parameter_value endp0 {vendor_id_hwtcl} {61888}
set_instance_parameter_value endp0 {vsec_id_hwtcl} {4466}
set_instance_parameter_value endp0 {vsec_rev_hwtcl} {0}

add_instance endp0_reconfig alt_xcvr_reconfig 19.1
set_instance_parameter_value endp0_reconfig {ber_en} {0}
set_instance_parameter_value endp0_reconfig {enable_adce} {0}
set_instance_parameter_value endp0_reconfig {enable_analog} {1}
set_instance_parameter_value endp0_reconfig {enable_dcd} {0}
set_instance_parameter_value endp0_reconfig {enable_dcd_power_up} {1}
set_instance_parameter_value endp0_reconfig {enable_dfe} {0}
set_instance_parameter_value endp0_reconfig {enable_eyemon} {0}
set_instance_parameter_value endp0_reconfig {enable_mif} {0}
set_instance_parameter_value endp0_reconfig {enable_offset} {1}
set_instance_parameter_value endp0_reconfig {gui_cal_status_port} {0}
set_instance_parameter_value endp0_reconfig {gui_enable_pll} {0}
set_instance_parameter_value endp0_reconfig {gui_split_sizes} {}
set_instance_parameter_value endp0_reconfig {number_of_reconfig_interfaces} {11}

add_instance fejkon_pcie_avalon fejkon_pcie_avalon 1.0

add_instance fejkon_pcie_data fejkon_pcie_data 1.0

add_instance intel_pcie_tlp_adapter intel_pcie_tlp_adapter 1.0

add_instance mm_mgmt_bfm altera_avalon_mm_master_bfm 20.1
set_instance_parameter_value mm_mgmt_bfm {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_ARBITERLOCK} {1}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_BYTEENABLE} {1}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_LOCK} {1}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_READ} {1}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_READDATAVALID} {1}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_RESET} {1}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_WAITREQUEST} {1}
set_instance_parameter_value mm_mgmt_bfm {ASSERT_HIGH_WRITE} {1}
set_instance_parameter_value mm_mgmt_bfm {AV_ADDRESS_W} {16}
set_instance_parameter_value mm_mgmt_bfm {AV_ALWAYS_BURST_MAX_BURST} {0}
set_instance_parameter_value mm_mgmt_bfm {AV_BURSTCOUNT_W} {3}
set_instance_parameter_value mm_mgmt_bfm {AV_BURST_BNDR_ONLY} {1}
set_instance_parameter_value mm_mgmt_bfm {AV_BURST_LINEWRAP} {1}
set_instance_parameter_value mm_mgmt_bfm {AV_CONSTANT_BURST_BEHAVIOR} {1}
set_instance_parameter_value mm_mgmt_bfm {AV_FIX_READ_LATENCY} {1}
set_instance_parameter_value mm_mgmt_bfm {AV_MAX_PENDING_READS} {0}
set_instance_parameter_value mm_mgmt_bfm {AV_MAX_PENDING_WRITES} {0}
set_instance_parameter_value mm_mgmt_bfm {AV_NUMSYMBOLS} {4}
set_instance_parameter_value mm_mgmt_bfm {AV_READRESPONSE_W} {8}
set_instance_parameter_value mm_mgmt_bfm {AV_READ_WAIT_TIME} {1}
set_instance_parameter_value mm_mgmt_bfm {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value mm_mgmt_bfm {AV_SYMBOL_W} {8}
set_instance_parameter_value mm_mgmt_bfm {AV_WRITERESPONSE_W} {8}
set_instance_parameter_value mm_mgmt_bfm {AV_WRITE_WAIT_TIME} {0}
set_instance_parameter_value mm_mgmt_bfm {REGISTER_WAITREQUEST} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_ADDRESS} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_ARBITERLOCK} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_BEGIN_BURST_TRANSFER} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_BEGIN_TRANSFER} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_BURSTCOUNT} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_BYTE_ENABLE} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_CLKEN} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_DEBUGACCESS} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_LOCK} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_READ} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_READRESPONSE} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_READ_DATA} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_READ_DATA_VALID} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_TRANSACTIONID} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_WAIT_REQUEST} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_WRITE} {1}
set_instance_parameter_value mm_mgmt_bfm {USE_WRITERESPONSE} {0}
set_instance_parameter_value mm_mgmt_bfm {USE_WRITE_DATA} {1}
set_instance_parameter_value mm_mgmt_bfm {VHDL_ID} {0}

add_instance mm_pcie_bfm altera_avalon_mm_slave_bfm 20.1
set_instance_parameter_value mm_pcie_bfm {ADDRESS_UNITS} {WORDS}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_ARBITERLOCK} {1}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_BYTEENABLE} {1}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_LOCK} {1}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_READ} {1}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_READDATAVALID} {1}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_RESET} {1}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_WAITREQUEST} {1}
set_instance_parameter_value mm_pcie_bfm {ASSERT_HIGH_WRITE} {1}
set_instance_parameter_value mm_pcie_bfm {AV_ADDRESS_W} {20}
set_instance_parameter_value mm_pcie_bfm {AV_BURSTCOUNT_W} {3}
set_instance_parameter_value mm_pcie_bfm {AV_BURST_BNDR_ONLY} {1}
set_instance_parameter_value mm_pcie_bfm {AV_BURST_LINEWRAP} {1}
set_instance_parameter_value mm_pcie_bfm {AV_FIX_READ_LATENCY} {0}
set_instance_parameter_value mm_pcie_bfm {AV_MAX_PENDING_READS} {1}
set_instance_parameter_value mm_pcie_bfm {AV_MAX_PENDING_WRITES} {0}
set_instance_parameter_value mm_pcie_bfm {AV_NUMSYMBOLS} {4}
set_instance_parameter_value mm_pcie_bfm {AV_READRESPONSE_W} {8}
set_instance_parameter_value mm_pcie_bfm {AV_READ_WAIT_TIME} {1}
set_instance_parameter_value mm_pcie_bfm {AV_REGISTERINCOMINGSIGNALS} {0}
set_instance_parameter_value mm_pcie_bfm {AV_SYMBOL_W} {8}
set_instance_parameter_value mm_pcie_bfm {AV_WRITERESPONSE_W} {8}
set_instance_parameter_value mm_pcie_bfm {AV_WRITE_WAIT_TIME} {0}
set_instance_parameter_value mm_pcie_bfm {REGISTER_WAITREQUEST} {0}
set_instance_parameter_value mm_pcie_bfm {USE_ADDRESS} {1}
set_instance_parameter_value mm_pcie_bfm {USE_ARBITERLOCK} {0}
set_instance_parameter_value mm_pcie_bfm {USE_BEGIN_BURST_TRANSFER} {0}
set_instance_parameter_value mm_pcie_bfm {USE_BEGIN_TRANSFER} {0}
set_instance_parameter_value mm_pcie_bfm {USE_BURSTCOUNT} {1}
set_instance_parameter_value mm_pcie_bfm {USE_BYTE_ENABLE} {1}
set_instance_parameter_value mm_pcie_bfm {USE_CLKEN} {0}
set_instance_parameter_value mm_pcie_bfm {USE_DEBUGACCESS} {0}
set_instance_parameter_value mm_pcie_bfm {USE_LOCK} {0}
set_instance_parameter_value mm_pcie_bfm {USE_READ} {1}
set_instance_parameter_value mm_pcie_bfm {USE_READRESPONSE} {0}
set_instance_parameter_value mm_pcie_bfm {USE_READ_DATA} {1}
set_instance_parameter_value mm_pcie_bfm {USE_READ_DATA_VALID} {1}
set_instance_parameter_value mm_pcie_bfm {USE_TRANSACTIONID} {0}
set_instance_parameter_value mm_pcie_bfm {USE_WAIT_REQUEST} {1}
set_instance_parameter_value mm_pcie_bfm {USE_WRITE} {1}
set_instance_parameter_value mm_pcie_bfm {USE_WRITERESPONSE} {0}
set_instance_parameter_value mm_pcie_bfm {USE_WRITE_DATA} {1}
set_instance_parameter_value mm_pcie_bfm {VHDL_ID} {0}

add_instance reset altera_avalon_reset_source 20.1
set_instance_parameter_value reset {ASSERT_HIGH_RESET} {0}
set_instance_parameter_value reset {INITIAL_RESET_CYCLES} {50}

add_instance root altera_pcie_tbed 20.1
set_instance_parameter_value root {apps_type_hwtcl} {3}
set_instance_parameter_value root {deemphasis_enable_hwtcl} {true}
set_instance_parameter_value root {ecrc_check_capable_hwtcl} {1}
set_instance_parameter_value root {ecrc_gen_capable_hwtcl} {1}
set_instance_parameter_value root {enable_pipe32_phyip_ser_driver_hwtcl} {0}
set_instance_parameter_value root {enable_pipe32_sim_hwtcl} {0}
set_instance_parameter_value root {enable_tl_only_sim_hwtcl} {0}
set_instance_parameter_value root {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value root {lane_mask_hwtcl} {x8}
set_instance_parameter_value root {millisecond_cycle_count_hwtcl} {248500}
set_instance_parameter_value root {pld_clk_MHz} {2500}
set_instance_parameter_value root {pll_refclk_freq_hwtcl} {100 MHz}
set_instance_parameter_value root {port_type_hwtcl} {Native endpoint}
set_instance_parameter_value root {serial_sim_hwtcl} {1}
set_instance_parameter_value root {use_crc_forwarding_hwtcl} {0}
set_instance_parameter_value root {use_stratixv_tb_device} {false}

add_instance tlp_data_fifo altera_avalon_sc_fifo 20.1
set_instance_parameter_value tlp_data_fifo {BITS_PER_SYMBOL} {32}
set_instance_parameter_value tlp_data_fifo {CHANNEL_WIDTH} {0}
set_instance_parameter_value tlp_data_fifo {EMPTY_LATENCY} {3}
set_instance_parameter_value tlp_data_fifo {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value tlp_data_fifo {ERROR_WIDTH} {0}
set_instance_parameter_value tlp_data_fifo {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value tlp_data_fifo {FIFO_DEPTH} {16}
set_instance_parameter_value tlp_data_fifo {SYMBOLS_PER_BEAT} {8}
set_instance_parameter_value tlp_data_fifo {USE_ALMOST_EMPTY_IF} {0}
set_instance_parameter_value tlp_data_fifo {USE_ALMOST_FULL_IF} {0}
set_instance_parameter_value tlp_data_fifo {USE_FILL_LEVEL} {0}
set_instance_parameter_value tlp_data_fifo {USE_MEMORY_BLOCKS} {1}
set_instance_parameter_value tlp_data_fifo {USE_PACKETS} {1}
set_instance_parameter_value tlp_data_fifo {USE_STORE_FORWARD} {0}

add_instance tlp_instant_fifo altera_avalon_sc_fifo 20.1
set_instance_parameter_value tlp_instant_fifo {BITS_PER_SYMBOL} {32}
set_instance_parameter_value tlp_instant_fifo {CHANNEL_WIDTH} {0}
set_instance_parameter_value tlp_instant_fifo {EMPTY_LATENCY} {3}
set_instance_parameter_value tlp_instant_fifo {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value tlp_instant_fifo {ERROR_WIDTH} {0}
set_instance_parameter_value tlp_instant_fifo {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value tlp_instant_fifo {FIFO_DEPTH} {16}
set_instance_parameter_value tlp_instant_fifo {SYMBOLS_PER_BEAT} {8}
set_instance_parameter_value tlp_instant_fifo {USE_ALMOST_EMPTY_IF} {0}
set_instance_parameter_value tlp_instant_fifo {USE_ALMOST_FULL_IF} {0}
set_instance_parameter_value tlp_instant_fifo {USE_FILL_LEVEL} {0}
set_instance_parameter_value tlp_instant_fifo {USE_MEMORY_BLOCKS} {1}
set_instance_parameter_value tlp_instant_fifo {USE_PACKETS} {1}
set_instance_parameter_value tlp_instant_fifo {USE_STORE_FORWARD} {0}

add_instance tlp_mux multiplexer 20.1
set_instance_parameter_value tlp_mux {bitsPerSymbol} {32}
set_instance_parameter_value tlp_mux {errorWidth} {0}
set_instance_parameter_value tlp_mux {numInputInterfaces} {3}
set_instance_parameter_value tlp_mux {outChannelWidth} {2}
set_instance_parameter_value tlp_mux {packetScheduling} {1}
set_instance_parameter_value tlp_mux {schedulingSize} {2}
set_instance_parameter_value tlp_mux {symbolsPerBeat} {8}
set_instance_parameter_value tlp_mux {useHighBitsOfChannel} {1}
set_instance_parameter_value tlp_mux {usePackets} {1}

add_instance tlp_response_fifo altera_avalon_sc_fifo 20.1
set_instance_parameter_value tlp_response_fifo {BITS_PER_SYMBOL} {32}
set_instance_parameter_value tlp_response_fifo {CHANNEL_WIDTH} {0}
set_instance_parameter_value tlp_response_fifo {EMPTY_LATENCY} {3}
set_instance_parameter_value tlp_response_fifo {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value tlp_response_fifo {ERROR_WIDTH} {0}
set_instance_parameter_value tlp_response_fifo {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value tlp_response_fifo {FIFO_DEPTH} {16}
set_instance_parameter_value tlp_response_fifo {SYMBOLS_PER_BEAT} {8}
set_instance_parameter_value tlp_response_fifo {USE_ALMOST_EMPTY_IF} {0}
set_instance_parameter_value tlp_response_fifo {USE_ALMOST_FULL_IF} {0}
set_instance_parameter_value tlp_response_fifo {USE_FILL_LEVEL} {0}
set_instance_parameter_value tlp_response_fifo {USE_MEMORY_BLOCKS} {1}
set_instance_parameter_value tlp_response_fifo {USE_PACKETS} {1}
set_instance_parameter_value tlp_response_fifo {USE_STORE_FORWARD} {0}

# exported interfaces
add_interface endp0_clk clock source
set_interface_property endp0_clk EXPORT_OF appclk.out_clk
add_interface endp0_hip_currentspeed conduit end
set_interface_property endp0_hip_currentspeed EXPORT_OF endp0.hip_currentspeed
add_interface endp0_hip_rst conduit end
set_interface_property endp0_hip_rst EXPORT_OF endp0.hip_rst
add_interface endp0_hip_status conduit end
set_interface_property endp0_hip_status EXPORT_OF endp0.hip_status
add_interface endp0_int_msi conduit end
set_interface_property endp0_int_msi EXPORT_OF endp0.int_msi
add_interface endp0_lmi conduit end
set_interface_property endp0_lmi EXPORT_OF endp0.lmi
add_interface endp0_power_mngt conduit end
set_interface_property endp0_power_mngt EXPORT_OF endp0.power_mngt
add_interface endp0_reconfig_busy conduit end
set_interface_property endp0_reconfig_busy EXPORT_OF endp0_reconfig.reconfig_busy
add_interface endp0_tx_cred conduit end
set_interface_property endp0_tx_cred EXPORT_OF endp0.tx_cred

# connections and connection parameters
add_connection clk.clk endp0_reconfig.mgmt_clk_clk

add_connection clk.clk reset.clk

add_connection data_bfm.src fejkon_pcie_data.data_tx

add_connection endp0.coreclkout_hip appclk.in_clk

add_connection endp0.coreclkout_hip data_bfm.clk

add_connection endp0.coreclkout_hip endp0.pld_clk

add_connection endp0.coreclkout_hip fejkon_pcie_avalon.clk

add_connection endp0.coreclkout_hip fejkon_pcie_data.clk

add_connection endp0.coreclkout_hip intel_pcie_tlp_adapter.clk

add_connection endp0.coreclkout_hip mm_mgmt_bfm.clk

add_connection endp0.coreclkout_hip mm_pcie_bfm.clk

add_connection endp0.coreclkout_hip tlp_data_fifo.clk

add_connection endp0.coreclkout_hip tlp_instant_fifo.clk

add_connection endp0.coreclkout_hip tlp_mux.clk

add_connection endp0.coreclkout_hip tlp_response_fifo.clk

add_connection endp0.reconfig_from_xcvr endp0_reconfig.reconfig_from_xcvr
set_connection_parameter_value endp0.reconfig_from_xcvr/endp0_reconfig.reconfig_from_xcvr endPort {}
set_connection_parameter_value endp0.reconfig_from_xcvr/endp0_reconfig.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value endp0.reconfig_from_xcvr/endp0_reconfig.reconfig_from_xcvr startPort {}
set_connection_parameter_value endp0.reconfig_from_xcvr/endp0_reconfig.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value endp0.reconfig_from_xcvr/endp0_reconfig.reconfig_from_xcvr width {0}

add_connection endp0.reconfig_to_xcvr endp0_reconfig.reconfig_to_xcvr
set_connection_parameter_value endp0.reconfig_to_xcvr/endp0_reconfig.reconfig_to_xcvr endPort {}
set_connection_parameter_value endp0.reconfig_to_xcvr/endp0_reconfig.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value endp0.reconfig_to_xcvr/endp0_reconfig.reconfig_to_xcvr startPort {}
set_connection_parameter_value endp0.reconfig_to_xcvr/endp0_reconfig.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value endp0.reconfig_to_xcvr/endp0_reconfig.reconfig_to_xcvr width {0}

add_connection endp0.rx_bar_be fejkon_pcie_data.rx_bar_be
set_connection_parameter_value endp0.rx_bar_be/fejkon_pcie_data.rx_bar_be endPort {}
set_connection_parameter_value endp0.rx_bar_be/fejkon_pcie_data.rx_bar_be endPortLSB {0}
set_connection_parameter_value endp0.rx_bar_be/fejkon_pcie_data.rx_bar_be startPort {}
set_connection_parameter_value endp0.rx_bar_be/fejkon_pcie_data.rx_bar_be startPortLSB {0}
set_connection_parameter_value endp0.rx_bar_be/fejkon_pcie_data.rx_bar_be width {0}

add_connection endp0.rx_st intel_pcie_tlp_adapter.phy_rx_st

add_connection fejkon_pcie_avalon.mem_access_resp fejkon_pcie_data.mem_access_resp

add_connection fejkon_pcie_avalon.mm mm_pcie_bfm.s0
set_connection_parameter_value fejkon_pcie_avalon.mm/mm_pcie_bfm.s0 arbitrationPriority {1}
set_connection_parameter_value fejkon_pcie_avalon.mm/mm_pcie_bfm.s0 baseAddress {0x0000}
set_connection_parameter_value fejkon_pcie_avalon.mm/mm_pcie_bfm.s0 defaultConnection {0}

add_connection fejkon_pcie_data.config_tl endp0.config_tl
set_connection_parameter_value fejkon_pcie_data.config_tl/endp0.config_tl endPort {}
set_connection_parameter_value fejkon_pcie_data.config_tl/endp0.config_tl endPortLSB {0}
set_connection_parameter_value fejkon_pcie_data.config_tl/endp0.config_tl startPort {}
set_connection_parameter_value fejkon_pcie_data.config_tl/endp0.config_tl startPortLSB {0}
set_connection_parameter_value fejkon_pcie_data.config_tl/endp0.config_tl width {0}

add_connection fejkon_pcie_data.mem_access_req fejkon_pcie_avalon.mem_access_req

add_connection fejkon_pcie_data.tlp_tx_data_st tlp_data_fifo.in

add_connection fejkon_pcie_data.tlp_tx_instant_st tlp_instant_fifo.in

add_connection fejkon_pcie_data.tlp_tx_response_st tlp_response_fifo.in

add_connection intel_pcie_tlp_adapter.phy_tx_st endp0.tx_st

add_connection intel_pcie_tlp_adapter.tlp_rx_st fejkon_pcie_data.tlp_rx_st

add_connection mm_mgmt_bfm.m0 endp0_reconfig.reconfig_mgmt
set_connection_parameter_value mm_mgmt_bfm.m0/endp0_reconfig.reconfig_mgmt arbitrationPriority {1}
set_connection_parameter_value mm_mgmt_bfm.m0/endp0_reconfig.reconfig_mgmt baseAddress {0x0000}
set_connection_parameter_value mm_mgmt_bfm.m0/endp0_reconfig.reconfig_mgmt defaultConnection {0}

add_connection mm_mgmt_bfm.m0 fejkon_pcie_data.csr
set_connection_parameter_value mm_mgmt_bfm.m0/fejkon_pcie_data.csr arbitrationPriority {1}
set_connection_parameter_value mm_mgmt_bfm.m0/fejkon_pcie_data.csr baseAddress {0x1000}
set_connection_parameter_value mm_mgmt_bfm.m0/fejkon_pcie_data.csr defaultConnection {0}

add_connection reset.reset data_bfm.clk_reset

add_connection reset.reset endp0_reconfig.mgmt_rst_reset

add_connection reset.reset fejkon_pcie_avalon.reset

add_connection reset.reset fejkon_pcie_data.reset

add_connection reset.reset intel_pcie_tlp_adapter.reset

add_connection reset.reset mm_mgmt_bfm.clk_reset

add_connection reset.reset mm_pcie_bfm.clk_reset

add_connection reset.reset tlp_data_fifo.clk_reset

add_connection reset.reset tlp_instant_fifo.clk_reset

add_connection reset.reset tlp_mux.reset

add_connection reset.reset tlp_response_fifo.clk_reset

add_connection root.hip_ctrl endp0.hip_ctrl
set_connection_parameter_value root.hip_ctrl/endp0.hip_ctrl endPort {}
set_connection_parameter_value root.hip_ctrl/endp0.hip_ctrl endPortLSB {0}
set_connection_parameter_value root.hip_ctrl/endp0.hip_ctrl startPort {}
set_connection_parameter_value root.hip_ctrl/endp0.hip_ctrl startPortLSB {0}
set_connection_parameter_value root.hip_ctrl/endp0.hip_ctrl width {0}

add_connection root.hip_pipe endp0.hip_pipe
set_connection_parameter_value root.hip_pipe/endp0.hip_pipe endPort {}
set_connection_parameter_value root.hip_pipe/endp0.hip_pipe endPortLSB {0}
set_connection_parameter_value root.hip_pipe/endp0.hip_pipe startPort {}
set_connection_parameter_value root.hip_pipe/endp0.hip_pipe startPortLSB {0}
set_connection_parameter_value root.hip_pipe/endp0.hip_pipe width {0}

add_connection root.hip_serial endp0.hip_serial
set_connection_parameter_value root.hip_serial/endp0.hip_serial endPort {}
set_connection_parameter_value root.hip_serial/endp0.hip_serial endPortLSB {0}
set_connection_parameter_value root.hip_serial/endp0.hip_serial startPort {}
set_connection_parameter_value root.hip_serial/endp0.hip_serial startPortLSB {0}
set_connection_parameter_value root.hip_serial/endp0.hip_serial width {0}

add_connection root.npor endp0.npor
set_connection_parameter_value root.npor/endp0.npor endPort {}
set_connection_parameter_value root.npor/endp0.npor endPortLSB {0}
set_connection_parameter_value root.npor/endp0.npor startPort {}
set_connection_parameter_value root.npor/endp0.npor startPortLSB {0}
set_connection_parameter_value root.npor/endp0.npor width {0}

add_connection root.refclk endp0.refclk

add_connection tlp_data_fifo.out tlp_mux.in0

add_connection tlp_instant_fifo.out tlp_mux.in2

add_connection tlp_mux.out intel_pcie_tlp_adapter.tlp_tx_st

add_connection tlp_response_fifo.out tlp_mux.in1

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {svpcie_sim_tb.qsys}
