# qsys scripting (.tcl) file for fejkon_pcie
package require -exact qsys 16.0

create_system {fejkon_pcie}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance bar0_cdc altera_avalon_mm_clock_crossing_bridge 19.1
set_instance_parameter_value bar0_cdc {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value bar0_cdc {ADDRESS_WIDTH} {20}
set_instance_parameter_value bar0_cdc {COMMAND_FIFO_DEPTH} {4}
set_instance_parameter_value bar0_cdc {DATA_WIDTH} {32}
set_instance_parameter_value bar0_cdc {MASTER_SYNC_DEPTH} {2}
set_instance_parameter_value bar0_cdc {MAX_BURST_SIZE} {1}
set_instance_parameter_value bar0_cdc {RESPONSE_FIFO_DEPTH} {4}
set_instance_parameter_value bar0_cdc {SLAVE_SYNC_DEPTH} {2}
set_instance_parameter_value bar0_cdc {SYMBOL_WIDTH} {8}
set_instance_parameter_value bar0_cdc {USE_AUTO_ADDRESS_WIDTH} {0}

add_instance mem_req_fifo altera_avalon_sc_fifo 19.1
set_instance_parameter_value mem_req_fifo {BITS_PER_SYMBOL} {128}
set_instance_parameter_value mem_req_fifo {CHANNEL_WIDTH} {0}
set_instance_parameter_value mem_req_fifo {EMPTY_LATENCY} {3}
set_instance_parameter_value mem_req_fifo {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value mem_req_fifo {ERROR_WIDTH} {0}
set_instance_parameter_value mem_req_fifo {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value mem_req_fifo {FIFO_DEPTH} {64}
set_instance_parameter_value mem_req_fifo {SYMBOLS_PER_BEAT} {1}
set_instance_parameter_value mem_req_fifo {USE_ALMOST_EMPTY_IF} {0}
set_instance_parameter_value mem_req_fifo {USE_ALMOST_FULL_IF} {0}
set_instance_parameter_value mem_req_fifo {USE_FILL_LEVEL} {0}
set_instance_parameter_value mem_req_fifo {USE_MEMORY_BLOCKS} {1}
set_instance_parameter_value mem_req_fifo {USE_PACKETS} {0}
set_instance_parameter_value mem_req_fifo {USE_STORE_FORWARD} {0}

add_instance mem_resp_fifo altera_avalon_sc_fifo 19.1
set_instance_parameter_value mem_resp_fifo {BITS_PER_SYMBOL} {128}
set_instance_parameter_value mem_resp_fifo {CHANNEL_WIDTH} {0}
set_instance_parameter_value mem_resp_fifo {EMPTY_LATENCY} {3}
set_instance_parameter_value mem_resp_fifo {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value mem_resp_fifo {ERROR_WIDTH} {0}
set_instance_parameter_value mem_resp_fifo {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value mem_resp_fifo {FIFO_DEPTH} {64}
set_instance_parameter_value mem_resp_fifo {SYMBOLS_PER_BEAT} {1}
set_instance_parameter_value mem_resp_fifo {USE_ALMOST_EMPTY_IF} {0}
set_instance_parameter_value mem_resp_fifo {USE_ALMOST_FULL_IF} {0}
set_instance_parameter_value mem_resp_fifo {USE_FILL_LEVEL} {0}
set_instance_parameter_value mem_resp_fifo {USE_MEMORY_BLOCKS} {1}
set_instance_parameter_value mem_resp_fifo {USE_PACKETS} {0}
set_instance_parameter_value mem_resp_fifo {USE_STORE_FORWARD} {0}

add_instance mgmt_clk altera_clock_bridge 19.1
set_instance_parameter_value mgmt_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value mgmt_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance mgmt_rst altera_reset_bridge 19.1
set_instance_parameter_value mgmt_rst {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value mgmt_rst {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value mgmt_rst {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value mgmt_rst {USE_RESET_REQUEST} {0}

add_instance msi_intr pcie_msi_intr 1.0

add_instance pcie_avalon fejkon_pcie_avalon 1.0

add_instance pcie_clk altera_clock_bridge 19.1
set_instance_parameter_value pcie_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value pcie_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance pcie_data fejkon_pcie_data 1.0

add_instance pcie_reconfig altera_pcie_reconfig_driver 19.1
set_instance_parameter_value pcie_reconfig {enable_cal_busy_hwtcl} {0}
set_instance_parameter_value pcie_reconfig {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value pcie_reconfig {number_of_reconfig_interfaces} {11}

add_instance pcie_reset pcie_reset 1.0

add_instance phy altera_pcie_sv_hip_ast 19.1
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
set_instance_parameter_value phy {ast_width_hwtcl} {Avalon-ST 256-bit}
set_instance_parameter_value phy {bar0_size_mask_hwtcl} {19}
set_instance_parameter_value phy {bar0_type_hwtcl} {1}
set_instance_parameter_value phy {bar1_size_mask_hwtcl} {0}
set_instance_parameter_value phy {bar1_type_hwtcl} {0}
set_instance_parameter_value phy {bar2_size_mask_hwtcl} {0}
set_instance_parameter_value phy {bar2_type_hwtcl} {0}
set_instance_parameter_value phy {bar3_size_mask_hwtcl} {0}
set_instance_parameter_value phy {bar3_type_hwtcl} {0}
set_instance_parameter_value phy {bar4_size_mask_hwtcl} {0}
set_instance_parameter_value phy {bar4_type_hwtcl} {0}
set_instance_parameter_value phy {bar5_size_mask_hwtcl} {0}
set_instance_parameter_value phy {bar5_type_hwtcl} {0}
set_instance_parameter_value phy {change_deemphasis_hwtcl} {1}
set_instance_parameter_value phy {class_code_hwtcl} {787456}
set_instance_parameter_value phy {completion_timeout_hwtcl} {ABCD}
set_instance_parameter_value phy {device_id_hwtcl} {3557}
set_instance_parameter_value phy {dll_active_report_support_hwtcl} {0}
set_instance_parameter_value phy {ecrc_check_capable_hwtcl} {0}
set_instance_parameter_value phy {ecrc_gen_capable_hwtcl} {0}
set_instance_parameter_value phy {enable_completion_timeout_disable_hwtcl} {1}
set_instance_parameter_value phy {enable_function_msix_support_hwtcl} {0}
set_instance_parameter_value phy {enable_pcisigtest_hwtcl} {0}
set_instance_parameter_value phy {enable_pipe32_phyip_ser_driver_hwtcl} {0}
set_instance_parameter_value phy {enable_pipe32_sim_hwtcl} {0}
set_instance_parameter_value phy {enable_power_on_rst_pulse_hwtcl} {0}
set_instance_parameter_value phy {enable_slot_register_hwtcl} {0}
set_instance_parameter_value phy {enable_tl_only_sim_hwtcl} {0}
set_instance_parameter_value phy {endpoint_l0_latency_hwtcl} {0}
set_instance_parameter_value phy {endpoint_l1_latency_hwtcl} {0}
set_instance_parameter_value phy {expansion_base_address_register_hwtcl} {0}
set_instance_parameter_value phy {extend_tag_field_hwtcl} {32}
set_instance_parameter_value phy {fixed_preset_on} {0}
set_instance_parameter_value phy {force_hrc} {0}
set_instance_parameter_value phy {force_src} {0}
set_instance_parameter_value phy {full_swing_hwtcl} {35}
set_instance_parameter_value phy {gen123_lane_rate_mode_hwtcl} {Gen3 (8.0 Gbps)}
set_instance_parameter_value phy {gen3_coeff_10_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_10_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_10_nxtber_less_hwtcl} {g3_coeff_10_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_10_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_10_nxtber_more_hwtcl} {g3_coeff_10_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_10_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_10_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_10_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_10_sel_hwtcl} {preset_10}
set_instance_parameter_value phy {gen3_coeff_11_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_11_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_11_nxtber_less_hwtcl} {g3_coeff_11_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_11_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_11_nxtber_more_hwtcl} {g3_coeff_11_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_11_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_11_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_11_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_11_sel_hwtcl} {preset_11}
set_instance_parameter_value phy {gen3_coeff_12_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_12_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_12_nxtber_less_hwtcl} {g3_coeff_12_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_12_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_12_nxtber_more_hwtcl} {g3_coeff_12_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_12_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_12_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_12_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_12_sel_hwtcl} {preset_12}
set_instance_parameter_value phy {gen3_coeff_13_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_13_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_13_nxtber_less_hwtcl} {g3_coeff_13_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_13_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_13_nxtber_more_hwtcl} {g3_coeff_13_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_13_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_13_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_13_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_13_sel_hwtcl} {preset_13}
set_instance_parameter_value phy {gen3_coeff_14_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_14_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_14_nxtber_less_hwtcl} {g3_coeff_14_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_14_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_14_nxtber_more_hwtcl} {g3_coeff_14_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_14_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_14_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_14_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_14_sel_hwtcl} {preset_14}
set_instance_parameter_value phy {gen3_coeff_15_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_15_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_15_nxtber_less_hwtcl} {g3_coeff_15_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_15_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_15_nxtber_more_hwtcl} {g3_coeff_15_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_15_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_15_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_15_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_15_sel_hwtcl} {preset_15}
set_instance_parameter_value phy {gen3_coeff_16_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_16_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_16_nxtber_less_hwtcl} {g3_coeff_16_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_16_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_16_nxtber_more_hwtcl} {g3_coeff_16_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_16_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_16_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_16_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_16_sel_hwtcl} {preset_16}
set_instance_parameter_value phy {gen3_coeff_17_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_17_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_17_nxtber_less_hwtcl} {g3_coeff_17_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_17_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_17_nxtber_more_hwtcl} {g3_coeff_17_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_17_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_17_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_17_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_17_sel_hwtcl} {preset_17}
set_instance_parameter_value phy {gen3_coeff_18_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_18_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_18_nxtber_less_hwtcl} {g3_coeff_18_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_18_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_18_nxtber_more_hwtcl} {g3_coeff_18_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_18_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_18_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_18_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_18_sel_hwtcl} {preset_18}
set_instance_parameter_value phy {gen3_coeff_19_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_19_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_19_nxtber_less_hwtcl} {g3_coeff_19_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_19_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_19_nxtber_more_hwtcl} {g3_coeff_19_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_19_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_19_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_19_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_19_sel_hwtcl} {preset_19}
set_instance_parameter_value phy {gen3_coeff_1_ber_meas_hwtcl} {2}
set_instance_parameter_value phy {gen3_coeff_1_hwtcl} {7}
set_instance_parameter_value phy {gen3_coeff_1_nxtber_less_hwtcl} {g3_coeff_1_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_1_nxtber_less_ptr_hwtcl} {1}
set_instance_parameter_value phy {gen3_coeff_1_nxtber_more_hwtcl} {g3_coeff_1_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_1_nxtber_more_ptr_hwtcl} {1}
set_instance_parameter_value phy {gen3_coeff_1_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_1_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_1_sel_hwtcl} {preset_1}
set_instance_parameter_value phy {gen3_coeff_20_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_20_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_20_nxtber_less_hwtcl} {g3_coeff_20_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_20_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_20_nxtber_more_hwtcl} {g3_coeff_20_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_20_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_20_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_20_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_20_sel_hwtcl} {preset_20}
set_instance_parameter_value phy {gen3_coeff_21_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_21_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_21_nxtber_less_hwtcl} {g3_coeff_21_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_21_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_21_nxtber_more_hwtcl} {g3_coeff_21_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_21_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_21_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_21_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_21_sel_hwtcl} {preset_21}
set_instance_parameter_value phy {gen3_coeff_22_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_22_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_22_nxtber_less_hwtcl} {g3_coeff_22_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_22_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_22_nxtber_more_hwtcl} {g3_coeff_22_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_22_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_22_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_22_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_22_sel_hwtcl} {preset_22}
set_instance_parameter_value phy {gen3_coeff_23_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_23_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_23_nxtber_less_hwtcl} {g3_coeff_23_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_23_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_23_nxtber_more_hwtcl} {g3_coeff_23_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_23_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_23_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_23_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_23_sel_hwtcl} {preset_23}
set_instance_parameter_value phy {gen3_coeff_24_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_24_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_24_nxtber_less_hwtcl} {g3_coeff_24_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_24_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_24_nxtber_more_hwtcl} {g3_coeff_24_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_24_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_24_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_24_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_24_sel_hwtcl} {preset_24}
set_instance_parameter_value phy {gen3_coeff_2_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_2_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_2_nxtber_less_hwtcl} {g3_coeff_2_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_2_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_2_nxtber_more_hwtcl} {g3_coeff_2_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_2_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_2_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_2_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_2_sel_hwtcl} {preset_2}
set_instance_parameter_value phy {gen3_coeff_3_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_3_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_3_nxtber_less_hwtcl} {g3_coeff_3_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_3_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_3_nxtber_more_hwtcl} {g3_coeff_3_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_3_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_3_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_3_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_3_sel_hwtcl} {preset_3}
set_instance_parameter_value phy {gen3_coeff_4_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_4_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_4_nxtber_less_hwtcl} {g3_coeff_4_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_4_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_4_nxtber_more_hwtcl} {g3_coeff_4_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_4_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_4_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_4_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_4_sel_hwtcl} {preset_4}
set_instance_parameter_value phy {gen3_coeff_5_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_5_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_5_nxtber_less_hwtcl} {g3_coeff_5_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_5_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_5_nxtber_more_hwtcl} {g3_coeff_5_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_5_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_5_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_5_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_5_sel_hwtcl} {preset_5}
set_instance_parameter_value phy {gen3_coeff_6_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_6_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_6_nxtber_less_hwtcl} {g3_coeff_6_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_6_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_6_nxtber_more_hwtcl} {g3_coeff_6_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_6_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_6_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_6_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_6_sel_hwtcl} {preset_6}
set_instance_parameter_value phy {gen3_coeff_7_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_7_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_7_nxtber_less_hwtcl} {g3_coeff_7_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_7_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_7_nxtber_more_hwtcl} {g3_coeff_7_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_7_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_7_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_7_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_7_sel_hwtcl} {preset_7}
set_instance_parameter_value phy {gen3_coeff_8_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_8_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_8_nxtber_less_hwtcl} {g3_coeff_8_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_8_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_8_nxtber_more_hwtcl} {g3_coeff_8_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_8_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_8_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_8_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_8_sel_hwtcl} {preset_8}
set_instance_parameter_value phy {gen3_coeff_9_ber_meas_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_9_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_9_nxtber_less_hwtcl} {g3_coeff_9_nxtber_less}
set_instance_parameter_value phy {gen3_coeff_9_nxtber_less_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_9_nxtber_more_hwtcl} {g3_coeff_9_nxtber_more}
set_instance_parameter_value phy {gen3_coeff_9_nxtber_more_ptr_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_9_preset_hint_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_9_reqber_hwtcl} {0}
set_instance_parameter_value phy {gen3_coeff_9_sel_hwtcl} {preset_9}
set_instance_parameter_value phy {gen3_full_swing_hwtcl} {35}
set_instance_parameter_value phy {gen3_low_freq_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_10_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_11_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_1_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_2_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_3_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_4_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_5_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_6_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_7_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_8_hwtcl} {0}
set_instance_parameter_value phy {gen3_preset_coeff_9_hwtcl} {0}
set_instance_parameter_value phy {gen3_rxfreqlock_counter_hwtcl} {0}
set_instance_parameter_value phy {hip_reconfig_hwtcl} {0}
set_instance_parameter_value phy {hip_tag_checking_hwtcl} {1}
set_instance_parameter_value phy {hwtcl_override_g2_txvod} {1}
set_instance_parameter_value phy {hwtcl_override_g3rxcoef} {0}
set_instance_parameter_value phy {hwtcl_override_g3txcoef} {0}
set_instance_parameter_value phy {in_cvp_mode_hwtcl} {0}
set_instance_parameter_value phy {io_window_addr_width_hwtcl} {0}
set_instance_parameter_value phy {lane_mask_hwtcl} {x8}
set_instance_parameter_value phy {low_latency_mode_hwtcl} {0}
set_instance_parameter_value phy {max_payload_size_hwtcl} {128}
set_instance_parameter_value phy {msi_64bit_addressing_capable_hwtcl} {true}
set_instance_parameter_value phy {msi_masking_capable_hwtcl} {false}
set_instance_parameter_value phy {msi_multi_message_capable_hwtcl} {32}
set_instance_parameter_value phy {msi_support_hwtcl} {true}
set_instance_parameter_value phy {msix_pba_bir_hwtcl} {0}
set_instance_parameter_value phy {msix_pba_offset_hwtcl} {0.0}
set_instance_parameter_value phy {msix_table_bir_hwtcl} {0}
set_instance_parameter_value phy {msix_table_offset_hwtcl} {0.0}
set_instance_parameter_value phy {msix_table_size_hwtcl} {0}
set_instance_parameter_value phy {multiple_packets_per_cycle_hwtcl} {0}
set_instance_parameter_value phy {override_rxbuffer_cred_preset} {0}
set_instance_parameter_value phy {override_tbpartner_driver_setting_hwtcl} {0}
set_instance_parameter_value phy {pcie_inspector_hwtcl} {0}
set_instance_parameter_value phy {pcie_qsys} {1}
set_instance_parameter_value phy {pcie_spec_version_hwtcl} {3.0}
set_instance_parameter_value phy {pll_refclk_freq_hwtcl} {100 MHz}
set_instance_parameter_value phy {port_link_number_hwtcl} {1}
set_instance_parameter_value phy {port_type_hwtcl} {Native endpoint}
set_instance_parameter_value phy {prefetchable_mem_window_addr_width_hwtcl} {0}
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
set_instance_parameter_value phy {rxbuffer_rxreq_hwtcl} {Balanced}
set_instance_parameter_value phy {serial_sim_hwtcl} {1}
set_instance_parameter_value phy {set_pld_clk_x1_625MHz_hwtcl} {0}
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
set_instance_parameter_value phy {track_rxfc_cplbuf_ovf_hwtcl} {0}
set_instance_parameter_value phy {use_aer_hwtcl} {0}
set_instance_parameter_value phy {use_ast_parity} {0}
set_instance_parameter_value phy {use_atx_pll_hwtcl} {0}
set_instance_parameter_value phy {use_config_bypass_hwtcl} {0}
set_instance_parameter_value phy {use_crc_forwarding_hwtcl} {0}
set_instance_parameter_value phy {use_cvp_update_core_pof_hwtcl} {0}
set_instance_parameter_value phy {use_pci_ext_hwtcl} {0}
set_instance_parameter_value phy {use_pcie_ext_hwtcl} {0}
set_instance_parameter_value phy {use_rx_st_be_hwtcl} {0}
set_instance_parameter_value phy {use_tx_cons_cred_sel_hwtcl} {1}
set_instance_parameter_value phy {user_id_hwtcl} {0}
set_instance_parameter_value phy {vendor_id_hwtcl} {61888}
set_instance_parameter_value phy {vsec_id_hwtcl} {4466}
set_instance_parameter_value phy {vsec_rev_hwtcl} {0}

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
set_instance_parameter_value xcvr_reconfig {gui_split_sizes} {}
set_instance_parameter_value xcvr_reconfig {number_of_reconfig_interfaces} {11}

# exported interfaces
add_interface bar0_mm avalon master
set_interface_property bar0_mm EXPORT_OF bar0_cdc.m0
add_interface data_clk clock source
set_interface_property data_clk EXPORT_OF pcie_clk.out_clk
add_interface data_tx avalon_streaming sink
set_interface_property data_tx EXPORT_OF pcie_data.data_tx
add_interface irq interrupt receiver
set_interface_property irq EXPORT_OF msi_intr.irq
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

# connections and connection parameters
add_connection mem_req_fifo.out pcie_avalon.mem_access_req

add_connection mem_resp_fifo.out pcie_data.mem_access_resp

add_connection mgmt_clk.out_clk bar0_cdc.m0_clk

add_connection mgmt_clk.out_clk mgmt_rst.clk

add_connection mgmt_clk.out_clk pcie_reconfig.pld_clk

add_connection mgmt_clk.out_clk pcie_reconfig.reconfig_xcvr_clk

add_connection mgmt_clk.out_clk pcie_reset.clk

add_connection mgmt_clk.out_clk xcvr_reconfig.mgmt_clk_clk

add_connection mgmt_rst.out_reset bar0_cdc.m0_reset

add_connection mgmt_rst.out_reset bar0_cdc.s0_reset

add_connection mgmt_rst.out_reset mem_req_fifo.clk_reset

add_connection mgmt_rst.out_reset mem_resp_fifo.clk_reset

add_connection mgmt_rst.out_reset msi_intr.reset

add_connection mgmt_rst.out_reset pcie_avalon.reset

add_connection mgmt_rst.out_reset pcie_data.reset

add_connection mgmt_rst.out_reset pcie_reconfig.reconfig_xcvr_rst

add_connection mgmt_rst.out_reset pcie_reset.reset

add_connection mgmt_rst.out_reset xcvr_reconfig.mgmt_rst_reset

add_connection pcie_avalon.mem_access_resp mem_resp_fifo.in

add_connection pcie_avalon.mm bar0_cdc.s0
set_connection_parameter_value pcie_avalon.mm/bar0_cdc.s0 arbitrationPriority {1}
set_connection_parameter_value pcie_avalon.mm/bar0_cdc.s0 baseAddress {0x0000}
set_connection_parameter_value pcie_avalon.mm/bar0_cdc.s0 defaultConnection {0}

add_connection pcie_data.mem_access_req mem_req_fifo.in

add_connection pcie_data.tx_st phy.tx_st

add_connection pcie_reconfig.hip_status_drv phy.hip_status
set_connection_parameter_value pcie_reconfig.hip_status_drv/phy.hip_status endPort {}
set_connection_parameter_value pcie_reconfig.hip_status_drv/phy.hip_status endPortLSB {0}
set_connection_parameter_value pcie_reconfig.hip_status_drv/phy.hip_status startPort {}
set_connection_parameter_value pcie_reconfig.hip_status_drv/phy.hip_status startPortLSB {0}
set_connection_parameter_value pcie_reconfig.hip_status_drv/phy.hip_status width {0}

add_connection pcie_reconfig.reconfig_busy xcvr_reconfig.reconfig_busy
set_connection_parameter_value pcie_reconfig.reconfig_busy/xcvr_reconfig.reconfig_busy endPort {}
set_connection_parameter_value pcie_reconfig.reconfig_busy/xcvr_reconfig.reconfig_busy endPortLSB {0}
set_connection_parameter_value pcie_reconfig.reconfig_busy/xcvr_reconfig.reconfig_busy startPort {}
set_connection_parameter_value pcie_reconfig.reconfig_busy/xcvr_reconfig.reconfig_busy startPortLSB {0}
set_connection_parameter_value pcie_reconfig.reconfig_busy/xcvr_reconfig.reconfig_busy width {0}

add_connection pcie_reconfig.reconfig_mgmt xcvr_reconfig.reconfig_mgmt
set_connection_parameter_value pcie_reconfig.reconfig_mgmt/xcvr_reconfig.reconfig_mgmt arbitrationPriority {1}
set_connection_parameter_value pcie_reconfig.reconfig_mgmt/xcvr_reconfig.reconfig_mgmt baseAddress {0x0000}
set_connection_parameter_value pcie_reconfig.reconfig_mgmt/xcvr_reconfig.reconfig_mgmt defaultConnection {0}

add_connection pcie_reset.npor phy.npor
set_connection_parameter_value pcie_reset.npor/phy.npor endPort {}
set_connection_parameter_value pcie_reset.npor/phy.npor endPortLSB {0}
set_connection_parameter_value pcie_reset.npor/phy.npor startPort {}
set_connection_parameter_value pcie_reset.npor/phy.npor startPortLSB {0}
set_connection_parameter_value pcie_reset.npor/phy.npor width {0}

add_connection phy.coreclkout_hip bar0_cdc.s0_clk

add_connection phy.coreclkout_hip mem_req_fifo.clk

add_connection phy.coreclkout_hip mem_resp_fifo.clk

add_connection phy.coreclkout_hip msi_intr.clk

add_connection phy.coreclkout_hip pcie_avalon.clk

add_connection phy.coreclkout_hip pcie_clk.in_clk

add_connection phy.coreclkout_hip pcie_data.clk

add_connection phy.coreclkout_hip phy.pld_clk

add_connection phy.hip_currentspeed pcie_reconfig.hip_currentspeed
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig.hip_currentspeed endPort {}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig.hip_currentspeed endPortLSB {0}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig.hip_currentspeed startPort {}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig.hip_currentspeed startPortLSB {0}
set_connection_parameter_value phy.hip_currentspeed/pcie_reconfig.hip_currentspeed width {0}

add_connection phy.int_msi msi_intr.int_msi
set_connection_parameter_value phy.int_msi/msi_intr.int_msi endPort {}
set_connection_parameter_value phy.int_msi/msi_intr.int_msi endPortLSB {0}
set_connection_parameter_value phy.int_msi/msi_intr.int_msi startPort {}
set_connection_parameter_value phy.int_msi/msi_intr.int_msi startPortLSB {0}
set_connection_parameter_value phy.int_msi/msi_intr.int_msi width {0}

add_connection phy.rx_bar_be pcie_data.rx_bar_be
set_connection_parameter_value phy.rx_bar_be/pcie_data.rx_bar_be endPort {}
set_connection_parameter_value phy.rx_bar_be/pcie_data.rx_bar_be endPortLSB {0}
set_connection_parameter_value phy.rx_bar_be/pcie_data.rx_bar_be startPort {}
set_connection_parameter_value phy.rx_bar_be/pcie_data.rx_bar_be startPortLSB {0}
set_connection_parameter_value phy.rx_bar_be/pcie_data.rx_bar_be width {0}

add_connection phy.rx_st pcie_data.rx_st

add_connection xcvr_reconfig.reconfig_from_xcvr phy.reconfig_from_xcvr
set_connection_parameter_value xcvr_reconfig.reconfig_from_xcvr/phy.reconfig_from_xcvr endPort {}
set_connection_parameter_value xcvr_reconfig.reconfig_from_xcvr/phy.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvr_reconfig.reconfig_from_xcvr/phy.reconfig_from_xcvr startPort {}
set_connection_parameter_value xcvr_reconfig.reconfig_from_xcvr/phy.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvr_reconfig.reconfig_from_xcvr/phy.reconfig_from_xcvr width {0}

add_connection xcvr_reconfig.reconfig_to_xcvr phy.reconfig_to_xcvr
set_connection_parameter_value xcvr_reconfig.reconfig_to_xcvr/phy.reconfig_to_xcvr endPort {}
set_connection_parameter_value xcvr_reconfig.reconfig_to_xcvr/phy.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value xcvr_reconfig.reconfig_to_xcvr/phy.reconfig_to_xcvr startPort {}
set_connection_parameter_value xcvr_reconfig.reconfig_to_xcvr/phy.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value xcvr_reconfig.reconfig_to_xcvr/phy.reconfig_to_xcvr width {0}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.enableInstrumentation} {TRUE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {dma_descr.s1} {qsys_mm.insertPerformanceMonitor} {FALSE}
set_interconnect_requirement {dma_descr.s2} {qsys_mm.insertPerformanceMonitor} {FALSE}
set_interconnect_requirement {dma_rd_pipeline.m0} {qsys_mm.insertPerformanceMonitor} {FALSE}
set_interconnect_requirement {dma_wr_pipeline.m0} {qsys_mm.insertPerformanceMonitor} {FALSE}
set_interconnect_requirement {phy.dma_rd_master} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {phy.dma_wr_master} {qsys_mm.insertPerformanceMonitor} {TRUE}

save_system {fejkon_pcie.qsys}
