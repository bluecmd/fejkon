# qsys scripting (.tcl) file for tb
package require -exact qsys 16.0

create_system {tb}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGSMD4E1H29C1}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance fifo_AtoB altera_avalon_dc_fifo 19.1
set_instance_parameter_value fifo_AtoB {BITS_PER_SYMBOL} {9}
set_instance_parameter_value fifo_AtoB {CHANNEL_WIDTH} {0}
set_instance_parameter_value fifo_AtoB {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_AtoB {ERROR_WIDTH} {0}
set_instance_parameter_value fifo_AtoB {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_AtoB {FIFO_DEPTH} {16}
set_instance_parameter_value fifo_AtoB {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fifo_AtoB {SYMBOLS_PER_BEAT} {4}
set_instance_parameter_value fifo_AtoB {USE_IN_FILL_LEVEL} {0}
set_instance_parameter_value fifo_AtoB {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fifo_AtoB {USE_PACKETS} {0}
set_instance_parameter_value fifo_AtoB {WR_SYNC_DEPTH} {3}

add_instance fifo_BtoA altera_avalon_dc_fifo 19.1
set_instance_parameter_value fifo_BtoA {BITS_PER_SYMBOL} {9}
set_instance_parameter_value fifo_BtoA {CHANNEL_WIDTH} {0}
set_instance_parameter_value fifo_BtoA {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_BtoA {ERROR_WIDTH} {0}
set_instance_parameter_value fifo_BtoA {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_BtoA {FIFO_DEPTH} {16}
set_instance_parameter_value fifo_BtoA {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fifo_BtoA {SYMBOLS_PER_BEAT} {4}
set_instance_parameter_value fifo_BtoA {USE_IN_FILL_LEVEL} {0}
set_instance_parameter_value fifo_BtoA {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fifo_BtoA {USE_PACKETS} {0}
set_instance_parameter_value fifo_BtoA {WR_SYNC_DEPTH} {3}

add_instance framer0 fc_framer 1.0

add_instance framer1 fc_framer 1.0

add_instance mgmt_clk clock_source 19.1
set_instance_parameter_value mgmt_clk {clockFrequency} {50000000.0}
set_instance_parameter_value mgmt_clk {clockFrequencyKnown} {1}
set_instance_parameter_value mgmt_clk {resetSynchronousEdges} {DEASSERT}

add_instance phy0_clk clock_source 19.1
set_instance_parameter_value phy0_clk {clockFrequency} {106255000.0}
set_instance_parameter_value phy0_clk {clockFrequencyKnown} {1}
set_instance_parameter_value phy0_clk {resetSynchronousEdges} {NONE}

add_instance phy1_clk clock_source 19.1
set_instance_parameter_value phy1_clk {clockFrequency} {106253000.0}
set_instance_parameter_value phy1_clk {clockFrequencyKnown} {1}
set_instance_parameter_value phy1_clk {resetSynchronousEdges} {NONE}

add_instance phyA_clk clock_source 19.1
set_instance_parameter_value phyA_clk {clockFrequency} {106247000.0}
set_instance_parameter_value phyA_clk {clockFrequencyKnown} {1}
set_instance_parameter_value phyA_clk {resetSynchronousEdges} {NONE}

add_instance phyB_clk clock_source 19.1
set_instance_parameter_value phyB_clk {clockFrequency} {106245000.0}
set_instance_parameter_value phyB_clk {clockFrequencyKnown} {1}
set_instance_parameter_value phyB_clk {resetSynchronousEdges} {NONE}

add_instance reconfig alt_xcvr_reconfig 19.1
set_instance_parameter_value reconfig {ber_en} {0}
set_instance_parameter_value reconfig {enable_adce} {0}
set_instance_parameter_value reconfig {enable_analog} {1}
set_instance_parameter_value reconfig {enable_dcd} {0}
set_instance_parameter_value reconfig {enable_dcd_power_up} {1}
set_instance_parameter_value reconfig {enable_dfe} {0}
set_instance_parameter_value reconfig {enable_eyemon} {0}
set_instance_parameter_value reconfig {enable_mif} {0}
set_instance_parameter_value reconfig {enable_offset} {1}
set_instance_parameter_value reconfig {gui_cal_status_port} {0}
set_instance_parameter_value reconfig {gui_enable_pll} {0}
set_instance_parameter_value reconfig {gui_split_sizes} {2,2,2,2}
set_instance_parameter_value reconfig {number_of_reconfig_interfaces} {8}

add_instance rx0_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value rx0_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value rx0_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance rx1_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value rx1_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value rx1_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance tx0_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value tx0_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value tx0_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance tx1_clk_bridge altera_clock_bridge 19.1
set_instance_parameter_value tx1_clk_bridge {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value tx1_clk_bridge {NUM_CLOCK_OUTPUTS} {1}

add_instance xcvr0 fc_8g_xcvr 1.0

add_instance xcvr1 fc_8g_xcvr 1.0

add_instance xcvrA fc_8g_xcvr 1.0

add_instance xcvrB fc_8g_xcvr 1.0

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF mgmt_clk.clk_in
add_interface framer0_active conduit end
set_interface_property framer0_active EXPORT_OF framer0.active
add_interface framer0_mgmt_mm avalon slave
set_interface_property framer0_mgmt_mm EXPORT_OF framer0.mgmt_mm
add_interface framer1_active conduit end
set_interface_property framer1_active EXPORT_OF framer1.active
add_interface framer_1_mgmt_mm avalon slave
set_interface_property framer_1_mgmt_mm EXPORT_OF framer1.mgmt_mm
add_interface phy0_clk clock sink
set_interface_property phy0_clk EXPORT_OF phy0_clk.clk_in
add_interface phy0_reset reset sink
set_interface_property phy0_reset EXPORT_OF phy0_clk.clk_in_reset
add_interface phy1_clk clock sink
set_interface_property phy1_clk EXPORT_OF phy1_clk.clk_in
add_interface phy1_reset reset sink
set_interface_property phy1_reset EXPORT_OF phy1_clk.clk_in_reset
add_interface phya_clk clock sink
set_interface_property phya_clk EXPORT_OF phyA_clk.clk_in
add_interface phya_reset reset sink
set_interface_property phya_reset EXPORT_OF phyA_clk.clk_in_reset
add_interface phyb_clk clock sink
set_interface_property phyb_clk EXPORT_OF phyB_clk.clk_in
add_interface phyb_reset reset sink
set_interface_property phyb_reset EXPORT_OF phyB_clk.clk_in_reset
add_interface reconfig_busy conduit end
set_interface_property reconfig_busy EXPORT_OF reconfig.reconfig_busy
add_interface reconfig_mgmt avalon slave
set_interface_property reconfig_mgmt EXPORT_OF reconfig.reconfig_mgmt
add_interface reset reset sink
set_interface_property reset EXPORT_OF mgmt_clk.clk_in_reset
add_interface rx0_clk clock source
set_interface_property rx0_clk EXPORT_OF rx0_clk_bridge.out_clk
add_interface rx1_clk clock source
set_interface_property rx1_clk EXPORT_OF rx1_clk_bridge.out_clk
add_interface tx0_clk clock source
set_interface_property tx0_clk EXPORT_OF tx0_clk_bridge.out_clk
add_interface tx1_clk clock source
set_interface_property tx1_clk EXPORT_OF tx1_clk_bridge.out_clk
add_interface userrx0 avalon_streaming source
set_interface_property userrx0 EXPORT_OF framer0.userrx
add_interface userrx1 avalon_streaming source
set_interface_property userrx1 EXPORT_OF framer1.userrx
add_interface usertx0 avalon_streaming sink
set_interface_property usertx0 EXPORT_OF framer0.usertx
add_interface usertx1 avalon_streaming sink
set_interface_property usertx1 EXPORT_OF framer1.usertx
add_interface xcvr0_aligned conduit end
set_interface_property xcvr0_aligned EXPORT_OF xcvr0.aligned
add_interface xcvr0_mgmt_mm avalon slave
set_interface_property xcvr0_mgmt_mm EXPORT_OF xcvr0.mgmt_mm
add_interface xcvr1_aligned conduit end
set_interface_property xcvr1_aligned EXPORT_OF xcvr1.aligned
add_interface xcvr1_mgmt_mm avalon slave
set_interface_property xcvr1_mgmt_mm EXPORT_OF xcvr1.mgmt_mm
add_interface xcvra_aligned conduit end
set_interface_property xcvra_aligned EXPORT_OF xcvrA.aligned
add_interface xcvra_mgmt_mm avalon slave
set_interface_property xcvra_mgmt_mm EXPORT_OF xcvrA.mgmt_mm
add_interface xcvrb_aligned conduit end
set_interface_property xcvrb_aligned EXPORT_OF xcvrB.aligned
add_interface xcvrb_mgmt_mm avalon slave
set_interface_property xcvrb_mgmt_mm EXPORT_OF xcvrB.mgmt_mm

# connections and connection parameters
add_connection fifo_AtoB.out xcvrB.avtx

add_connection fifo_BtoA.out xcvrA.avtx

add_connection framer0.avtx xcvr0.avtx

add_connection framer1.avtx xcvr1.avtx

add_connection mgmt_clk.clk framer0.mgmt_clk

add_connection mgmt_clk.clk framer1.mgmt_clk

add_connection mgmt_clk.clk reconfig.mgmt_clk_clk

add_connection mgmt_clk.clk xcvr0.mgmt_clk

add_connection mgmt_clk.clk xcvr1.mgmt_clk

add_connection mgmt_clk.clk xcvrA.mgmt_clk

add_connection mgmt_clk.clk xcvrB.mgmt_clk

add_connection mgmt_clk.clk_reset fifo_AtoB.in_clk_reset

add_connection mgmt_clk.clk_reset fifo_AtoB.out_clk_reset

add_connection mgmt_clk.clk_reset fifo_BtoA.in_clk_reset

add_connection mgmt_clk.clk_reset fifo_BtoA.out_clk_reset

add_connection mgmt_clk.clk_reset framer0.reset

add_connection mgmt_clk.clk_reset framer1.reset

add_connection mgmt_clk.clk_reset reconfig.mgmt_rst_reset

add_connection mgmt_clk.clk_reset xcvr0.reset

add_connection mgmt_clk.clk_reset xcvr1.reset

add_connection mgmt_clk.clk_reset xcvrA.reset

add_connection mgmt_clk.clk_reset xcvrB.reset

add_connection phy0_clk.clk xcvr0.phy_clk

add_connection phy1_clk.clk xcvr1.phy_clk

add_connection phyA_clk.clk xcvrA.phy_clk

add_connection phyB_clk.clk xcvrB.phy_clk

add_connection reconfig.ch0_1_to_xcvr xcvr0.reconfig_to_xcvr
set_connection_parameter_value reconfig.ch0_1_to_xcvr/xcvr0.reconfig_to_xcvr endPort {}
set_connection_parameter_value reconfig.ch0_1_to_xcvr/xcvr0.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value reconfig.ch0_1_to_xcvr/xcvr0.reconfig_to_xcvr startPort {}
set_connection_parameter_value reconfig.ch0_1_to_xcvr/xcvr0.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value reconfig.ch0_1_to_xcvr/xcvr0.reconfig_to_xcvr width {0}

add_connection reconfig.ch2_3_from_xcvr xcvrA.reconfig_from_xcvr
set_connection_parameter_value reconfig.ch2_3_from_xcvr/xcvrA.reconfig_from_xcvr endPort {}
set_connection_parameter_value reconfig.ch2_3_from_xcvr/xcvrA.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value reconfig.ch2_3_from_xcvr/xcvrA.reconfig_from_xcvr startPort {}
set_connection_parameter_value reconfig.ch2_3_from_xcvr/xcvrA.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value reconfig.ch2_3_from_xcvr/xcvrA.reconfig_from_xcvr width {0}

add_connection reconfig.ch2_3_to_xcvr xcvrA.reconfig_to_xcvr
set_connection_parameter_value reconfig.ch2_3_to_xcvr/xcvrA.reconfig_to_xcvr endPort {}
set_connection_parameter_value reconfig.ch2_3_to_xcvr/xcvrA.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value reconfig.ch2_3_to_xcvr/xcvrA.reconfig_to_xcvr startPort {}
set_connection_parameter_value reconfig.ch2_3_to_xcvr/xcvrA.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value reconfig.ch2_3_to_xcvr/xcvrA.reconfig_to_xcvr width {0}

add_connection reconfig.ch4_5_to_xcvr xcvrB.reconfig_to_xcvr
set_connection_parameter_value reconfig.ch4_5_to_xcvr/xcvrB.reconfig_to_xcvr endPort {}
set_connection_parameter_value reconfig.ch4_5_to_xcvr/xcvrB.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value reconfig.ch4_5_to_xcvr/xcvrB.reconfig_to_xcvr startPort {}
set_connection_parameter_value reconfig.ch4_5_to_xcvr/xcvrB.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value reconfig.ch4_5_to_xcvr/xcvrB.reconfig_to_xcvr width {0}

add_connection reconfig.ch6_7_to_xcvr xcvr1.reconfig_to_xcvr
set_connection_parameter_value reconfig.ch6_7_to_xcvr/xcvr1.reconfig_to_xcvr endPort {}
set_connection_parameter_value reconfig.ch6_7_to_xcvr/xcvr1.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value reconfig.ch6_7_to_xcvr/xcvr1.reconfig_to_xcvr startPort {}
set_connection_parameter_value reconfig.ch6_7_to_xcvr/xcvr1.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value reconfig.ch6_7_to_xcvr/xcvr1.reconfig_to_xcvr width {0}

add_connection xcvr0.avrx framer0.avrx

add_connection xcvr0.line_td xcvrA.line_rd
set_connection_parameter_value xcvr0.line_td/xcvrA.line_rd endPort {}
set_connection_parameter_value xcvr0.line_td/xcvrA.line_rd endPortLSB {0}
set_connection_parameter_value xcvr0.line_td/xcvrA.line_rd startPort {}
set_connection_parameter_value xcvr0.line_td/xcvrA.line_rd startPortLSB {0}
set_connection_parameter_value xcvr0.line_td/xcvrA.line_rd width {0}

add_connection xcvr0.reconfig_from_xcvr reconfig.ch0_1_from_xcvr
set_connection_parameter_value xcvr0.reconfig_from_xcvr/reconfig.ch0_1_from_xcvr endPort {}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/reconfig.ch0_1_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/reconfig.ch0_1_from_xcvr startPort {}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/reconfig.ch0_1_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvr0.reconfig_from_xcvr/reconfig.ch0_1_from_xcvr width {0}

add_connection xcvr0.rx_clk framer0.rx_clk

add_connection xcvr0.rx_clk rx0_clk_bridge.in_clk

add_connection xcvr0.tx_clk framer0.tx_clk

add_connection xcvr0.tx_clk tx0_clk_bridge.in_clk

add_connection xcvr1.avrx framer1.avrx

add_connection xcvr1.line_td xcvrB.line_rd
set_connection_parameter_value xcvr1.line_td/xcvrB.line_rd endPort {}
set_connection_parameter_value xcvr1.line_td/xcvrB.line_rd endPortLSB {0}
set_connection_parameter_value xcvr1.line_td/xcvrB.line_rd startPort {}
set_connection_parameter_value xcvr1.line_td/xcvrB.line_rd startPortLSB {0}
set_connection_parameter_value xcvr1.line_td/xcvrB.line_rd width {0}

add_connection xcvr1.reconfig_from_xcvr reconfig.ch6_7_from_xcvr
set_connection_parameter_value xcvr1.reconfig_from_xcvr/reconfig.ch6_7_from_xcvr endPort {}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/reconfig.ch6_7_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/reconfig.ch6_7_from_xcvr startPort {}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/reconfig.ch6_7_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvr1.reconfig_from_xcvr/reconfig.ch6_7_from_xcvr width {0}

add_connection xcvr1.rx_clk framer1.rx_clk

add_connection xcvr1.rx_clk rx1_clk_bridge.in_clk

add_connection xcvr1.tx_clk framer1.tx_clk

add_connection xcvr1.tx_clk tx1_clk_bridge.in_clk

add_connection xcvrA.avrx fifo_AtoB.in

add_connection xcvrA.line_td xcvr0.line_rd
set_connection_parameter_value xcvrA.line_td/xcvr0.line_rd endPort {}
set_connection_parameter_value xcvrA.line_td/xcvr0.line_rd endPortLSB {0}
set_connection_parameter_value xcvrA.line_td/xcvr0.line_rd startPort {}
set_connection_parameter_value xcvrA.line_td/xcvr0.line_rd startPortLSB {0}
set_connection_parameter_value xcvrA.line_td/xcvr0.line_rd width {0}

add_connection xcvrA.rx_clk fifo_AtoB.in_clk

add_connection xcvrA.tx_clk fifo_BtoA.out_clk

add_connection xcvrB.avrx fifo_BtoA.in

add_connection xcvrB.line_td xcvr1.line_rd
set_connection_parameter_value xcvrB.line_td/xcvr1.line_rd endPort {}
set_connection_parameter_value xcvrB.line_td/xcvr1.line_rd endPortLSB {0}
set_connection_parameter_value xcvrB.line_td/xcvr1.line_rd startPort {}
set_connection_parameter_value xcvrB.line_td/xcvr1.line_rd startPortLSB {0}
set_connection_parameter_value xcvrB.line_td/xcvr1.line_rd width {0}

add_connection xcvrB.reconfig_from_xcvr reconfig.ch4_5_from_xcvr
set_connection_parameter_value xcvrB.reconfig_from_xcvr/reconfig.ch4_5_from_xcvr endPort {}
set_connection_parameter_value xcvrB.reconfig_from_xcvr/reconfig.ch4_5_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvrB.reconfig_from_xcvr/reconfig.ch4_5_from_xcvr startPort {}
set_connection_parameter_value xcvrB.reconfig_from_xcvr/reconfig.ch4_5_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvrB.reconfig_from_xcvr/reconfig.ch4_5_from_xcvr width {0}

add_connection xcvrB.rx_clk fifo_BtoA.in_clk

add_connection xcvrB.tx_clk fifo_AtoB.out_clk

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {tb.qsys}
