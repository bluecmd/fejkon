# qsys scripting (.tcl) file for fejkon_sfp
package require -exact qsys 16.0

create_system {fejkon_sfp}

set_project_property DEVICE_FAMILY {Stratix V}
set_project_property DEVICE {5SGXEA7N2F45C2}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance clk altera_clock_bridge 19.1
set_instance_parameter_value clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value clk {NUM_CLOCK_OUTPUTS} {1}

add_instance i2c altera_avalon_i2c 19.1
set_instance_parameter_value i2c {FIFO_DEPTH} {64}
set_instance_parameter_value i2c {USE_AV_ST} {0}

add_instance mm altera_avalon_mm_bridge 19.1
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

add_instance reset altera_reset_bridge 19.1
set_instance_parameter_value reset {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value reset {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value reset {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value reset {USE_RESET_REQUEST} {0}

add_instance sfp sfp_port 1.0

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk.in_clk
add_interface i2c_irq interrupt sender
set_interface_property i2c_irq EXPORT_OF i2c.interrupt_sender
add_interface mm avalon slave
set_interface_property mm EXPORT_OF mm.s0
add_interface reset reset sink
set_interface_property reset EXPORT_OF reset.in_reset
add_interface sfp conduit end
set_interface_property sfp EXPORT_OF sfp.sfp

# connections and connection parameters
add_connection clk.out_clk i2c.clock

add_connection clk.out_clk mm.clk

add_connection clk.out_clk reset.clk

add_connection clk.out_clk sfp.clk

add_connection i2c.i2c_serial sfp.i2c
set_connection_parameter_value i2c.i2c_serial/sfp.i2c endPort {}
set_connection_parameter_value i2c.i2c_serial/sfp.i2c endPortLSB {0}
set_connection_parameter_value i2c.i2c_serial/sfp.i2c startPort {}
set_connection_parameter_value i2c.i2c_serial/sfp.i2c startPortLSB {0}
set_connection_parameter_value i2c.i2c_serial/sfp.i2c width {0}

add_connection mm.m0 i2c.csr
set_connection_parameter_value mm.m0/i2c.csr arbitrationPriority {1}
set_connection_parameter_value mm.m0/i2c.csr baseAddress {0x0040}
set_connection_parameter_value mm.m0/i2c.csr defaultConnection {0}

add_connection mm.m0 sfp.mm
set_connection_parameter_value mm.m0/sfp.mm arbitrationPriority {1}
set_connection_parameter_value mm.m0/sfp.mm baseAddress {0x0000}
set_connection_parameter_value mm.m0/sfp.mm defaultConnection {0}

add_connection reset.out_reset mm.reset

add_connection reset.out_reset sfp.reset

add_connection sfp.i2c_reset i2c.reset_sink

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

save_system {fejkon_sfp.qsys}
