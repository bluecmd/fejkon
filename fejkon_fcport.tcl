# qsys scripting (.tcl) file for fejkon_fcport
package require -exact qsys 16.0

create_system {fejkon_fcport}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SEE9F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance clk0 altera_clock_bridge 18.1
set_instance_parameter_value clk0 {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value clk0 {NUM_CLOCK_OUTPUTS} {1}

add_instance fc_add_idle_0 fc_add_idle 1.0

add_instance fc_remove_idle_0 fc_remove_idle 1.0

add_instance fcrx_dma altera_msgdma 18.1
set_instance_parameter_value fcrx_dma {BURST_ENABLE} {0}
set_instance_parameter_value fcrx_dma {BURST_WRAPPING_SUPPORT} {0}
set_instance_parameter_value fcrx_dma {CHANNEL_ENABLE} {0}
set_instance_parameter_value fcrx_dma {CHANNEL_WIDTH} {8}
set_instance_parameter_value fcrx_dma {DATA_FIFO_DEPTH} {32}
set_instance_parameter_value fcrx_dma {DATA_WIDTH} {32}
set_instance_parameter_value fcrx_dma {DESCRIPTOR_FIFO_DEPTH} {128}
set_instance_parameter_value fcrx_dma {ENHANCED_FEATURES} {0}
set_instance_parameter_value fcrx_dma {ERROR_ENABLE} {0}
set_instance_parameter_value fcrx_dma {ERROR_WIDTH} {8}
set_instance_parameter_value fcrx_dma {EXPOSE_ST_PORT} {0}
set_instance_parameter_value fcrx_dma {FIX_ADDRESS_WIDTH} {32}
set_instance_parameter_value fcrx_dma {MAX_BURST_COUNT} {2}
set_instance_parameter_value fcrx_dma {MAX_BYTE} {1024}
set_instance_parameter_value fcrx_dma {MAX_STRIDE} {1}
set_instance_parameter_value fcrx_dma {MODE} {2}
set_instance_parameter_value fcrx_dma {PACKET_ENABLE} {0}
set_instance_parameter_value fcrx_dma {PREFETCHER_DATA_WIDTH} {32}
set_instance_parameter_value fcrx_dma {PREFETCHER_ENABLE} {0}
set_instance_parameter_value fcrx_dma {PREFETCHER_MAX_READ_BURST_COUNT} {2}
set_instance_parameter_value fcrx_dma {PREFETCHER_READ_BURST_ENABLE} {0}
set_instance_parameter_value fcrx_dma {PROGRAMMABLE_BURST_ENABLE} {0}
set_instance_parameter_value fcrx_dma {RESPONSE_PORT} {2}
set_instance_parameter_value fcrx_dma {STRIDE_ENABLE} {0}
set_instance_parameter_value fcrx_dma {TRANSFER_TYPE} {Full Word Accesses Only}
set_instance_parameter_value fcrx_dma {USE_FIX_ADDRESS_WIDTH} {0}

add_instance fctx_dma altera_msgdma 18.1
set_instance_parameter_value fctx_dma {BURST_ENABLE} {0}
set_instance_parameter_value fctx_dma {BURST_WRAPPING_SUPPORT} {0}
set_instance_parameter_value fctx_dma {CHANNEL_ENABLE} {0}
set_instance_parameter_value fctx_dma {CHANNEL_WIDTH} {8}
set_instance_parameter_value fctx_dma {DATA_FIFO_DEPTH} {32}
set_instance_parameter_value fctx_dma {DATA_WIDTH} {32}
set_instance_parameter_value fctx_dma {DESCRIPTOR_FIFO_DEPTH} {128}
set_instance_parameter_value fctx_dma {ENHANCED_FEATURES} {0}
set_instance_parameter_value fctx_dma {ERROR_ENABLE} {0}
set_instance_parameter_value fctx_dma {ERROR_WIDTH} {8}
set_instance_parameter_value fctx_dma {EXPOSE_ST_PORT} {0}
set_instance_parameter_value fctx_dma {FIX_ADDRESS_WIDTH} {32}
set_instance_parameter_value fctx_dma {MAX_BURST_COUNT} {2}
set_instance_parameter_value fctx_dma {MAX_BYTE} {1024}
set_instance_parameter_value fctx_dma {MAX_STRIDE} {1}
set_instance_parameter_value fctx_dma {MODE} {1}
set_instance_parameter_value fctx_dma {PACKET_ENABLE} {0}
set_instance_parameter_value fctx_dma {PREFETCHER_DATA_WIDTH} {32}
set_instance_parameter_value fctx_dma {PREFETCHER_ENABLE} {0}
set_instance_parameter_value fctx_dma {PREFETCHER_MAX_READ_BURST_COUNT} {2}
set_instance_parameter_value fctx_dma {PREFETCHER_READ_BURST_ENABLE} {0}
set_instance_parameter_value fctx_dma {PROGRAMMABLE_BURST_ENABLE} {0}
set_instance_parameter_value fctx_dma {RESPONSE_PORT} {2}
set_instance_parameter_value fctx_dma {STRIDE_ENABLE} {0}
set_instance_parameter_value fctx_dma {TRANSFER_TYPE} {Full Word Accesses Only}
set_instance_parameter_value fctx_dma {USE_FIX_ADDRESS_WIDTH} {0}

add_instance fcxcvr 8g_fc_xcvr 1.0

add_instance rst0 altera_reset_bridge 18.1
set_instance_parameter_value rst0 {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value rst0 {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value rst0 {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value rst0 {USE_RESET_REQUEST} {0}

add_instance setup_bridge altera_avalon_mm_bridge 18.1
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

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk0.in_clk
add_interface fcrx_dma_csr_irq interrupt sender
set_interface_property fcrx_dma_csr_irq EXPORT_OF fcrx_dma.csr_irq
add_interface fcrx_dma_mm_write avalon master
set_interface_property fcrx_dma_mm_write EXPORT_OF fcrx_dma.mm_write
add_interface fctx_dma_csr_irq interrupt sender
set_interface_property fctx_dma_csr_irq EXPORT_OF fctx_dma.csr_irq
add_interface fctx_dma_mm_read avalon master
set_interface_property fctx_dma_mm_read EXPORT_OF fctx_dma.mm_read
add_interface fcxcvr_line_rx conduit end
set_interface_property fcxcvr_line_rx EXPORT_OF fcxcvr.line_rx
add_interface fcxcvr_line_tx conduit end
set_interface_property fcxcvr_line_tx EXPORT_OF fcxcvr.line_tx
add_interface rst reset sink
set_interface_property rst EXPORT_OF rst0.in_reset
add_interface setup avalon slave
set_interface_property setup EXPORT_OF setup_bridge.s0

# connections and connection parameters
add_connection clk0.out_clk fc_add_idle_0.clk

add_connection clk0.out_clk fc_remove_idle_0.clk

add_connection clk0.out_clk fcrx_dma.clock

add_connection clk0.out_clk fctx_dma.clock

add_connection clk0.out_clk fcxcvr.clk

add_connection clk0.out_clk rst0.clk

add_connection clk0.out_clk setup_bridge.clk

add_connection fc_add_idle_0.out fcxcvr.tx

add_connection fc_remove_idle_0.out fcrx_dma.st_sink

add_connection fctx_dma.st_source fc_add_idle_0.in

add_connection fcxcvr.rx fc_remove_idle_0.in

add_connection rst0.out_reset fc_add_idle_0.reset

add_connection rst0.out_reset fc_remove_idle_0.reset

add_connection rst0.out_reset fcrx_dma.reset_n

add_connection rst0.out_reset fctx_dma.reset_n

add_connection rst0.out_reset fcxcvr.reset

add_connection rst0.out_reset setup_bridge.reset

add_connection setup_bridge.m0 fcrx_dma.csr
set_connection_parameter_value setup_bridge.m0/fcrx_dma.csr arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/fcrx_dma.csr baseAddress {0x0000}
set_connection_parameter_value setup_bridge.m0/fcrx_dma.csr defaultConnection {0}

add_connection setup_bridge.m0 fcrx_dma.descriptor_slave
set_connection_parameter_value setup_bridge.m0/fcrx_dma.descriptor_slave arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/fcrx_dma.descriptor_slave baseAddress {0x0050}
set_connection_parameter_value setup_bridge.m0/fcrx_dma.descriptor_slave defaultConnection {0}

add_connection setup_bridge.m0 fctx_dma.csr
set_connection_parameter_value setup_bridge.m0/fctx_dma.csr arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/fctx_dma.csr baseAddress {0x0020}
set_connection_parameter_value setup_bridge.m0/fctx_dma.csr defaultConnection {0}

add_connection setup_bridge.m0 fctx_dma.descriptor_slave
set_connection_parameter_value setup_bridge.m0/fctx_dma.descriptor_slave arbitrationPriority {1}
set_connection_parameter_value setup_bridge.m0/fctx_dma.descriptor_slave baseAddress {0x0040}
set_connection_parameter_value setup_bridge.m0/fctx_dma.descriptor_slave defaultConnection {0}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon_fcport.qsys}
