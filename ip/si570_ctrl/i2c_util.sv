package i2c_util;

  typedef struct packed {
    // These are driven by i2c_master
    logic start;          // cmd_start
    logic read;           // cmd_read
    logic write;          // cmd_write
    logic write_multiple; // cmd_write_multiple
    logic stop;           // cmd_stop
    logic valid;          // cmd_valid
    logic ready;          // cmd_ready
    logic missed_ack;     // missed_ack
    logic [7:0] data_in;  // data_in
    logic data_in_valid;  // data_in_valid
    logic data_in_last;   // data_in_last
    logic data_in_ready;  // data_in_ready
    logic [7:0] data_out; // data_out
    logic data_out_valid; // data_out_valid

    // Internal state
    logic done;
    logic err;
    int state;
    int delay;
    logic [7:0] data_out_saved;
  } i2c_bus_t;

  function automatic void _new_tx(ref i2c_bus_t bus);
    bus.start = 1;
    bus.stop = 0;
    bus.data_in_last = 0;
  endfunction
  function automatic void _finish_tx(ref i2c_bus_t bus);
    bus.start = 0;
    bus.data_in_last = 1;
  endfunction

  function automatic void _start_write(ref i2c_bus_t bus, input logic [7:0] data);
    bus.read = 0;
    bus.write = 1;
    bus.valid = 1;
    bus.data_in = data;
    bus.data_in_valid = 1;
  endfunction

  function automatic void _start_read(ref i2c_bus_t bus);
    bus.read = 1;
    bus.write = 0;
    bus.write_multiple = 0;
    bus.valid = 1;
    bus.data_in_valid = 0;
  endfunction

  function automatic logic [7:0] si570_bus_read(ref i2c_bus_t bus, input int address);
    // State 0: Start write address byte
    // State 1: Start read data byte
    // State 2: Wait for complete
    if (bus.missed_ack) begin
      $error("ACK missed");
      bus.err = 1;
    end else if (bus.ready && bus.err) begin
      $warning("Error occurred during transaction, retrying");
      bus.state = 0;
    end else if (bus.state == 0) begin
      _new_tx(bus);
      _start_write(bus, address[7:0]);
      bus.data_out_saved = 8'b0;
      bus.delay = 2;
      bus.done = 0;
      bus.err = 0;
      bus.state = bus.ready ? 1 : bus.state;
      bus.write_multiple = 0;
    end else if (bus.state == 1 && bus.delay == 0 && bus.ready) begin
      _start_read(bus);
      _finish_tx(bus);
      bus.delay = 2;
      bus.state = 2;
    end else if (bus.state == 2 && bus.delay == 0 && bus.data_out_valid) begin
      bus.data_out_saved = bus.data_out;
      bus.delay = 2;
      bus.read = 0;
      bus.state = 3;
      bus.stop = 1;
      bus.valid = 1;
    end else if (bus.state == 3 && bus.delay == 0 && bus.ready) begin
      bus.done = 1;
      bus.state = 0;
    end else
      bus.valid = 0;
    if (bus.delay > 0)
      bus.delay = bus.delay - 1;
    return bus.data_out_saved;
  endfunction

  function automatic void si570_bus_write(ref i2c_bus_t bus, input int address, input logic [7:0] data);
    // State 0: Start write address byte
    // State 1: Start write data byte
    // State 2: Wait for complete
    if (bus.missed_ack) begin
      $error("ACK missed");
      bus.err = 1;
    end else if (bus.ready && bus.err) begin
      $warning("Error occurred during transaction, retrying");
      bus.state = 0;
    end else if (bus.state == 0) begin
      _new_tx(bus);
      _start_write(bus, address[7:0]);
      bus.delay = 2;
      bus.done = 0;
      bus.err = 0;
      bus.state = bus.ready ? 1 : bus.state;
      bus.write_multiple = 1;
    end else if (bus.state == 1 && bus.delay == 0 && bus.data_in_ready) begin
      _start_write(bus, data);
      _finish_tx(bus);
      bus.data_in_last = 1;
      bus.delay = 2;
      bus.state = 2;
    end else if (bus.state == 2 && bus.delay == 0 && bus.ready) begin
      bus.delay = 2;
      bus.state = 3;
      bus.stop = 1;
      bus.valid = 1;
      bus.write = 0;
      bus.write_multiple = 0;
    end else if (bus.state == 3 && bus.delay == 0 && bus.ready) begin
      bus.done = 1;
      bus.state = 0;
    end else
      bus.valid = 0;
    if (bus.delay > 0)
      bus.delay = bus.delay - 1;
  endfunction

  function automatic void si570_bus_reset(ref i2c_bus_t bus);
    bus.state = 0;
    bus.done = 0;
    bus.valid = 0;
  endfunction
endpackage
