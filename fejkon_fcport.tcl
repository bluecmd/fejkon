# qsys scripting (.tcl) file for fejkon_fcport
package require -exact qsys 16.0

create_system {fejkon_fcport}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SEE9F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance add_idle_0 fc_add_idle 1.0

add_instance clk0 altera_clock_bridge 19.1
set_instance_parameter_value clk0 {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value clk0 {NUM_CLOCK_OUTPUTS} {1}

add_instance remove_idle_0 fc_remove_idle 1.0

add_instance rst0 altera_reset_bridge 19.1
set_instance_parameter_value rst0 {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value rst0 {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value rst0 {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value rst0 {USE_RESET_REQUEST} {0}

add_instance rx_dma altera_avalon_sgdma 19.1
set_instance_parameter_value rx_dma {addressWidth} {32}
set_instance_parameter_value rx_dma {alwaysDoMaxBurst} {1}
set_instance_parameter_value rx_dma {avalonMMByteReorderMode} {0}
set_instance_parameter_value rx_dma {dataTransferFIFODepth} {2}
set_instance_parameter_value rx_dma {enableBurstTransfers} {0}
set_instance_parameter_value rx_dma {enableDescriptorReadMasterBurst} {0}
set_instance_parameter_value rx_dma {enableUnalignedTransfers} {0}
set_instance_parameter_value rx_dma {internalFIFODepth} {2}
set_instance_parameter_value rx_dma {readBlockDataWidth} {32}
set_instance_parameter_value rx_dma {readBurstcountWidth} {4}
set_instance_parameter_value rx_dma {sinkErrorWidth} {0}
set_instance_parameter_value rx_dma {sourceErrorWidth} {0}
set_instance_parameter_value rx_dma {transferMode} {STREAM_TO_MEMORY}
set_instance_parameter_value rx_dma {writeBurstcountWidth} {4}

add_instance rx_dma_descr altera_avalon_onchip_memory2 19.1
set_instance_parameter_value rx_dma_descr {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value rx_dma_descr {blockType} {AUTO}
set_instance_parameter_value rx_dma_descr {copyInitFile} {0}
set_instance_parameter_value rx_dma_descr {dataWidth} {32}
set_instance_parameter_value rx_dma_descr {dataWidth2} {32}
set_instance_parameter_value rx_dma_descr {dualPort} {1}
set_instance_parameter_value rx_dma_descr {ecc_enabled} {0}
set_instance_parameter_value rx_dma_descr {enPRInitMode} {0}
set_instance_parameter_value rx_dma_descr {enableDiffWidth} {0}
set_instance_parameter_value rx_dma_descr {initMemContent} {0}
set_instance_parameter_value rx_dma_descr {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value rx_dma_descr {instanceID} {NONE}
set_instance_parameter_value rx_dma_descr {memorySize} {4096.0}
set_instance_parameter_value rx_dma_descr {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value rx_dma_descr {resetrequest_enabled} {1}
set_instance_parameter_value rx_dma_descr {simAllowMRAMContentsFile} {0}
set_instance_parameter_value rx_dma_descr {simMemInitOnlyFilename} {0}
set_instance_parameter_value rx_dma_descr {singleClockOperation} {0}
set_instance_parameter_value rx_dma_descr {slave1Latency} {1}
set_instance_parameter_value rx_dma_descr {slave2Latency} {1}
set_instance_parameter_value rx_dma_descr {useNonDefaultInitFile} {0}
set_instance_parameter_value rx_dma_descr {useShallowMemBlocks} {0}
set_instance_parameter_value rx_dma_descr {writable} {1}

add_instance setup_bridge altera_avalon_mm_bridge 19.1
set_instance_parameter_value setup_bridge {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value setup_bridge {ADDRESS_WIDTH} {10}
set_instance_parameter_value setup_bridge {DATA_WIDTH} {32}
set_instance_parameter_value setup_bridge {LINEWRAPBURSTS} {0}
set_instance_parameter_value setup_bridge {MAX_BURST_SIZE} {1}
set_instance_parameter_value setup_bridge {MAX_PENDING_RESPONSES} {4}
set_instance_parameter_value setup_bridge {PIPELINE_COMMAND} {1}
set_instance_parameter_value setup_bridge {PIPELINE_RESPONSE} {1}
set_instance_parameter_value setup_bridge {SYMBOL_WIDTH} {8}
set_instance_parameter_value setup_bridge {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value setup_bridge {USE_RESPONSE} {0}

add_instance tx_dma altera_avalon_sgdma 19.1
set_instance_parameter_value tx_dma {addressWidth} {32}
set_instance_parameter_value tx_dma {alwaysDoMaxBurst} {1}
set_instance_parameter_value tx_dma {avalonMMByteReorderMode} {0}
set_instance_parameter_value tx_dma {dataTransferFIFODepth} {2}
set_instance_parameter_value tx_dma {enableBurstTransfers} {0}
set_instance_parameter_value tx_dma {enableDescriptorReadMasterBurst} {0}
set_instance_parameter_value tx_dma {enableUnalignedTransfers} {0}
set_instance_parameter_value tx_dma {internalFIFODepth} {2}
set_instance_parameter_value tx_dma {readBlockDataWidth} {32}
set_instance_parameter_value tx_dma {readBurstcountWidth} {4}
set_instance_parameter_value tx_dma {sinkErrorWidth} {0}
set_instance_parameter_value tx_dma {sourceErrorWidth} {0}
set_instance_parameter_value tx_dma {transferMode} {MEMORY_TO_STREAM}
set_instance_parameter_value tx_dma {writeBurstcountWidth} {4}

add_instance tx_dma_descr altera_avalon_onchip_memory2 19.1
set_instance_parameter_value tx_dma_descr {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value tx_dma_descr {blockType} {AUTO}
set_instance_parameter_value tx_dma_descr {copyInitFile} {0}
set_instance_parameter_value tx_dma_descr {dataWidth} {32}
set_instance_parameter_value tx_dma_descr {dataWidth2} {32}
set_instance_parameter_value tx_dma_descr {dualPort} {1}
set_instance_parameter_value tx_dma_descr {ecc_enabled} {0}
set_instance_parameter_value tx_dma_descr {enPRInitMode} {0}
set_instance_parameter_value tx_dma_descr {enableDiffWidth} {0}
set_instance_parameter_value tx_dma_descr {initMemContent} {0}
set_instance_parameter_value tx_dma_descr {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value tx_dma_descr {instanceID} {NONE}
set_instance_parameter_value tx_dma_descr {memorySize} {4096.0}
set_instance_parameter_value tx_dma_descr {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value tx_dma_descr {resetrequest_enabled} {1}
set_instance_parameter_value tx_dma_descr {simAllowMRAMContentsFile} {0}
set_instance_parameter_value tx_dma_descr {simMemInitOnlyFilename} {0}
set_instance_parameter_value tx_dma_descr {singleClockOperation} {0}
set_instance_parameter_value tx_dma_descr {slave1Latency} {1}
set_instance_parameter_value tx_dma_descr {slave2Latency} {1}
set_instance_parameter_value tx_dma_descr {useNonDefaultInitFile} {0}
set_instance_parameter_value tx_dma_descr {useShallowMemBlocks} {0}
set_instance_parameter_value tx_dma_descr {writable} {1}

add_instance xcvr fc_8g_xcvr 1.0

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk0.in_clk
add_interface rst reset sink
set_interface_property rst EXPORT_OF rst0.in_reset
add_interface rx_dma_csr_irq interrupt sender
set_interface_property rx_dma_csr_irq EXPORT_OF rx_dma.csr_irq
add_interface rx_dma_m avalon master
set_interface_property rx_dma_m EXPORT_OF rx_dma.m_write
add_interface setup avalon slave
set_interface_property setup EXPORT_OF setup_bridge.s0
add_interface tx_dma_csr_irq interrupt sender
set_interface_property tx_dma_csr_irq EXPORT_OF tx_dma.csr_irq
add_interface tx_dma_m avalon master
set_interface_property tx_dma_m EXPORT_OF tx_dma.m_read
add_interface xcvr_line_rx conduit end
set_interface_property xcvr_line_rx EXPORT_OF xcvr.line_rx
add_interface xcvr_line_tx conduit end
set_interface_property xcvr_line_tx EXPORT_OF xcvr.line_tx

# connections and connection parameters
add_connection add_idle_0.out xcvr.tx

add_connection clk0.out_clk add_idle_0.clk

add_connection clk0.out_clk remove_idle_0.clk

add_connection clk0.out_clk rst0.clk

add_connection clk0.out_clk rx_dma.clk

add_connection clk0.out_clk rx_dma_descr.clk1

add_connection clk0.out_clk rx_dma_descr.clk2

add_connection clk0.out_clk setup_bridge.clk

add_connection clk0.out_clk tx_dma.clk

add_connection clk0.out_clk tx_dma_descr.clk1

add_connection clk0.out_clk tx_dma_descr.clk2

add_connection clk0.out_clk xcvr.clk

add_connection remove_idle_0.out rx_dma.in

add_connection rst0.out_reset add_idle_0.reset

add_connection rst0.out_reset remove_idle_0.reset

add_connection rst0.out_reset rx_dma.reset

add_connection rst0.out_reset rx_dma_descr.reset1

add_connection rst0.out_reset rx_dma_descr.reset2

add_connection rst0.out_reset setup_bridge.reset

add_connection rst0.out_reset tx_dma.reset

add_connection rst0.out_reset tx_dma_descr.reset1

add_connection rst0.out_reset tx_dma_descr.reset2

add_connection rst0.out_reset xcvr.reset

add_connection rx_dma.descriptor_read rx_dma_descr.s1
set_connection_parameter_value rx_dma.descriptor_read/rx_dma_descr.s1 arbitrationPriority {1}
set_connection_parameter_value rx_dma.descriptor_read/rx_dma_descr.s1 baseAddress {0x2000}
set_connection_parameter_value rx_dma.descriptor_read/rx_dma_descr.s1 defaultConnection {0}

add_connection rx_dma.descriptor_write rx_dma_descr.s1
set_connection_parameter_value rx_dma.descriptor_write/rx_dma_descr.s1 arbitrationPriority {1}
set_connection_parameter_value rx_dma.descriptor_write/rx_dma_descr.s1 baseAddress {0x2000}
set_connection_parameter_value rx_dma.descriptor_write/rx_dma_descr.s1 defaultConnection {0}

add_connection setup_bridge.m0 rx_dma.csr
set_connection_parameter_value setup_bridge.m0/rx_dma.csr arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/rx_dma.csr baseAddress {0x0000}
set_connection_parameter_value setup_bridge.m0/rx_dma.csr defaultConnection {0}

add_connection setup_bridge.m0 rx_dma_descr.s2
set_connection_parameter_value setup_bridge.m0/rx_dma_descr.s2 arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/rx_dma_descr.s2 baseAddress {0x2000}
set_connection_parameter_value setup_bridge.m0/rx_dma_descr.s2 defaultConnection {0}

add_connection setup_bridge.m0 tx_dma.csr
set_connection_parameter_value setup_bridge.m0/tx_dma.csr arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/tx_dma.csr baseAddress {0x0040}
set_connection_parameter_value setup_bridge.m0/tx_dma.csr defaultConnection {0}

add_connection setup_bridge.m0 tx_dma_descr.s2
set_connection_parameter_value setup_bridge.m0/tx_dma_descr.s2 arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/tx_dma_descr.s2 baseAddress {0x3000}
set_connection_parameter_value setup_bridge.m0/tx_dma_descr.s2 defaultConnection {0}

add_connection tx_dma.descriptor_read tx_dma_descr.s1
set_connection_parameter_value tx_dma.descriptor_read/tx_dma_descr.s1 arbitrationPriority {1}
set_connection_parameter_value tx_dma.descriptor_read/tx_dma_descr.s1 baseAddress {0x3000}
set_connection_parameter_value tx_dma.descriptor_read/tx_dma_descr.s1 defaultConnection {0}

add_connection tx_dma.descriptor_write tx_dma_descr.s1
set_connection_parameter_value tx_dma.descriptor_write/tx_dma_descr.s1 arbitrationPriority {1}
set_connection_parameter_value tx_dma.descriptor_write/tx_dma_descr.s1 baseAddress {0x3000}
set_connection_parameter_value tx_dma.descriptor_write/tx_dma_descr.s1 defaultConnection {0}

add_connection tx_dma.out add_idle_0.in

add_connection xcvr.rx remove_idle_0.in

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon_fcport.qsys}
