`timescale 1 ps / 1 ps
module si570_ctrl #(
    parameter InputClock      = 50000000,
    parameter RecallFrequency = 640000000
  ) (
    input  wire  clk,       //       clk.clk
    input  wire  reset,     //     reset.reset
    output wire  reset_out, // reset_out.reset
    inout  tri1  sda,       // si570_i2c.sda
    inout  tri1  scl        //          .scl
  );

  wire scl_i;
  wire scl_o;
  wire scl_t;
  wire sda_i;
  wire sda_o;
  wire sda_t;

  // TODO: Auto-generated HDL template

  assign reset_out = 1'b1;

  i2c_master i2c (
    .clk(clk),
    .rst(reset),
    .cmd_address(),
    .cmd_start(),
    .cmd_read(),
    .cmd_write(),
    .cmd_write_multiple(1'b0),
    .cmd_stop(),
    .cmd_valid(1'b0),
    .cmd_ready(),
    .data_in(),
    .data_in_valid(),
    .data_in_ready(),
    .data_in_last(),
    .data_out(),
    .data_out_valid(),
    .data_out_ready(),
    .data_out_last(),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_t(scl_t),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_t(sda_t),
    .busy(),
    .bus_control(),
    .bus_active(),
    .missed_ack(),
    .prescale(InputClock / (400000*4)),
    .stop_on_idle(1'b0)
  );

  // I2C tri-state bus driver
  assign scl_i = scl;
  assign sda_i = sda;
  assign scl = scl_t ? 1'bz : scl_o;
  assign sda = sda_t ? 1'bz : sda_o;

endmodule