# qsys scripting (.tcl) file for fejkon_snoop
package require -exact qsys 16.0

create_system {fejkon_snoop}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance fc_clk altera_clock_bridge 20.1
set_instance_parameter_value fc_clk {EXPLICIT_CLOCK_RATE} {106250000.0}
set_instance_parameter_value fc_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance fc_reset altera_reset_bridge 20.1
set_instance_parameter_value fc_reset {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value fc_reset {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value fc_reset {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value fc_reset {USE_RESET_REQUEST} {0}

add_instance mgmt_clk altera_clock_bridge 20.1
set_instance_parameter_value mgmt_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value mgmt_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance mm_bridge altera_avalon_mm_bridge 20.1
set_instance_parameter_value mm_bridge {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value mm_bridge {ADDRESS_WIDTH} {10}
set_instance_parameter_value mm_bridge {DATA_WIDTH} {32}
set_instance_parameter_value mm_bridge {LINEWRAPBURSTS} {0}
set_instance_parameter_value mm_bridge {MAX_BURST_SIZE} {1}
set_instance_parameter_value mm_bridge {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value mm_bridge {PIPELINE_COMMAND} {1}
set_instance_parameter_value mm_bridge {PIPELINE_RESPONSE} {1}
set_instance_parameter_value mm_bridge {SYMBOL_WIDTH} {8}
set_instance_parameter_value mm_bridge {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value mm_bridge {USE_RESPONSE} {0}

add_instance port0_mem altera_avalon_onchip_memory2 20.1
set_instance_parameter_value port0_mem {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value port0_mem {blockType} {AUTO}
set_instance_parameter_value port0_mem {copyInitFile} {0}
set_instance_parameter_value port0_mem {dataWidth} {64}
set_instance_parameter_value port0_mem {dataWidth2} {32}
set_instance_parameter_value port0_mem {dualPort} {1}
set_instance_parameter_value port0_mem {ecc_enabled} {0}
set_instance_parameter_value port0_mem {enPRInitMode} {0}
set_instance_parameter_value port0_mem {enableDiffWidth} {1}
set_instance_parameter_value port0_mem {initMemContent} {0}
set_instance_parameter_value port0_mem {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value port0_mem {instanceID} {NONE}
set_instance_parameter_value port0_mem {memorySize} {262144.0}
set_instance_parameter_value port0_mem {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value port0_mem {resetrequest_enabled} {0}
set_instance_parameter_value port0_mem {simAllowMRAMContentsFile} {0}
set_instance_parameter_value port0_mem {simMemInitOnlyFilename} {0}
set_instance_parameter_value port0_mem {singleClockOperation} {0}
set_instance_parameter_value port0_mem {slave1Latency} {1}
set_instance_parameter_value port0_mem {slave2Latency} {1}
set_instance_parameter_value port0_mem {useNonDefaultInitFile} {0}
set_instance_parameter_value port0_mem {useShallowMemBlocks} {0}
set_instance_parameter_value port0_mem {writable} {1}

add_instance port1_mem altera_avalon_onchip_memory2 20.1
set_instance_parameter_value port1_mem {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value port1_mem {blockType} {AUTO}
set_instance_parameter_value port1_mem {copyInitFile} {0}
set_instance_parameter_value port1_mem {dataWidth} {64}
set_instance_parameter_value port1_mem {dataWidth2} {32}
set_instance_parameter_value port1_mem {dualPort} {1}
set_instance_parameter_value port1_mem {ecc_enabled} {0}
set_instance_parameter_value port1_mem {enPRInitMode} {0}
set_instance_parameter_value port1_mem {enableDiffWidth} {1}
set_instance_parameter_value port1_mem {initMemContent} {0}
set_instance_parameter_value port1_mem {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value port1_mem {instanceID} {NONE}
set_instance_parameter_value port1_mem {memorySize} {262144.0}
set_instance_parameter_value port1_mem {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value port1_mem {resetrequest_enabled} {0}
set_instance_parameter_value port1_mem {simAllowMRAMContentsFile} {0}
set_instance_parameter_value port1_mem {simMemInitOnlyFilename} {0}
set_instance_parameter_value port1_mem {singleClockOperation} {0}
set_instance_parameter_value port1_mem {slave1Latency} {1}
set_instance_parameter_value port1_mem {slave2Latency} {1}
set_instance_parameter_value port1_mem {useNonDefaultInitFile} {0}
set_instance_parameter_value port1_mem {useShallowMemBlocks} {0}
set_instance_parameter_value port1_mem {writable} {1}

add_instance reset altera_reset_bridge 20.1
set_instance_parameter_value reset {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value reset {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value reset {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value reset {USE_RESET_REQUEST} {0}

add_instance reset_snoop_fifo altera_reset_bridge 20.1
set_instance_parameter_value reset_snoop_fifo {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value reset_snoop_fifo {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value reset_snoop_fifo {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value reset_snoop_fifo {USE_RESET_REQUEST} {0}

add_instance stream_capture stream_capture 1.0

# exported interfaces
add_interface csr avalon slave
set_interface_property csr EXPORT_OF stream_capture.csr
add_interface fc_clk clock sink
set_interface_property fc_clk EXPORT_OF fc_clk.in_clk
add_interface mgmt_clk clock sink
set_interface_property mgmt_clk EXPORT_OF mgmt_clk.in_clk
add_interface mm avalon slave
set_interface_property mm EXPORT_OF mm_bridge.s0
add_interface port0_st avalon_streaming sink
set_interface_property port0_st EXPORT_OF stream_capture.port0_st
add_interface port1_st avalon_streaming sink
set_interface_property port1_st EXPORT_OF stream_capture.port1_st
add_interface reset reset sink
set_interface_property reset EXPORT_OF reset.in_reset
add_interface snoop_fifo_reset reset source
set_interface_property snoop_fifo_reset EXPORT_OF reset_snoop_fifo.out_reset

# connections and connection parameters
add_connection fc_clk.out_clk fc_reset.clk

add_connection fc_clk.out_clk port0_mem.clk1

add_connection fc_clk.out_clk port1_mem.clk1

add_connection fc_clk.out_clk reset_snoop_fifo.clk

add_connection fc_clk.out_clk stream_capture.clk

add_connection fc_reset.out_reset port0_mem.reset1

add_connection fc_reset.out_reset port1_mem.reset1

add_connection fc_reset.out_reset stream_capture.reset

add_connection mgmt_clk.out_clk mm_bridge.clk

add_connection mgmt_clk.out_clk port0_mem.clk2

add_connection mgmt_clk.out_clk port1_mem.clk2

add_connection mgmt_clk.out_clk reset.clk

add_connection mm_bridge.m0 port0_mem.s2
set_connection_parameter_value mm_bridge.m0/port0_mem.s2 arbitrationPriority {1}
set_connection_parameter_value mm_bridge.m0/port0_mem.s2 baseAddress {0x0000}
set_connection_parameter_value mm_bridge.m0/port0_mem.s2 defaultConnection {0}

add_connection mm_bridge.m0 port1_mem.s2
set_connection_parameter_value mm_bridge.m0/port1_mem.s2 arbitrationPriority {1}
set_connection_parameter_value mm_bridge.m0/port1_mem.s2 baseAddress {0x00100000}
set_connection_parameter_value mm_bridge.m0/port1_mem.s2 defaultConnection {0}

add_connection reset.out_reset fc_reset.in_reset

add_connection reset.out_reset mm_bridge.reset

add_connection reset.out_reset port0_mem.reset2

add_connection reset.out_reset port1_mem.reset2

add_connection stream_capture.port0_mem port0_mem.s1
set_connection_parameter_value stream_capture.port0_mem/port0_mem.s1 arbitrationPriority {1}
set_connection_parameter_value stream_capture.port0_mem/port0_mem.s1 baseAddress {0x0000}
set_connection_parameter_value stream_capture.port0_mem/port0_mem.s1 defaultConnection {0}

add_connection stream_capture.port1_mem port1_mem.s1
set_connection_parameter_value stream_capture.port1_mem/port1_mem.s1 arbitrationPriority {1}
set_connection_parameter_value stream_capture.port1_mem/port1_mem.s1 baseAddress {0x0000}
set_connection_parameter_value stream_capture.port1_mem/port1_mem.s1 defaultConnection {0}

add_connection stream_capture.snoop_reset reset_snoop_fifo.in_reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon_snoop.qsys}
