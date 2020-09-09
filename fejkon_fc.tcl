# qsys scripting (.tcl) file for fejkon_fc
package require -exact qsys 16.0

create_system {fejkon_fc}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance fc0 fc_framer 1.0
set_instance_parameter_value fc0 {MTU} {3072}
set_instance_parameter_value fc0 {WAIT_FOR_PEER} {1}

add_instance fc0_256_rx altera_avalon_st_adapter 20.1
set_instance_parameter_value fc0_256_rx {inBitsPerSymbol} {8}
set_instance_parameter_value fc0_256_rx {inChannelWidth} {0}
set_instance_parameter_value fc0_256_rx {inDataWidth} {32}
set_instance_parameter_value fc0_256_rx {inErrorDescriptor} {}
set_instance_parameter_value fc0_256_rx {inErrorWidth} {0}
set_instance_parameter_value fc0_256_rx {inMaxChannel} {0}
set_instance_parameter_value fc0_256_rx {inReadyLatency} {0}
set_instance_parameter_value fc0_256_rx {inUseEmptyPort} {0}
set_instance_parameter_value fc0_256_rx {inUsePackets} {1}
set_instance_parameter_value fc0_256_rx {inUseReady} {1}
set_instance_parameter_value fc0_256_rx {inUseValid} {1}
set_instance_parameter_value fc0_256_rx {outChannelWidth} {0}
set_instance_parameter_value fc0_256_rx {outDataWidth} {256}
set_instance_parameter_value fc0_256_rx {outErrorDescriptor} {}
set_instance_parameter_value fc0_256_rx {outErrorWidth} {0}
set_instance_parameter_value fc0_256_rx {outMaxChannel} {0}
set_instance_parameter_value fc0_256_rx {outReadyLatency} {0}
set_instance_parameter_value fc0_256_rx {outUseEmptyPort} {1}
set_instance_parameter_value fc0_256_rx {outUseReady} {1}
set_instance_parameter_value fc0_256_rx {outUseValid} {1}

add_instance fc0_rx_cdc altera_avalon_dc_fifo 20.1
set_instance_parameter_value fc0_rx_cdc {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc0_rx_cdc {CHANNEL_WIDTH} {0}
set_instance_parameter_value fc0_rx_cdc {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc0_rx_cdc {ERROR_WIDTH} {0}
set_instance_parameter_value fc0_rx_cdc {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc0_rx_cdc {FIFO_DEPTH} {512}
set_instance_parameter_value fc0_rx_cdc {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fc0_rx_cdc {SYMBOLS_PER_BEAT} {32}
set_instance_parameter_value fc0_rx_cdc {USE_IN_FILL_LEVEL} {1}
set_instance_parameter_value fc0_rx_cdc {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fc0_rx_cdc {USE_PACKETS} {1}
set_instance_parameter_value fc0_rx_cdc {WR_SYNC_DEPTH} {3}

add_instance fc0_rx_split altera_avalon_st_splitter 20.1
set_instance_parameter_value fc0_rx_split {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc0_rx_split {CHANNEL_WIDTH} {1}
set_instance_parameter_value fc0_rx_split {DATA_WIDTH} {32}
set_instance_parameter_value fc0_rx_split {ERROR_DESCRIPTOR} {}
set_instance_parameter_value fc0_rx_split {ERROR_WIDTH} {1}
set_instance_parameter_value fc0_rx_split {MAX_CHANNELS} {1}
set_instance_parameter_value fc0_rx_split {NUMBER_OF_OUTPUTS} {2}
set_instance_parameter_value fc0_rx_split {QUALIFY_VALID_OUT} {1}
set_instance_parameter_value fc0_rx_split {READY_LATENCY} {0}
set_instance_parameter_value fc0_rx_split {USE_CHANNEL} {0}
set_instance_parameter_value fc0_rx_split {USE_DATA} {1}
set_instance_parameter_value fc0_rx_split {USE_ERROR} {0}
set_instance_parameter_value fc0_rx_split {USE_PACKETS} {1}
set_instance_parameter_value fc0_rx_split {USE_READY} {1}
set_instance_parameter_value fc0_rx_split {USE_VALID} {1}

add_instance fc1 fc_framer 1.0
set_instance_parameter_value fc1 {MTU} {3072}
set_instance_parameter_value fc1 {WAIT_FOR_PEER} {1}

add_instance fc1_256_rx altera_avalon_st_adapter 20.1
set_instance_parameter_value fc1_256_rx {inBitsPerSymbol} {8}
set_instance_parameter_value fc1_256_rx {inChannelWidth} {0}
set_instance_parameter_value fc1_256_rx {inDataWidth} {32}
set_instance_parameter_value fc1_256_rx {inErrorDescriptor} {}
set_instance_parameter_value fc1_256_rx {inErrorWidth} {0}
set_instance_parameter_value fc1_256_rx {inMaxChannel} {0}
set_instance_parameter_value fc1_256_rx {inReadyLatency} {0}
set_instance_parameter_value fc1_256_rx {inUseEmptyPort} {0}
set_instance_parameter_value fc1_256_rx {inUsePackets} {1}
set_instance_parameter_value fc1_256_rx {inUseReady} {1}
set_instance_parameter_value fc1_256_rx {inUseValid} {1}
set_instance_parameter_value fc1_256_rx {outChannelWidth} {0}
set_instance_parameter_value fc1_256_rx {outDataWidth} {256}
set_instance_parameter_value fc1_256_rx {outErrorDescriptor} {}
set_instance_parameter_value fc1_256_rx {outErrorWidth} {0}
set_instance_parameter_value fc1_256_rx {outMaxChannel} {0}
set_instance_parameter_value fc1_256_rx {outReadyLatency} {0}
set_instance_parameter_value fc1_256_rx {outUseEmptyPort} {1}
set_instance_parameter_value fc1_256_rx {outUseReady} {1}
set_instance_parameter_value fc1_256_rx {outUseValid} {1}

add_instance fc1_rx_cdc altera_avalon_dc_fifo 20.1
set_instance_parameter_value fc1_rx_cdc {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc1_rx_cdc {CHANNEL_WIDTH} {0}
set_instance_parameter_value fc1_rx_cdc {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc1_rx_cdc {ERROR_WIDTH} {0}
set_instance_parameter_value fc1_rx_cdc {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc1_rx_cdc {FIFO_DEPTH} {512}
set_instance_parameter_value fc1_rx_cdc {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fc1_rx_cdc {SYMBOLS_PER_BEAT} {32}
set_instance_parameter_value fc1_rx_cdc {USE_IN_FILL_LEVEL} {1}
set_instance_parameter_value fc1_rx_cdc {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fc1_rx_cdc {USE_PACKETS} {1}
set_instance_parameter_value fc1_rx_cdc {WR_SYNC_DEPTH} {3}

add_instance fc1_rx_split altera_avalon_st_splitter 20.1
set_instance_parameter_value fc1_rx_split {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc1_rx_split {CHANNEL_WIDTH} {1}
set_instance_parameter_value fc1_rx_split {DATA_WIDTH} {32}
set_instance_parameter_value fc1_rx_split {ERROR_DESCRIPTOR} {}
set_instance_parameter_value fc1_rx_split {ERROR_WIDTH} {1}
set_instance_parameter_value fc1_rx_split {MAX_CHANNELS} {1}
set_instance_parameter_value fc1_rx_split {NUMBER_OF_OUTPUTS} {2}
set_instance_parameter_value fc1_rx_split {QUALIFY_VALID_OUT} {1}
set_instance_parameter_value fc1_rx_split {READY_LATENCY} {0}
set_instance_parameter_value fc1_rx_split {USE_CHANNEL} {0}
set_instance_parameter_value fc1_rx_split {USE_DATA} {1}
set_instance_parameter_value fc1_rx_split {USE_ERROR} {0}
set_instance_parameter_value fc1_rx_split {USE_PACKETS} {1}
set_instance_parameter_value fc1_rx_split {USE_READY} {1}
set_instance_parameter_value fc1_rx_split {USE_VALID} {1}

add_instance fifo_0to1 altera_avalon_dc_fifo 20.1
set_instance_parameter_value fifo_0to1 {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fifo_0to1 {CHANNEL_WIDTH} {0}
set_instance_parameter_value fifo_0to1 {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_0to1 {ERROR_WIDTH} {0}
set_instance_parameter_value fifo_0to1 {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_0to1 {FIFO_DEPTH} {16}
set_instance_parameter_value fifo_0to1 {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fifo_0to1 {SYMBOLS_PER_BEAT} {4}
set_instance_parameter_value fifo_0to1 {USE_IN_FILL_LEVEL} {0}
set_instance_parameter_value fifo_0to1 {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fifo_0to1 {USE_PACKETS} {1}
set_instance_parameter_value fifo_0to1 {WR_SYNC_DEPTH} {3}

add_instance fifo_1to0 altera_avalon_dc_fifo 20.1
set_instance_parameter_value fifo_1to0 {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fifo_1to0 {CHANNEL_WIDTH} {0}
set_instance_parameter_value fifo_1to0 {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_1to0 {ERROR_WIDTH} {0}
set_instance_parameter_value fifo_1to0 {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fifo_1to0 {FIFO_DEPTH} {16}
set_instance_parameter_value fifo_1to0 {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fifo_1to0 {SYMBOLS_PER_BEAT} {4}
set_instance_parameter_value fifo_1to0 {USE_IN_FILL_LEVEL} {0}
set_instance_parameter_value fifo_1to0 {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fifo_1to0 {USE_PACKETS} {1}
set_instance_parameter_value fifo_1to0 {WR_SYNC_DEPTH} {3}

add_instance mgmt_clk altera_clock_bridge 20.1
set_instance_parameter_value mgmt_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value mgmt_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance mm altera_avalon_mm_bridge 20.1
set_instance_parameter_value mm {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value mm {ADDRESS_WIDTH} {10}
set_instance_parameter_value mm {DATA_WIDTH} {32}
set_instance_parameter_value mm {LINEWRAPBURSTS} {0}
set_instance_parameter_value mm {MAX_BURST_SIZE} {1}
set_instance_parameter_value mm {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value mm {PIPELINE_COMMAND} {1}
set_instance_parameter_value mm {PIPELINE_RESPONSE} {1}
set_instance_parameter_value mm {SYMBOL_WIDTH} {8}
set_instance_parameter_value mm {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value mm {USE_RESPONSE} {0}

add_instance phy_clk altera_clock_bridge 20.1
set_instance_parameter_value phy_clk {EXPLICIT_CLOCK_RATE} {106250000.0}
set_instance_parameter_value phy_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance reset altera_reset_bridge 20.1
set_instance_parameter_value reset {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value reset {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value reset {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value reset {USE_RESET_REQUEST} {0}

add_instance rx_mux multiplexer 20.1
set_instance_parameter_value rx_mux {bitsPerSymbol} {8}
set_instance_parameter_value rx_mux {errorWidth} {0}
set_instance_parameter_value rx_mux {numInputInterfaces} {2}
set_instance_parameter_value rx_mux {outChannelWidth} {2}
set_instance_parameter_value rx_mux {packetScheduling} {1}
set_instance_parameter_value rx_mux {schedulingSize} {2}
set_instance_parameter_value rx_mux {symbolsPerBeat} {32}
set_instance_parameter_value rx_mux {useHighBitsOfChannel} {1}
set_instance_parameter_value rx_mux {usePackets} {1}

add_instance rx_mux_clk altera_clock_bridge 20.1
set_instance_parameter_value rx_mux_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value rx_mux_clk {NUM_CLOCK_OUTPUTS} {1}

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
add_interface fc0_active conduit end
set_interface_property fc0_active EXPORT_OF fc0.active
add_interface fc1_active conduit end
set_interface_property fc1_active EXPORT_OF fc1.active
add_interface fcport0_line_rd conduit end
set_interface_property fcport0_line_rd EXPORT_OF xcvr0.line_rd
add_interface fcport0_line_td conduit end
set_interface_property fcport0_line_td EXPORT_OF xcvr0.line_td
add_interface fcport1_line_rd conduit end
set_interface_property fcport1_line_rd EXPORT_OF xcvr1.line_rd
add_interface fcport1_line_td conduit end
set_interface_property fcport1_line_td EXPORT_OF xcvr1.line_td
add_interface mgmt_clk clock sink
set_interface_property mgmt_clk EXPORT_OF mgmt_clk.in_clk
add_interface mgmt_mm avalon slave
set_interface_property mgmt_mm EXPORT_OF mm.s0
add_interface phy_clk clock sink
set_interface_property phy_clk EXPORT_OF phy_clk.in_clk
add_interface reconfig_busy conduit end
set_interface_property reconfig_busy EXPORT_OF xcvr_reconfig.reconfig_busy
add_interface reset reset sink
set_interface_property reset EXPORT_OF reset.in_reset
add_interface rx_mux avalon_streaming source
set_interface_property rx_mux EXPORT_OF rx_mux.out
add_interface rx_mux_clk clock sink
set_interface_property rx_mux_clk EXPORT_OF rx_mux_clk.in_clk
add_interface xcvr0_aligned conduit end
set_interface_property xcvr0_aligned EXPORT_OF xcvr0.aligned
add_interface xcvr1_aligned conduit end
set_interface_property xcvr1_aligned EXPORT_OF xcvr1.aligned

# connections and connection parameters
add_connection fc0.avtx xcvr0.avtx

add_connection fc0.port_ready fc1.peer_ready
set_connection_parameter_value fc0.port_ready/fc1.peer_ready endPort {}
set_connection_parameter_value fc0.port_ready/fc1.peer_ready endPortLSB {0}
set_connection_parameter_value fc0.port_ready/fc1.peer_ready startPort {}
set_connection_parameter_value fc0.port_ready/fc1.peer_ready startPortLSB {0}
set_connection_parameter_value fc0.port_ready/fc1.peer_ready width {0}

add_connection fc0.userrx fc0_rx_split.in

add_connection fc0_256_rx.out_0 fc0_rx_cdc.in

add_connection fc0_rx_cdc.out rx_mux.in0

add_connection fc0_rx_split.out0 fifo_0to1.in

add_connection fc0_rx_split.out1 fc0_256_rx.in_0

add_connection fc1.avtx xcvr1.avtx

add_connection fc1.port_ready fc0.peer_ready
set_connection_parameter_value fc1.port_ready/fc0.peer_ready endPort {}
set_connection_parameter_value fc1.port_ready/fc0.peer_ready endPortLSB {0}
set_connection_parameter_value fc1.port_ready/fc0.peer_ready startPort {}
set_connection_parameter_value fc1.port_ready/fc0.peer_ready startPortLSB {0}
set_connection_parameter_value fc1.port_ready/fc0.peer_ready width {0}

add_connection fc1.userrx fc1_rx_split.in

add_connection fc1_256_rx.out_0 fc1_rx_cdc.in

add_connection fc1_rx_cdc.out rx_mux.in1

add_connection fc1_rx_split.out0 fifo_1to0.in

add_connection fc1_rx_split.out1 fc1_256_rx.in_0

add_connection fifo_0to1.out fc1.usertx

add_connection fifo_1to0.out fc0.usertx

add_connection mgmt_clk.out_clk mm.clk

add_connection mgmt_clk.out_clk reset.clk

add_connection mgmt_clk.out_clk xcvr0.mgmt_clk

add_connection mgmt_clk.out_clk xcvr1.mgmt_clk

add_connection mgmt_clk.out_clk xcvr_reconfig.mgmt_clk_clk

add_connection mm.m0 fc0.rx_mgmt_mm
set_connection_parameter_value mm.m0/fc0.rx_mgmt_mm arbitrationPriority {1}
set_connection_parameter_value mm.m0/fc0.rx_mgmt_mm baseAddress {0x1000}
set_connection_parameter_value mm.m0/fc0.rx_mgmt_mm defaultConnection {0}

add_connection mm.m0 fc0.tx_mgmt_mm
set_connection_parameter_value mm.m0/fc0.tx_mgmt_mm arbitrationPriority {1}
set_connection_parameter_value mm.m0/fc0.tx_mgmt_mm baseAddress {0x1020}
set_connection_parameter_value mm.m0/fc0.tx_mgmt_mm defaultConnection {0}

add_connection mm.m0 fc0_rx_cdc.in_csr
set_connection_parameter_value mm.m0/fc0_rx_cdc.in_csr arbitrationPriority {1}
set_connection_parameter_value mm.m0/fc0_rx_cdc.in_csr baseAddress {0x1100}
set_connection_parameter_value mm.m0/fc0_rx_cdc.in_csr defaultConnection {0}

add_connection mm.m0 fc1.rx_mgmt_mm
set_connection_parameter_value mm.m0/fc1.rx_mgmt_mm arbitrationPriority {1}
set_connection_parameter_value mm.m0/fc1.rx_mgmt_mm baseAddress {0x3000}
set_connection_parameter_value mm.m0/fc1.rx_mgmt_mm defaultConnection {0}

add_connection mm.m0 fc1.tx_mgmt_mm
set_connection_parameter_value mm.m0/fc1.tx_mgmt_mm arbitrationPriority {1}
set_connection_parameter_value mm.m0/fc1.tx_mgmt_mm baseAddress {0x3020}
set_connection_parameter_value mm.m0/fc1.tx_mgmt_mm defaultConnection {0}

add_connection mm.m0 fc1_rx_cdc.in_csr
set_connection_parameter_value mm.m0/fc1_rx_cdc.in_csr arbitrationPriority {1}
set_connection_parameter_value mm.m0/fc1_rx_cdc.in_csr baseAddress {0x3100}
set_connection_parameter_value mm.m0/fc1_rx_cdc.in_csr defaultConnection {0}

add_connection mm.m0 xcvr0.mgmt_mm
set_connection_parameter_value mm.m0/xcvr0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value mm.m0/xcvr0.mgmt_mm baseAddress {0x0000}
set_connection_parameter_value mm.m0/xcvr0.mgmt_mm defaultConnection {0}

add_connection mm.m0 xcvr1.mgmt_mm
set_connection_parameter_value mm.m0/xcvr1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value mm.m0/xcvr1.mgmt_mm baseAddress {0x2000}
set_connection_parameter_value mm.m0/xcvr1.mgmt_mm defaultConnection {0}

add_connection mm.m0 xcvr_reconfig.reconfig_mgmt
set_connection_parameter_value mm.m0/xcvr_reconfig.reconfig_mgmt arbitrationPriority {1}
set_connection_parameter_value mm.m0/xcvr_reconfig.reconfig_mgmt baseAddress {0x7e00}
set_connection_parameter_value mm.m0/xcvr_reconfig.reconfig_mgmt defaultConnection {0}

add_connection phy_clk.out_clk xcvr0.phy_clk

add_connection phy_clk.out_clk xcvr1.phy_clk

add_connection reset.out_reset fc0.reset

add_connection reset.out_reset fc0_256_rx.in_rst_0

add_connection reset.out_reset fc0_rx_cdc.in_clk_reset

add_connection reset.out_reset fc0_rx_cdc.out_clk_reset

add_connection reset.out_reset fc0_rx_split.reset

add_connection reset.out_reset fc1.reset

add_connection reset.out_reset fc1_256_rx.in_rst_0

add_connection reset.out_reset fc1_rx_cdc.in_clk_reset

add_connection reset.out_reset fc1_rx_cdc.out_clk_reset

add_connection reset.out_reset fc1_rx_split.reset

add_connection reset.out_reset fifo_0to1.in_clk_reset

add_connection reset.out_reset fifo_0to1.out_clk_reset

add_connection reset.out_reset fifo_1to0.in_clk_reset

add_connection reset.out_reset fifo_1to0.out_clk_reset

add_connection reset.out_reset mm.reset

add_connection reset.out_reset rx_mux.reset

add_connection reset.out_reset xcvr0.reset

add_connection reset.out_reset xcvr1.reset

add_connection reset.out_reset xcvr_reconfig.mgmt_rst_reset

add_connection rx_mux_clk.out_clk fc0_rx_cdc.out_clk

add_connection rx_mux_clk.out_clk fc1_rx_cdc.out_clk

add_connection rx_mux_clk.out_clk rx_mux.clk

add_connection xcvr0.avrx fc0.avrx

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

add_connection xcvr0.rx_clk fc0.rx_clk

add_connection xcvr0.rx_clk fc0_256_rx.in_clk_0

add_connection xcvr0.rx_clk fc0_rx_cdc.in_clk

add_connection xcvr0.rx_clk fc0_rx_split.clk

add_connection xcvr0.rx_clk fifo_0to1.in_clk

add_connection xcvr0.tx_clk fc0.tx_clk

add_connection xcvr0.tx_clk fifo_1to0.out_clk

add_connection xcvr1.avrx fc1.avrx

add_connection xcvr1.rx_clk fc1.rx_clk

add_connection xcvr1.rx_clk fc1_256_rx.in_clk_0

add_connection xcvr1.rx_clk fc1_rx_cdc.in_clk

add_connection xcvr1.rx_clk fc1_rx_split.clk

add_connection xcvr1.rx_clk fifo_1to0.in_clk

add_connection xcvr1.tx_clk fc1.tx_clk

add_connection xcvr1.tx_clk fifo_0to1.out_clk

add_connection xcvr_reconfig.ch2_3_from_xcvr xcvr1.reconfig_from_xcvr
set_connection_parameter_value xcvr_reconfig.ch2_3_from_xcvr/xcvr1.reconfig_from_xcvr endPort {}
set_connection_parameter_value xcvr_reconfig.ch2_3_from_xcvr/xcvr1.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value xcvr_reconfig.ch2_3_from_xcvr/xcvr1.reconfig_from_xcvr startPort {}
set_connection_parameter_value xcvr_reconfig.ch2_3_from_xcvr/xcvr1.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value xcvr_reconfig.ch2_3_from_xcvr/xcvr1.reconfig_from_xcvr width {0}

add_connection xcvr_reconfig.ch2_3_to_xcvr xcvr1.reconfig_to_xcvr
set_connection_parameter_value xcvr_reconfig.ch2_3_to_xcvr/xcvr1.reconfig_to_xcvr endPort {}
set_connection_parameter_value xcvr_reconfig.ch2_3_to_xcvr/xcvr1.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value xcvr_reconfig.ch2_3_to_xcvr/xcvr1.reconfig_to_xcvr startPort {}
set_connection_parameter_value xcvr_reconfig.ch2_3_to_xcvr/xcvr1.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value xcvr_reconfig.ch2_3_to_xcvr/xcvr1.reconfig_to_xcvr width {0}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon_fc.qsys}
