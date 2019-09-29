# qsys scripting (.tcl) file for fejkon
package require -exact qsys 16.0

create_system {fejkon}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance chipmem0 altera_avalon_onchip_memory2 18.1
set_instance_parameter_value chipmem0 {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value chipmem0 {blockType} {AUTO}
set_instance_parameter_value chipmem0 {copyInitFile} {0}
set_instance_parameter_value chipmem0 {dataWidth} {32}
set_instance_parameter_value chipmem0 {dataWidth2} {32}
set_instance_parameter_value chipmem0 {dualPort} {1}
set_instance_parameter_value chipmem0 {ecc_enabled} {0}
set_instance_parameter_value chipmem0 {enPRInitMode} {0}
set_instance_parameter_value chipmem0 {enableDiffWidth} {0}
set_instance_parameter_value chipmem0 {initMemContent} {0}
set_instance_parameter_value chipmem0 {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value chipmem0 {instanceID} {NONE}
set_instance_parameter_value chipmem0 {memorySize} {4096.0}
set_instance_parameter_value chipmem0 {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value chipmem0 {resetrequest_enabled} {0}
set_instance_parameter_value chipmem0 {simAllowMRAMContentsFile} {0}
set_instance_parameter_value chipmem0 {simMemInitOnlyFilename} {0}
set_instance_parameter_value chipmem0 {singleClockOperation} {0}
set_instance_parameter_value chipmem0 {slave1Latency} {2}
set_instance_parameter_value chipmem0 {slave2Latency} {2}
set_instance_parameter_value chipmem0 {useNonDefaultInitFile} {0}
set_instance_parameter_value chipmem0 {useShallowMemBlocks} {0}
set_instance_parameter_value chipmem0 {writable} {1}

add_instance ext0 clock_source 18.1
set_instance_parameter_value ext0 {clockFrequency} {50000000.0}
set_instance_parameter_value ext0 {clockFrequencyKnown} {1}
set_instance_parameter_value ext0 {resetSynchronousEdges} {NONE}

add_instance fcport0 fejkon_fcport 1.0

add_instance jtagm altera_jtag_avalon_master 18.1
set_instance_parameter_value jtagm {FAST_VER} {0}
set_instance_parameter_value jtagm {FIFO_DEPTHS} {2}
set_instance_parameter_value jtagm {PLI_PORT} {50000}
set_instance_parameter_value jtagm {USE_PLI} {0}

add_instance rstctrl altera_reset_controller 18.1
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

add_instance sfp0 sfp_port 1.0

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF ext0.clk_in
add_interface fcxcvr_0_line_rx conduit end
set_interface_property fcxcvr_0_line_rx EXPORT_OF fcport0.fcxcvr_line_rx
add_interface fcxcvr_0_line_tx conduit end
set_interface_property fcxcvr_0_line_tx EXPORT_OF fcport0.fcxcvr_line_tx
add_interface reset reset sink
set_interface_property reset EXPORT_OF ext0.clk_in_reset
add_interface sfp0 conduit end
set_interface_property sfp0 EXPORT_OF sfp0.sfp

# connections and connection parameters
add_connection ext0.clk chipmem0.clk1

add_connection ext0.clk chipmem0.clk2

add_connection ext0.clk fcport0.clk

add_connection ext0.clk jtagm.clk

add_connection ext0.clk rstctrl.clk

add_connection ext0.clk sfp0.clk

add_connection ext0.clk_reset jtagm.clk_reset

add_connection ext0.clk_reset rstctrl.reset_in0

add_connection fcport0.fcrx_dma_mm_write chipmem0.s2
set_connection_parameter_value fcport0.fcrx_dma_mm_write/chipmem0.s2 arbitrationPriority {1}
set_connection_parameter_value fcport0.fcrx_dma_mm_write/chipmem0.s2 baseAddress {0x0000}
set_connection_parameter_value fcport0.fcrx_dma_mm_write/chipmem0.s2 defaultConnection {0}

add_connection fcport0.fctx_dma_mm_read chipmem0.s1
set_connection_parameter_value fcport0.fctx_dma_mm_read/chipmem0.s1 arbitrationPriority {1}
set_connection_parameter_value fcport0.fctx_dma_mm_read/chipmem0.s1 baseAddress {0x0000}
set_connection_parameter_value fcport0.fctx_dma_mm_read/chipmem0.s1 defaultConnection {0}

add_connection jtagm.master chipmem0.s1
set_connection_parameter_value jtagm.master/chipmem0.s1 arbitrationPriority {1}
set_connection_parameter_value jtagm.master/chipmem0.s1 baseAddress {0x0000}
set_connection_parameter_value jtagm.master/chipmem0.s1 defaultConnection {0}

add_connection jtagm.master fcport0.setup
set_connection_parameter_value jtagm.master/fcport0.setup arbitrationPriority {1}
set_connection_parameter_value jtagm.master/fcport0.setup baseAddress {0x1400}
set_connection_parameter_value jtagm.master/fcport0.setup defaultConnection {0}

add_connection jtagm.master sfp0.mm
set_connection_parameter_value jtagm.master/sfp0.mm arbitrationPriority {1}
set_connection_parameter_value jtagm.master/sfp0.mm baseAddress {0x1000}
set_connection_parameter_value jtagm.master/sfp0.mm defaultConnection {0}

add_connection jtagm.master_reset rstctrl.reset_in1

add_connection rstctrl.reset_out chipmem0.reset1

add_connection rstctrl.reset_out chipmem0.reset2

add_connection rstctrl.reset_out fcport0.rst

add_connection rstctrl.reset_out sfp0.reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon.qsys}
