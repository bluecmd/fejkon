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

add_instance fc1 fc_framer 1.0

add_instance fcport0 fejkon_fcport 1.0

add_instance fcport1 fejkon_fcport 1.0

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

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF ext0.clk_in
add_interface fcport0_line_rd conduit end
set_interface_property fcport0_line_rd EXPORT_OF fcport0.line_rd
add_interface fcport0_line_td conduit end
set_interface_property fcport0_line_td EXPORT_OF fcport0.line_td
add_interface fcport1_line_rd conduit end
set_interface_property fcport1_line_rd EXPORT_OF fcport1.line_rd
add_interface fcport1_line_td conduit end
set_interface_property fcport1_line_td EXPORT_OF fcport1.line_td
add_interface led conduit end
set_interface_property led EXPORT_OF led.external_connection
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

add_connection ext0.clk fcport0.mgmt_clk

add_connection ext0.clk fcport1.mgmt_clk

add_connection ext0.clk ident.clk

add_connection ext0.clk jtagm.clk

add_connection ext0.clk led.clk

add_connection ext0.clk pcie.bar2_clk

add_connection ext0.clk pcie.mgmt_clk

add_connection ext0.clk pcie.read_mem_clk

add_connection ext0.clk pcie.write_mem_clk

add_connection ext0.clk phy_clk_gauge.ref_clk

add_connection ext0.clk reset_ctrl.clk

add_connection ext0.clk sfp0.clk

add_connection ext0.clk sfp1.clk

add_connection ext0.clk si570_ctrl.clk

add_connection ext0.clk temp.clk

add_connection ext0.clk temp_sense.clk

add_connection ext0.clk_reset jtagm.clk_reset

add_connection ext0.clk_reset reset_ctrl.reset_in0

add_connection ext0.clk_reset si570_ctrl.reset

add_connection fc0.avtx fcport0.tx_st

add_connection fc0.userrx fifo_0to1.in

add_connection fc1.avtx fcport1.tx_st

add_connection fc1.userrx fifo_1to0.in

add_connection fcport0.rx_clk fc0.rx_clk

add_connection fcport0.rx_clk fifo_0to1.in_clk

add_connection fcport0.rx_st fc0.avrx

add_connection fcport0.tx_clk fc0.tx_clk

add_connection fcport0.tx_clk fifo_1to0.out_clk

add_connection fcport1.rx_clk fc1.rx_clk

add_connection fcport1.rx_clk fifo_1to0.in_clk

add_connection fcport1.rx_st fc1.avrx

add_connection fcport1.tx_clk fc1.tx_clk

add_connection fcport1.tx_clk fifo_0to1.out_clk

add_connection fifo_0to1.out fc1.usertx

add_connection fifo_1to0.out fc0.usertx

add_connection jtagm.master fc0.mgmt_mm
set_connection_parameter_value jtagm.master/fc0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fc0.mgmt_mm baseAddress {0x00012000}
set_connection_parameter_value jtagm.master/fc0.mgmt_mm defaultConnection {0}

add_connection jtagm.master fc1.mgmt_mm
set_connection_parameter_value jtagm.master/fc1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fc1.mgmt_mm baseAddress {0x00022000}
set_connection_parameter_value jtagm.master/fc1.mgmt_mm defaultConnection {0}

add_connection jtagm.master fcport0.mgmt_mm
set_connection_parameter_value jtagm.master/fcport0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fcport0.mgmt_mm baseAddress {0x00010000}
set_connection_parameter_value jtagm.master/fcport0.mgmt_mm defaultConnection {0}

add_connection jtagm.master fcport1.mgmt_mm
set_connection_parameter_value jtagm.master/fcport1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fcport1.mgmt_mm baseAddress {0x00020000}
set_connection_parameter_value jtagm.master/fcport1.mgmt_mm defaultConnection {0}

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

add_connection jtagm.master_reset reset_ctrl.reset_in1

add_connection pcie.bar2_mm fc0.mgmt_mm
set_connection_parameter_value pcie.bar2_mm/fc0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/fc0.mgmt_mm baseAddress {0x00012000}
set_connection_parameter_value pcie.bar2_mm/fc0.mgmt_mm defaultConnection {0}

add_connection pcie.bar2_mm fc1.mgmt_mm
set_connection_parameter_value pcie.bar2_mm/fc1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/fc1.mgmt_mm baseAddress {0x00022000}
set_connection_parameter_value pcie.bar2_mm/fc1.mgmt_mm defaultConnection {0}

add_connection pcie.bar2_mm fcport0.mgmt_mm
set_connection_parameter_value pcie.bar2_mm/fcport0.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/fcport0.mgmt_mm baseAddress {0x00010000}
set_connection_parameter_value pcie.bar2_mm/fcport0.mgmt_mm defaultConnection {0}

add_connection pcie.bar2_mm fcport1.mgmt_mm
set_connection_parameter_value pcie.bar2_mm/fcport1.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/fcport1.mgmt_mm baseAddress {0x00020000}
set_connection_parameter_value pcie.bar2_mm/fcport1.mgmt_mm defaultConnection {0}

add_connection pcie.bar2_mm ident.mm
set_connection_parameter_value pcie.bar2_mm/ident.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/ident.mm baseAddress {0x0000}
set_connection_parameter_value pcie.bar2_mm/ident.mm defaultConnection {0}

add_connection pcie.bar2_mm phy_clk_gauge.mm
set_connection_parameter_value pcie.bar2_mm/phy_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/phy_clk_gauge.mm baseAddress {0x0020}
set_connection_parameter_value pcie.bar2_mm/phy_clk_gauge.mm defaultConnection {0}

add_connection pcie.bar2_mm sfp0.mm
set_connection_parameter_value pcie.bar2_mm/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/sfp0.mm baseAddress {0x1000}
set_connection_parameter_value pcie.bar2_mm/sfp0.mm defaultConnection {0}

add_connection pcie.bar2_mm sfp1.mm
set_connection_parameter_value pcie.bar2_mm/sfp1.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/sfp1.mm baseAddress {0x2000}
set_connection_parameter_value pcie.bar2_mm/sfp1.mm defaultConnection {0}

add_connection pcie.bar2_mm temp.temp_mm
set_connection_parameter_value pcie.bar2_mm/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar2_mm/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value pcie.bar2_mm/temp.temp_mm defaultConnection {0}

add_connection phy_clk.out_clk fcport0.phy_clk

add_connection phy_clk.out_clk fcport1.phy_clk

add_connection phy_clk.out_clk phy_clk_gauge.probe_clk

add_connection phy_clk.out_clk phy_clk_out.in_clk

add_connection reset_ctrl.reset_out fc0.reset

add_connection reset_ctrl.reset_out fc1.reset

add_connection reset_ctrl.reset_out fcport0.reset

add_connection reset_ctrl.reset_out fcport1.reset

add_connection reset_ctrl.reset_out fifo_0to1.in_clk_reset

add_connection reset_ctrl.reset_out fifo_0to1.out_clk_reset

add_connection reset_ctrl.reset_out fifo_1to0.in_clk_reset

add_connection reset_ctrl.reset_out fifo_1to0.out_clk_reset

add_connection reset_ctrl.reset_out ident.reset

add_connection reset_ctrl.reset_out led.reset

add_connection reset_ctrl.reset_out pcie.bar2_reset

add_connection reset_ctrl.reset_out pcie.mgmt_rst

add_connection reset_ctrl.reset_out phy_clk_gauge.reset

add_connection reset_ctrl.reset_out sfp0.reset

add_connection reset_ctrl.reset_out sfp1.reset

add_connection reset_ctrl.reset_out temp.reset

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
