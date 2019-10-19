# qsys scripting (.tcl) file for fejkon
package require -exact qsys 16.0

create_system {fejkon}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance ext0 clock_source 19.1
set_instance_parameter_value ext0 {clockFrequency} {50000000.0}
set_instance_parameter_value ext0 {clockFrequencyKnown} {1}
set_instance_parameter_value ext0 {resetSynchronousEdges} {NONE}

add_instance fcport0 fejkon_fcport 1.0

add_instance ident fejkon_identity 1.0

add_instance jtagm altera_jtag_avalon_master 19.1
set_instance_parameter_value jtagm {FAST_VER} {0}
set_instance_parameter_value jtagm {FIFO_DEPTHS} {2}
set_instance_parameter_value jtagm {PLI_PORT} {50000}
set_instance_parameter_value jtagm {USE_PLI} {0}

add_instance led altera_avalon_pio 19.1
set_instance_parameter_value led {bitClearingEdgeCapReg} {0}
set_instance_parameter_value led {bitModifyingOutReg} {0}
set_instance_parameter_value led {captureEdge} {0}
set_instance_parameter_value led {direction} {Output}
set_instance_parameter_value led {edgeType} {RISING}
set_instance_parameter_value led {generateIRQ} {0}
set_instance_parameter_value led {irqType} {LEVEL}
set_instance_parameter_value led {resetValue} {10.0}
set_instance_parameter_value led {simDoTestBenchWiring} {0}
set_instance_parameter_value led {simDrivenValue} {0.0}
set_instance_parameter_value led {width} {4}

add_instance pcie fejkon_pcie 1.0

add_instance phy_pll altera_pll 19.1
set_instance_parameter_value phy_pll {debug_print_output} {0}
set_instance_parameter_value phy_pll {debug_use_rbc_taf_method} {0}
set_instance_parameter_value phy_pll {gui_active_clk} {0}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency0} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency1} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency10} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency11} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency12} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency13} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency14} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency15} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency16} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency17} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency2} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency3} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency4} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency5} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency6} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency7} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency8} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_output_clock_frequency9} {0 MHz}
set_instance_parameter_value phy_pll {gui_actual_phase_shift0} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift1} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift10} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift11} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift12} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift13} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift14} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift15} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift16} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift17} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift2} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift3} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift4} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift5} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift6} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift7} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift8} {0}
set_instance_parameter_value phy_pll {gui_actual_phase_shift9} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter0} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter1} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter10} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter11} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter12} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter13} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter14} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter15} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter16} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter17} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter2} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter3} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter4} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter5} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter6} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter7} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter8} {0}
set_instance_parameter_value phy_pll {gui_cascade_counter9} {0}
set_instance_parameter_value phy_pll {gui_cascade_outclk_index} {0}
set_instance_parameter_value phy_pll {gui_channel_spacing} {0.0}
set_instance_parameter_value phy_pll {gui_clk_bad} {0}
set_instance_parameter_value phy_pll {gui_device_speed_grade} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c0} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c1} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c10} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c11} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c12} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c13} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c14} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c15} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c16} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c17} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c2} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c3} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c4} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c5} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c6} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c7} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c8} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_c9} {1}
set_instance_parameter_value phy_pll {gui_divide_factor_n} {1}
set_instance_parameter_value phy_pll {gui_dps_cntr} {C0}
set_instance_parameter_value phy_pll {gui_dps_dir} {Positive}
set_instance_parameter_value phy_pll {gui_dps_num} {1}
set_instance_parameter_value phy_pll {gui_dsm_out_sel} {1st_order}
set_instance_parameter_value phy_pll {gui_duty_cycle0} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle1} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle10} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle11} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle12} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle13} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle14} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle15} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle16} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle17} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle2} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle3} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle4} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle5} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle6} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle7} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle8} {50}
set_instance_parameter_value phy_pll {gui_duty_cycle9} {50}
set_instance_parameter_value phy_pll {gui_en_adv_params} {0}
set_instance_parameter_value phy_pll {gui_en_dps_ports} {0}
set_instance_parameter_value phy_pll {gui_en_phout_ports} {0}
set_instance_parameter_value phy_pll {gui_en_reconf} {0}
set_instance_parameter_value phy_pll {gui_enable_cascade_in} {0}
set_instance_parameter_value phy_pll {gui_enable_cascade_out} {0}
set_instance_parameter_value phy_pll {gui_enable_mif_dps} {0}
set_instance_parameter_value phy_pll {gui_feedback_clock} {Global Clock}
set_instance_parameter_value phy_pll {gui_frac_multiply_factor} {1.0}
set_instance_parameter_value phy_pll {gui_fractional_cout} {32}
set_instance_parameter_value phy_pll {gui_mif_generate} {0}
set_instance_parameter_value phy_pll {gui_multiply_factor} {1}
set_instance_parameter_value phy_pll {gui_number_of_clocks} {1}
set_instance_parameter_value phy_pll {gui_operation_mode} {direct}
set_instance_parameter_value phy_pll {gui_output_clock_frequency0} {106.25}
set_instance_parameter_value phy_pll {gui_output_clock_frequency1} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency10} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency11} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency12} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency13} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency14} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency15} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency16} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency17} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency2} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency3} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency4} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency5} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency6} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency7} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency8} {100.0}
set_instance_parameter_value phy_pll {gui_output_clock_frequency9} {100.0}
set_instance_parameter_value phy_pll {gui_phase_shift0} {0}
set_instance_parameter_value phy_pll {gui_phase_shift1} {0}
set_instance_parameter_value phy_pll {gui_phase_shift10} {0}
set_instance_parameter_value phy_pll {gui_phase_shift11} {0}
set_instance_parameter_value phy_pll {gui_phase_shift12} {0}
set_instance_parameter_value phy_pll {gui_phase_shift13} {0}
set_instance_parameter_value phy_pll {gui_phase_shift14} {0}
set_instance_parameter_value phy_pll {gui_phase_shift15} {0}
set_instance_parameter_value phy_pll {gui_phase_shift16} {0}
set_instance_parameter_value phy_pll {gui_phase_shift17} {0}
set_instance_parameter_value phy_pll {gui_phase_shift2} {0}
set_instance_parameter_value phy_pll {gui_phase_shift3} {0}
set_instance_parameter_value phy_pll {gui_phase_shift4} {0}
set_instance_parameter_value phy_pll {gui_phase_shift5} {0}
set_instance_parameter_value phy_pll {gui_phase_shift6} {0}
set_instance_parameter_value phy_pll {gui_phase_shift7} {0}
set_instance_parameter_value phy_pll {gui_phase_shift8} {0}
set_instance_parameter_value phy_pll {gui_phase_shift9} {0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg0} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg1} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg10} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg11} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg12} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg13} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg14} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg15} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg16} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg17} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg2} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg3} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg4} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg5} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg6} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg7} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg8} {0.0}
set_instance_parameter_value phy_pll {gui_phase_shift_deg9} {0.0}
set_instance_parameter_value phy_pll {gui_phout_division} {1}
set_instance_parameter_value phy_pll {gui_pll_auto_reset} {Off}
set_instance_parameter_value phy_pll {gui_pll_bandwidth_preset} {Auto}
set_instance_parameter_value phy_pll {gui_pll_cascading_mode} {Create an adjpllin signal to connect with an upstream PLL}
set_instance_parameter_value phy_pll {gui_pll_mode} {Integer-N PLL}
set_instance_parameter_value phy_pll {gui_ps_units0} {ps}
set_instance_parameter_value phy_pll {gui_ps_units1} {ps}
set_instance_parameter_value phy_pll {gui_ps_units10} {ps}
set_instance_parameter_value phy_pll {gui_ps_units11} {ps}
set_instance_parameter_value phy_pll {gui_ps_units12} {ps}
set_instance_parameter_value phy_pll {gui_ps_units13} {ps}
set_instance_parameter_value phy_pll {gui_ps_units14} {ps}
set_instance_parameter_value phy_pll {gui_ps_units15} {ps}
set_instance_parameter_value phy_pll {gui_ps_units16} {ps}
set_instance_parameter_value phy_pll {gui_ps_units17} {ps}
set_instance_parameter_value phy_pll {gui_ps_units2} {ps}
set_instance_parameter_value phy_pll {gui_ps_units3} {ps}
set_instance_parameter_value phy_pll {gui_ps_units4} {ps}
set_instance_parameter_value phy_pll {gui_ps_units5} {ps}
set_instance_parameter_value phy_pll {gui_ps_units6} {ps}
set_instance_parameter_value phy_pll {gui_ps_units7} {ps}
set_instance_parameter_value phy_pll {gui_ps_units8} {ps}
set_instance_parameter_value phy_pll {gui_ps_units9} {ps}
set_instance_parameter_value phy_pll {gui_refclk1_frequency} {100.0}
set_instance_parameter_value phy_pll {gui_refclk_switch} {0}
set_instance_parameter_value phy_pll {gui_reference_clock_frequency} {50.0}
set_instance_parameter_value phy_pll {gui_switchover_delay} {0}
set_instance_parameter_value phy_pll {gui_switchover_mode} {Automatic Switchover}
set_instance_parameter_value phy_pll {gui_use_locked} {0}

add_instance rstctrl altera_reset_controller 19.1
set_instance_parameter_value rstctrl {MIN_RST_ASSERTION_TIME} {3}
set_instance_parameter_value rstctrl {NUM_RESET_INPUTS} {2}
set_instance_parameter_value rstctrl {OUTPUT_RESET_SYNC_EDGES} {deassert}
set_instance_parameter_value rstctrl {RESET_REQUEST_PRESENT} {0}
set_instance_parameter_value rstctrl {RESET_REQ_EARLY_DSRT_TIME} {1}
set_instance_parameter_value rstctrl {RESET_REQ_WAIT_TIME} {1}
set_instance_parameter_value rstctrl {SYNC_DEPTH} {2}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN0} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN1} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN10} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN11} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN12} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN13} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN14} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN15} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN2} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN3} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN4} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN5} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN6} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN7} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN8} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_IN9} {0}
set_instance_parameter_value rstctrl {USE_RESET_REQUEST_INPUT} {0}

add_instance sfp0 fejkon_sfp 1.0

add_instance temp intel_temp 1.0

add_instance temp_sense altera_temp_sense 19.1
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

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF ext0.clk_in
add_interface fcport0_line_rd conduit end
set_interface_property fcport0_line_rd EXPORT_OF fcport0.line_rd
add_interface fcport0_line_td conduit end
set_interface_property fcport0_line_td EXPORT_OF fcport0.line_td
add_interface led conduit end
set_interface_property led EXPORT_OF led.external_connection
add_interface pcie_refclk clock sink
set_interface_property pcie_refclk EXPORT_OF pcie.pcie_refclk
add_interface pcie_reset_pin conduit end
set_interface_property pcie_reset_pin EXPORT_OF pcie.pcie_reset_pin
add_interface pcie_serial conduit end
set_interface_property pcie_serial EXPORT_OF pcie.phy_serial
add_interface reset reset sink
set_interface_property reset EXPORT_OF ext0.clk_in_reset
add_interface sfp0_sfp conduit end
set_interface_property sfp0_sfp EXPORT_OF sfp0.sfp

# connections and connection parameters
add_connection ext0.clk fcport0.mgmt_clk

add_connection ext0.clk ident.clk

add_connection ext0.clk jtagm.clk

add_connection ext0.clk led.clk

add_connection ext0.clk pcie.bar2_clk

add_connection ext0.clk pcie.mgmt_clk

add_connection ext0.clk pcie.read_mem_clk

add_connection ext0.clk pcie.write_mem_clk

add_connection ext0.clk phy_pll.refclk

add_connection ext0.clk rstctrl.clk

add_connection ext0.clk sfp0.clk

add_connection ext0.clk temp.clk

add_connection ext0.clk temp_sense.clk

add_connection ext0.clk_reset jtagm.clk_reset

add_connection ext0.clk_reset rstctrl.reset_in0

add_connection jtagm.master fcport0.mgmt_mm
set_connection_parameter_value jtagm.master/fcport0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fcport0.mgmt_mm baseAddress {0x00010000}
set_connection_parameter_value jtagm.master/fcport0.mgmt_mm defaultConnection {0}

add_connection jtagm.master ident.mm
set_connection_parameter_value jtagm.master/ident.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/ident.mm baseAddress {0x0000}
set_connection_parameter_value jtagm.master/ident.mm defaultConnection {0}

add_connection jtagm.master led.s1
set_connection_parameter_value jtagm.master/led.s1 arbitrationPriority {1}
set_connection_parameter_value jtagm.master/led.s1 baseAddress {0x000e0000}
set_connection_parameter_value jtagm.master/led.s1 defaultConnection {0}

add_connection jtagm.master pcie.read_mem_mm
set_connection_parameter_value jtagm.master/pcie.read_mem_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/pcie.read_mem_mm baseAddress {0x00800000}
set_connection_parameter_value jtagm.master/pcie.read_mem_mm defaultConnection {0}

add_connection jtagm.master pcie.write_mem_mm
set_connection_parameter_value jtagm.master/pcie.write_mem_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/pcie.write_mem_mm baseAddress {0x00c00000}
set_connection_parameter_value jtagm.master/pcie.write_mem_mm defaultConnection {0}

add_connection jtagm.master sfp0.mm
set_connection_parameter_value jtagm.master/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp0.mm baseAddress {0x1000}
set_connection_parameter_value jtagm.master/sfp0.mm defaultConnection {0}

add_connection jtagm.master temp.temp_mm
set_connection_parameter_value jtagm.master/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value jtagm.master/temp.temp_mm defaultConnection {0}

add_connection jtagm.master_reset rstctrl.reset_in1

add_connection pcie.bar2_mm fcport0.mgmt_mm
set_connection_parameter_value pcie.bar2_mm/fcport0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/fcport0.mgmt_mm baseAddress {0x00010000}
set_connection_parameter_value pcie.bar2_mm/fcport0.mgmt_mm defaultConnection {0}

add_connection pcie.bar2_mm ident.mm
set_connection_parameter_value pcie.bar2_mm/ident.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/ident.mm baseAddress {0x0000}
set_connection_parameter_value pcie.bar2_mm/ident.mm defaultConnection {0}

add_connection pcie.bar2_mm sfp0.mm
set_connection_parameter_value pcie.bar2_mm/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/sfp0.mm baseAddress {0x1000}
set_connection_parameter_value pcie.bar2_mm/sfp0.mm defaultConnection {0}

add_connection pcie.bar2_mm temp.temp_mm
set_connection_parameter_value pcie.bar2_mm/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value pcie.bar2_mm/temp.temp_mm defaultConnection {0}

add_connection phy_pll.outclk0 fcport0.phy_clk

add_connection rstctrl.reset_out fcport0.reset

add_connection rstctrl.reset_out ident.reset

add_connection rstctrl.reset_out led.reset

add_connection rstctrl.reset_out pcie.bar2_reset

add_connection rstctrl.reset_out pcie.mgmt_rst

add_connection rstctrl.reset_out phy_pll.reset

add_connection rstctrl.reset_out sfp0.reset

add_connection rstctrl.reset_out temp.reset

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

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.enableInstrumentation} {TRUE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {fcport0.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fcport0.rx_dma_m} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fcport0.setup} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fcport0.tx_dma_m} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {jtagm.master} {qsys_mm.insertPerformanceMonitor} {FALSE}
set_interconnect_requirement {pcie.bar2_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.read_mem_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.write_mem_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {sfp0.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}

save_system {fejkon.qsys}
