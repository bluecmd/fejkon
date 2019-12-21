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

add_instance fc0 fc_framer 1.0

add_instance fc0_256_rx altera_avalon_st_adapter 19.1
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

add_instance fc0_pcie_tx altera_avalon_dc_fifo 19.1
set_instance_parameter_value fc0_pcie_tx {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc0_pcie_tx {CHANNEL_WIDTH} {0}
set_instance_parameter_value fc0_pcie_tx {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc0_pcie_tx {ERROR_WIDTH} {0}
set_instance_parameter_value fc0_pcie_tx {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc0_pcie_tx {FIFO_DEPTH} {512}
set_instance_parameter_value fc0_pcie_tx {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fc0_pcie_tx {SYMBOLS_PER_BEAT} {32}
set_instance_parameter_value fc0_pcie_tx {USE_IN_FILL_LEVEL} {1}
set_instance_parameter_value fc0_pcie_tx {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fc0_pcie_tx {USE_PACKETS} {1}
set_instance_parameter_value fc0_pcie_tx {WR_SYNC_DEPTH} {3}

add_instance fc0_rx altera_avalon_st_splitter 19.1
set_instance_parameter_value fc0_rx {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc0_rx {CHANNEL_WIDTH} {1}
set_instance_parameter_value fc0_rx {DATA_WIDTH} {32}
set_instance_parameter_value fc0_rx {ERROR_DESCRIPTOR} {}
set_instance_parameter_value fc0_rx {ERROR_WIDTH} {1}
set_instance_parameter_value fc0_rx {MAX_CHANNELS} {1}
set_instance_parameter_value fc0_rx {NUMBER_OF_OUTPUTS} {2}
set_instance_parameter_value fc0_rx {QUALIFY_VALID_OUT} {1}
set_instance_parameter_value fc0_rx {READY_LATENCY} {0}
set_instance_parameter_value fc0_rx {USE_CHANNEL} {0}
set_instance_parameter_value fc0_rx {USE_DATA} {1}
set_instance_parameter_value fc0_rx {USE_ERROR} {0}
set_instance_parameter_value fc0_rx {USE_PACKETS} {1}
set_instance_parameter_value fc0_rx {USE_READY} {1}
set_instance_parameter_value fc0_rx {USE_VALID} {1}

add_instance fc1 fc_framer 1.0

add_instance fc1_256_rx altera_avalon_st_adapter 19.1
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

add_instance fc1_pcie_tx altera_avalon_dc_fifo 19.1
set_instance_parameter_value fc1_pcie_tx {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc1_pcie_tx {CHANNEL_WIDTH} {0}
set_instance_parameter_value fc1_pcie_tx {ENABLE_EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc1_pcie_tx {ERROR_WIDTH} {0}
set_instance_parameter_value fc1_pcie_tx {EXPLICIT_MAXCHANNEL} {0}
set_instance_parameter_value fc1_pcie_tx {FIFO_DEPTH} {512}
set_instance_parameter_value fc1_pcie_tx {RD_SYNC_DEPTH} {3}
set_instance_parameter_value fc1_pcie_tx {SYMBOLS_PER_BEAT} {32}
set_instance_parameter_value fc1_pcie_tx {USE_IN_FILL_LEVEL} {1}
set_instance_parameter_value fc1_pcie_tx {USE_OUT_FILL_LEVEL} {0}
set_instance_parameter_value fc1_pcie_tx {USE_PACKETS} {1}
set_instance_parameter_value fc1_pcie_tx {WR_SYNC_DEPTH} {3}

add_instance fc1_rx altera_avalon_st_splitter 19.1
set_instance_parameter_value fc1_rx {BITS_PER_SYMBOL} {8}
set_instance_parameter_value fc1_rx {CHANNEL_WIDTH} {1}
set_instance_parameter_value fc1_rx {DATA_WIDTH} {32}
set_instance_parameter_value fc1_rx {ERROR_DESCRIPTOR} {}
set_instance_parameter_value fc1_rx {ERROR_WIDTH} {1}
set_instance_parameter_value fc1_rx {MAX_CHANNELS} {1}
set_instance_parameter_value fc1_rx {NUMBER_OF_OUTPUTS} {2}
set_instance_parameter_value fc1_rx {QUALIFY_VALID_OUT} {1}
set_instance_parameter_value fc1_rx {READY_LATENCY} {0}
set_instance_parameter_value fc1_rx {USE_CHANNEL} {0}
set_instance_parameter_value fc1_rx {USE_DATA} {1}
set_instance_parameter_value fc1_rx {USE_ERROR} {0}
set_instance_parameter_value fc1_rx {USE_PACKETS} {1}
set_instance_parameter_value fc1_rx {USE_READY} {1}
set_instance_parameter_value fc1_rx {USE_VALID} {1}

add_instance fifo_0to1 altera_avalon_dc_fifo 19.1
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

add_instance fifo_1to0 altera_avalon_dc_fifo 19.1
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

add_instance ident fejkon_identity 1.0
set_instance_parameter_value ident {Ports} {2}

add_instance jtagm altera_jtag_avalon_master 19.1
set_instance_parameter_value jtagm {FAST_VER} {0}
set_instance_parameter_value jtagm {FIFO_DEPTHS} {2}
set_instance_parameter_value jtagm {PLI_PORT} {50000}
set_instance_parameter_value jtagm {USE_PLI} {0}

add_instance led fejkon_led 1.0

add_instance pcie fejkon_pcie 1.0

add_instance pcie_data_tx_multiplex multiplexer 19.1
set_instance_parameter_value pcie_data_tx_multiplex {bitsPerSymbol} {8}
set_instance_parameter_value pcie_data_tx_multiplex {errorWidth} {0}
set_instance_parameter_value pcie_data_tx_multiplex {numInputInterfaces} {4}
set_instance_parameter_value pcie_data_tx_multiplex {outChannelWidth} {2}
set_instance_parameter_value pcie_data_tx_multiplex {packetScheduling} {1}
set_instance_parameter_value pcie_data_tx_multiplex {schedulingSize} {2}
set_instance_parameter_value pcie_data_tx_multiplex {symbolsPerBeat} {32}
set_instance_parameter_value pcie_data_tx_multiplex {useHighBitsOfChannel} {1}
set_instance_parameter_value pcie_data_tx_multiplex {usePackets} {1}

add_instance phy_clk altera_clock_bridge 19.1
set_instance_parameter_value phy_clk {EXPLICIT_CLOCK_RATE} {106250000.0}
set_instance_parameter_value phy_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance phy_clk_gauge freq_gauge 1.0

add_instance phy_clk_out altera_clock_bridge 19.1
set_instance_parameter_value phy_clk_out {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value phy_clk_out {NUM_CLOCK_OUTPUTS} {1}

add_instance reset_ctrl altera_reset_controller 19.1
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

add_instance sfp0 fejkon_sfp 1.0

add_instance sfp1 fejkon_sfp 1.0

add_instance si570_ctrl si570_ctrl 1.0
set_instance_parameter_value si570_ctrl {I2CAddress} {0}
set_instance_parameter_value si570_ctrl {RecallFrequency} {100000000}
set_instance_parameter_value si570_ctrl {TargetFrequency} {106250000}

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
add_interface fcport0_line_rd conduit end
set_interface_property fcport0_line_rd EXPORT_OF xcvr0.line_rd
add_interface fcport0_line_td conduit end
set_interface_property fcport0_line_td EXPORT_OF xcvr0.line_td
add_interface fcport1_line_rd conduit end
set_interface_property fcport1_line_rd EXPORT_OF xcvr1.line_rd
add_interface fcport1_line_td conduit end
set_interface_property fcport1_line_td EXPORT_OF xcvr1.line_td
add_interface led conduit end
set_interface_property led EXPORT_OF led.led
add_interface pcie_refclk clock sink
set_interface_property pcie_refclk EXPORT_OF pcie.pcie_refclk
add_interface pcie_reset_pin conduit end
set_interface_property pcie_reset_pin EXPORT_OF pcie.pcie_reset_pin
add_interface pcie_serial conduit end
set_interface_property pcie_serial EXPORT_OF pcie.phy_serial
add_interface phy_clk clock sink
set_interface_property phy_clk EXPORT_OF phy_clk.in_clk
add_interface phy_clk_out clock source
set_interface_property phy_clk_out EXPORT_OF phy_clk_out.out_clk
add_interface reset reset sink
set_interface_property reset EXPORT_OF ext0.clk_in_reset
add_interface sfp0_sfp conduit end
set_interface_property sfp0_sfp EXPORT_OF sfp0.sfp
add_interface sfp1_sfp conduit end
set_interface_property sfp1_sfp EXPORT_OF sfp1.sfp
add_interface si570_i2c conduit end
set_interface_property si570_i2c EXPORT_OF si570_ctrl.si570_i2c

# connections and connection parameters
add_connection ext0.clk fc0.mgmt_clk

add_connection ext0.clk fc1.mgmt_clk

add_connection ext0.clk ident.clk

add_connection ext0.clk jtagm.clk

add_connection ext0.clk led.clk

add_connection ext0.clk pcie.mgmt_clk

add_connection ext0.clk phy_clk_gauge.ref_clk

add_connection ext0.clk reset_ctrl.clk

add_connection ext0.clk sfp0.clk

add_connection ext0.clk sfp1.clk

add_connection ext0.clk si570_ctrl.clk

add_connection ext0.clk temp.clk

add_connection ext0.clk temp_sense.clk

add_connection ext0.clk xcvr0.mgmt_clk

add_connection ext0.clk xcvr1.mgmt_clk

add_connection ext0.clk xcvr_reconfig.mgmt_clk_clk

add_connection ext0.clk_reset jtagm.clk_reset

add_connection ext0.clk_reset reset_ctrl.reset_in0

add_connection ext0.clk_reset si570_ctrl.reset

add_connection fc0.active led.fcport0_active
set_connection_parameter_value fc0.active/led.fcport0_active endPort {}
set_connection_parameter_value fc0.active/led.fcport0_active endPortLSB {0}
set_connection_parameter_value fc0.active/led.fcport0_active startPort {}
set_connection_parameter_value fc0.active/led.fcport0_active startPortLSB {0}
set_connection_parameter_value fc0.active/led.fcport0_active width {0}

add_connection fc0.avtx xcvr0.avtx

add_connection fc0.userrx fc0_rx.in

add_connection fc0_256_rx.out_0 fc0_pcie_tx.in

add_connection fc0_pcie_tx.out pcie_data_tx_multiplex.in0

add_connection fc0_rx.out0 fifo_0to1.in

add_connection fc0_rx.out1 fc0_256_rx.in_0

add_connection fc1.active led.fcport1_active
set_connection_parameter_value fc1.active/led.fcport1_active endPort {}
set_connection_parameter_value fc1.active/led.fcport1_active endPortLSB {0}
set_connection_parameter_value fc1.active/led.fcport1_active startPort {}
set_connection_parameter_value fc1.active/led.fcport1_active startPortLSB {0}
set_connection_parameter_value fc1.active/led.fcport1_active width {0}

add_connection fc1.avtx xcvr1.avtx

add_connection fc1.userrx fc1_rx.in

add_connection fc1_256_rx.out_0 fc1_pcie_tx.in

add_connection fc1_pcie_tx.out pcie_data_tx_multiplex.in1

add_connection fc1_rx.out0 fifo_1to0.in

add_connection fc1_rx.out1 fc1_256_rx.in_0

add_connection fifo_0to1.out fc1.usertx

add_connection fifo_1to0.out fc0.usertx

add_connection jtagm.master fc0.mgmt_mm
set_connection_parameter_value jtagm.master/fc0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fc0.mgmt_mm baseAddress {0x00012000}
set_connection_parameter_value jtagm.master/fc0.mgmt_mm defaultConnection {0}

add_connection jtagm.master fc0_pcie_tx.in_csr
set_connection_parameter_value jtagm.master/fc0_pcie_tx.in_csr arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fc0_pcie_tx.in_csr baseAddress {0xffff1000}
set_connection_parameter_value jtagm.master/fc0_pcie_tx.in_csr defaultConnection {0}

add_connection jtagm.master fc1.mgmt_mm
set_connection_parameter_value jtagm.master/fc1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fc1.mgmt_mm baseAddress {0x00022000}
set_connection_parameter_value jtagm.master/fc1.mgmt_mm defaultConnection {0}

add_connection jtagm.master fc1_pcie_tx.in_csr
set_connection_parameter_value jtagm.master/fc1_pcie_tx.in_csr arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fc1_pcie_tx.in_csr baseAddress {0xffff2000}
set_connection_parameter_value jtagm.master/fc1_pcie_tx.in_csr defaultConnection {0}

add_connection jtagm.master ident.mm
set_connection_parameter_value jtagm.master/ident.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/ident.mm baseAddress {0x0000}
set_connection_parameter_value jtagm.master/ident.mm defaultConnection {0}

add_connection jtagm.master pcie.csr_mm
set_connection_parameter_value jtagm.master/pcie.csr_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/pcie.csr_mm baseAddress {0x0800}
set_connection_parameter_value jtagm.master/pcie.csr_mm defaultConnection {0}

add_connection jtagm.master phy_clk_gauge.mm
set_connection_parameter_value jtagm.master/phy_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/phy_clk_gauge.mm baseAddress {0x0020}
set_connection_parameter_value jtagm.master/phy_clk_gauge.mm defaultConnection {0}

add_connection jtagm.master sfp0.mm
set_connection_parameter_value jtagm.master/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp0.mm baseAddress {0x1000}
set_connection_parameter_value jtagm.master/sfp0.mm defaultConnection {0}

add_connection jtagm.master sfp1.mm
set_connection_parameter_value jtagm.master/sfp1.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp1.mm baseAddress {0x2000}
set_connection_parameter_value jtagm.master/sfp1.mm defaultConnection {0}

add_connection jtagm.master temp.temp_mm
set_connection_parameter_value jtagm.master/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value jtagm.master/temp.temp_mm defaultConnection {0}

add_connection jtagm.master xcvr0.mgmt_mm
set_connection_parameter_value jtagm.master/xcvr0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/xcvr0.mgmt_mm baseAddress {0x00010000}
set_connection_parameter_value jtagm.master/xcvr0.mgmt_mm defaultConnection {0}

add_connection jtagm.master xcvr1.mgmt_mm
set_connection_parameter_value jtagm.master/xcvr1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/xcvr1.mgmt_mm baseAddress {0x00020000}
set_connection_parameter_value jtagm.master/xcvr1.mgmt_mm defaultConnection {0}

add_connection jtagm.master xcvr_reconfig.reconfig_mgmt
set_connection_parameter_value jtagm.master/xcvr_reconfig.reconfig_mgmt arbitrationPriority {1}
set_connection_parameter_value jtagm.master/xcvr_reconfig.reconfig_mgmt baseAddress {0xffff0000}
set_connection_parameter_value jtagm.master/xcvr_reconfig.reconfig_mgmt defaultConnection {0}

add_connection jtagm.master_reset reset_ctrl.reset_in1

add_connection pcie.bar0_mm fc0.mgmt_mm
set_connection_parameter_value pcie.bar0_mm/fc0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/fc0.mgmt_mm baseAddress {0x00012000}
set_connection_parameter_value pcie.bar0_mm/fc0.mgmt_mm defaultConnection {0}

add_connection pcie.bar0_mm fc1.mgmt_mm
set_connection_parameter_value pcie.bar0_mm/fc1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/fc1.mgmt_mm baseAddress {0x00022000}
set_connection_parameter_value pcie.bar0_mm/fc1.mgmt_mm defaultConnection {0}

add_connection pcie.bar0_mm ident.mm
set_connection_parameter_value pcie.bar0_mm/ident.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/ident.mm baseAddress {0x0000}
set_connection_parameter_value pcie.bar0_mm/ident.mm defaultConnection {0}

add_connection pcie.bar0_mm pcie.csr_mm
set_connection_parameter_value pcie.bar0_mm/pcie.csr_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/pcie.csr_mm baseAddress {0x0800}
set_connection_parameter_value pcie.bar0_mm/pcie.csr_mm defaultConnection {0}

add_connection pcie.bar0_mm phy_clk_gauge.mm
set_connection_parameter_value pcie.bar0_mm/phy_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/phy_clk_gauge.mm baseAddress {0x0020}
set_connection_parameter_value pcie.bar0_mm/phy_clk_gauge.mm defaultConnection {0}

add_connection pcie.bar0_mm sfp0.mm
set_connection_parameter_value pcie.bar0_mm/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/sfp0.mm baseAddress {0x1000}
set_connection_parameter_value pcie.bar0_mm/sfp0.mm defaultConnection {0}

add_connection pcie.bar0_mm sfp1.mm
set_connection_parameter_value pcie.bar0_mm/sfp1.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/sfp1.mm baseAddress {0x2000}
set_connection_parameter_value pcie.bar0_mm/sfp1.mm defaultConnection {0}

add_connection pcie.bar0_mm temp.temp_mm
set_connection_parameter_value pcie.bar0_mm/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value pcie.bar0_mm/temp.temp_mm defaultConnection {0}

add_connection pcie.bar0_mm xcvr0.mgmt_mm
set_connection_parameter_value pcie.bar0_mm/xcvr0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/xcvr0.mgmt_mm baseAddress {0x00010000}
set_connection_parameter_value pcie.bar0_mm/xcvr0.mgmt_mm defaultConnection {0}

add_connection pcie.bar0_mm xcvr1.mgmt_mm
set_connection_parameter_value pcie.bar0_mm/xcvr1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/xcvr1.mgmt_mm baseAddress {0x00020000}
set_connection_parameter_value pcie.bar0_mm/xcvr1.mgmt_mm defaultConnection {0}

add_connection pcie.data_clk fc0_pcie_tx.out_clk

add_connection pcie.data_clk fc1_pcie_tx.out_clk

add_connection pcie.data_clk pcie_data_tx_multiplex.clk

add_connection pcie.irq sfp0.i2c_irq
set_connection_parameter_value pcie.irq/sfp0.i2c_irq irqNumber {3}

add_connection pcie.irq sfp1.i2c_irq
set_connection_parameter_value pcie.irq/sfp1.i2c_irq irqNumber {4}

add_connection pcie_data_tx_multiplex.out pcie.data_tx

add_connection phy_clk.out_clk phy_clk_gauge.probe_clk

add_connection phy_clk.out_clk phy_clk_out.in_clk

add_connection phy_clk.out_clk xcvr0.phy_clk

add_connection phy_clk.out_clk xcvr1.phy_clk

add_connection reset_ctrl.reset_out fc0.reset

add_connection reset_ctrl.reset_out fc0_256_rx.in_rst_0

add_connection reset_ctrl.reset_out fc0_pcie_tx.in_clk_reset

add_connection reset_ctrl.reset_out fc0_pcie_tx.out_clk_reset

add_connection reset_ctrl.reset_out fc0_rx.reset

add_connection reset_ctrl.reset_out fc1.reset

add_connection reset_ctrl.reset_out fc1_256_rx.in_rst_0

add_connection reset_ctrl.reset_out fc1_pcie_tx.in_clk_reset

add_connection reset_ctrl.reset_out fc1_pcie_tx.out_clk_reset

add_connection reset_ctrl.reset_out fc1_rx.reset

add_connection reset_ctrl.reset_out fifo_0to1.in_clk_reset

add_connection reset_ctrl.reset_out fifo_0to1.out_clk_reset

add_connection reset_ctrl.reset_out fifo_1to0.in_clk_reset

add_connection reset_ctrl.reset_out fifo_1to0.out_clk_reset

add_connection reset_ctrl.reset_out ident.reset

add_connection reset_ctrl.reset_out pcie.mgmt_rst

add_connection reset_ctrl.reset_out pcie_data_tx_multiplex.reset

add_connection reset_ctrl.reset_out phy_clk_gauge.reset

add_connection reset_ctrl.reset_out sfp0.reset

add_connection reset_ctrl.reset_out sfp1.reset

add_connection reset_ctrl.reset_out temp.reset

add_connection reset_ctrl.reset_out xcvr0.reset

add_connection reset_ctrl.reset_out xcvr1.reset

add_connection reset_ctrl.reset_out xcvr_reconfig.mgmt_rst_reset

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

add_connection xcvr0.aligned led.fcport0_aligned
set_connection_parameter_value xcvr0.aligned/led.fcport0_aligned endPort {}
set_connection_parameter_value xcvr0.aligned/led.fcport0_aligned endPortLSB {0}
set_connection_parameter_value xcvr0.aligned/led.fcport0_aligned startPort {}
set_connection_parameter_value xcvr0.aligned/led.fcport0_aligned startPortLSB {0}
set_connection_parameter_value xcvr0.aligned/led.fcport0_aligned width {0}

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

add_connection xcvr0.rx_clk fc0_pcie_tx.in_clk

add_connection xcvr0.rx_clk fc0_rx.clk

add_connection xcvr0.rx_clk fifo_0to1.in_clk

add_connection xcvr0.tx_clk fc0.tx_clk

add_connection xcvr0.tx_clk fifo_1to0.out_clk

add_connection xcvr1.aligned led.fcport1_aligned
set_connection_parameter_value xcvr1.aligned/led.fcport1_aligned endPort {}
set_connection_parameter_value xcvr1.aligned/led.fcport1_aligned endPortLSB {0}
set_connection_parameter_value xcvr1.aligned/led.fcport1_aligned startPort {}
set_connection_parameter_value xcvr1.aligned/led.fcport1_aligned startPortLSB {0}
set_connection_parameter_value xcvr1.aligned/led.fcport1_aligned width {0}

add_connection xcvr1.avrx fc1.avrx

add_connection xcvr1.rx_clk fc1.rx_clk

add_connection xcvr1.rx_clk fc1_256_rx.in_clk_0

add_connection xcvr1.rx_clk fc1_pcie_tx.in_clk

add_connection xcvr1.rx_clk fc1_rx.clk

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

add_connection xcvr_reconfig.reconfig_busy led.xcvr_reconfig
set_connection_parameter_value xcvr_reconfig.reconfig_busy/led.xcvr_reconfig endPort {}
set_connection_parameter_value xcvr_reconfig.reconfig_busy/led.xcvr_reconfig endPortLSB {0}
set_connection_parameter_value xcvr_reconfig.reconfig_busy/led.xcvr_reconfig startPort {}
set_connection_parameter_value xcvr_reconfig.reconfig_busy/led.xcvr_reconfig startPortLSB {0}
set_connection_parameter_value xcvr_reconfig.reconfig_busy/led.xcvr_reconfig width {0}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.enableInstrumentation} {TRUE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {fc0.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fc1.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fcport0.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fcport0.rx_dma_m} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fcport0.setup} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {fcport0.tx_dma_m} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {jtagm.master} {qsys_mm.insertPerformanceMonitor} {FALSE}
set_interconnect_requirement {pcie.bar0_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.read_mem_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.write_mem_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {sfp0.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {sfp1.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {xcvr0.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {xcvr1.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}

save_system {fejkon.qsys}
