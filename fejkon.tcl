# qsys scripting (.tcl) file for fejkon
package require -exact qsys 16.0

create_system {fejkon}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance ext0 clock_source 20.1
set_instance_parameter_value ext0 {clockFrequency} {50000000.0}
set_instance_parameter_value ext0 {clockFrequencyKnown} {1}
set_instance_parameter_value ext0 {resetSynchronousEdges} {NONE}

add_instance fc fejkon_fc 1.0

add_instance ident fejkon_identity 1.0
set_instance_parameter_value ident {Ports} {2}

add_instance jtagm altera_jtag_avalon_master 20.1
set_instance_parameter_value jtagm {FAST_VER} {0}
set_instance_parameter_value jtagm {FIFO_DEPTHS} {2}
set_instance_parameter_value jtagm {PLI_PORT} {50000}
set_instance_parameter_value jtagm {USE_PLI} {0}

add_instance led fejkon_led 1.0

add_instance pcie fejkon_pcie 1.0

add_instance pcie_clk_gauge freq_gauge 1.0

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

add_instance sfp0 fejkon_sfp 1.0

add_instance sfp1 fejkon_sfp 1.0

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

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF ext0.clk_in
add_interface fan conduit end
set_interface_property fan EXPORT_OF temp.fan
add_interface fcport0_line_rd conduit end
set_interface_property fcport0_line_rd EXPORT_OF fc.fcport0_line_rd
add_interface fcport0_line_td conduit end
set_interface_property fcport0_line_td EXPORT_OF fc.fcport0_line_td
add_interface fcport1_line_rd conduit end
set_interface_property fcport1_line_rd EXPORT_OF fc.fcport1_line_rd
add_interface fcport1_line_td conduit end
set_interface_property fcport1_line_td EXPORT_OF fc.fcport1_line_td
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
add_connection ext0.clk fc.mgmt_clk

add_connection ext0.clk ident.clk

add_connection ext0.clk jtagm.clk

add_connection ext0.clk led.clk

add_connection ext0.clk pcie.mgmt_clk

add_connection ext0.clk pcie_clk_gauge.ref_clk

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

add_connection fc.fc0_active led.fcport0_active
set_connection_parameter_value fc.fc0_active/led.fcport0_active endPort {}
set_connection_parameter_value fc.fc0_active/led.fcport0_active endPortLSB {0}
set_connection_parameter_value fc.fc0_active/led.fcport0_active startPort {}
set_connection_parameter_value fc.fc0_active/led.fcport0_active startPortLSB {0}
set_connection_parameter_value fc.fc0_active/led.fcport0_active width {0}

add_connection fc.fc1_active led.fcport1_active
set_connection_parameter_value fc.fc1_active/led.fcport1_active endPort {}
set_connection_parameter_value fc.fc1_active/led.fcport1_active endPortLSB {0}
set_connection_parameter_value fc.fc1_active/led.fcport1_active startPort {}
set_connection_parameter_value fc.fc1_active/led.fcport1_active startPortLSB {0}
set_connection_parameter_value fc.fc1_active/led.fcport1_active width {0}

add_connection fc.rx_mux pcie.data_tx

add_connection fc.xcvr0_aligned led.fcport0_aligned
set_connection_parameter_value fc.xcvr0_aligned/led.fcport0_aligned endPort {}
set_connection_parameter_value fc.xcvr0_aligned/led.fcport0_aligned endPortLSB {0}
set_connection_parameter_value fc.xcvr0_aligned/led.fcport0_aligned startPort {}
set_connection_parameter_value fc.xcvr0_aligned/led.fcport0_aligned startPortLSB {0}
set_connection_parameter_value fc.xcvr0_aligned/led.fcport0_aligned width {0}

add_connection fc.xcvr1_aligned led.fcport1_aligned
set_connection_parameter_value fc.xcvr1_aligned/led.fcport1_aligned endPort {}
set_connection_parameter_value fc.xcvr1_aligned/led.fcport1_aligned endPortLSB {0}
set_connection_parameter_value fc.xcvr1_aligned/led.fcport1_aligned startPort {}
set_connection_parameter_value fc.xcvr1_aligned/led.fcport1_aligned startPortLSB {0}
set_connection_parameter_value fc.xcvr1_aligned/led.fcport1_aligned width {0}

add_connection jtagm.master fc.mgmt_mm
set_connection_parameter_value jtagm.master/fc.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fc.mgmt_mm baseAddress {0x8000}
set_connection_parameter_value jtagm.master/fc.mgmt_mm defaultConnection {0}

add_connection jtagm.master ident.mm
set_connection_parameter_value jtagm.master/ident.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/ident.mm baseAddress {0x0000}
set_connection_parameter_value jtagm.master/ident.mm defaultConnection {0}

add_connection jtagm.master pcie.csr_mm
set_connection_parameter_value jtagm.master/pcie.csr_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/pcie.csr_mm baseAddress {0x0800}
set_connection_parameter_value jtagm.master/pcie.csr_mm defaultConnection {0}

add_connection jtagm.master pcie_clk_gauge.mm
set_connection_parameter_value jtagm.master/pcie_clk_gauge.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/pcie_clk_gauge.mm baseAddress {0x0024}
set_connection_parameter_value jtagm.master/pcie_clk_gauge.mm defaultConnection {0}

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

add_connection jtagm.master temp.temp_mm
set_connection_parameter_value jtagm.master/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value jtagm.master/temp.temp_mm defaultConnection {0}

add_connection jtagm.master_reset reset_ctrl.reset_in1

add_connection led.xcvr_reconfig fc.reconfig_busy
set_connection_parameter_value led.xcvr_reconfig/fc.reconfig_busy endPort {}
set_connection_parameter_value led.xcvr_reconfig/fc.reconfig_busy endPortLSB {0}
set_connection_parameter_value led.xcvr_reconfig/fc.reconfig_busy startPort {}
set_connection_parameter_value led.xcvr_reconfig/fc.reconfig_busy startPortLSB {0}
set_connection_parameter_value led.xcvr_reconfig/fc.reconfig_busy width {0}

add_connection pcie.bar0_mm fc.mgmt_mm
set_connection_parameter_value pcie.bar0_mm/fc.mgmt_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/fc.mgmt_mm baseAddress {0x8000}
set_connection_parameter_value pcie.bar0_mm/fc.mgmt_mm defaultConnection {0}

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
set_connection_parameter_value pcie.bar0_mm/sfp0.mm baseAddress {0x0100}
set_connection_parameter_value pcie.bar0_mm/sfp0.mm defaultConnection {0}

add_connection pcie.bar0_mm sfp1.mm
set_connection_parameter_value pcie.bar0_mm/sfp1.mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/sfp1.mm baseAddress {0x0200}
set_connection_parameter_value pcie.bar0_mm/sfp1.mm defaultConnection {0}

add_connection pcie.bar0_mm temp.temp_mm
set_connection_parameter_value pcie.bar0_mm/temp.temp_mm arbitrationPriority {1}
set_connection_parameter_value pcie.bar0_mm/temp.temp_mm baseAddress {0x0010}
set_connection_parameter_value pcie.bar0_mm/temp.temp_mm defaultConnection {0}

add_connection pcie.data_clk fc.rx_mux_clk

add_connection pcie.data_clk pcie_clk_gauge.probe_clk

add_connection pcie.irq sfp0.i2c_irq
set_connection_parameter_value pcie.irq/sfp0.i2c_irq irqNumber {3}

add_connection pcie.irq sfp1.i2c_irq
set_connection_parameter_value pcie.irq/sfp1.i2c_irq irqNumber {4}

add_connection phy_clk.out_clk fc.phy_clk

add_connection phy_clk.out_clk phy_clk_gauge.probe_clk

add_connection phy_clk.out_clk phy_clk_out.in_clk

add_connection reset_ctrl.reset_out fc.reset

add_connection reset_ctrl.reset_out ident.reset

add_connection reset_ctrl.reset_out pcie.mgmt_rst

add_connection reset_ctrl.reset_out pcie_clk_gauge.reset

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
set_interconnect_requirement {fc.mgmt_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {ident.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.bar0_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {pcie.csr_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {phy_clk_gauge.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {sfp0.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {sfp1.mm} {qsys_mm.insertPerformanceMonitor} {TRUE}
set_interconnect_requirement {temp.temp_mm} {qsys_mm.insertPerformanceMonitor} {TRUE}

save_system {fejkon.qsys}
