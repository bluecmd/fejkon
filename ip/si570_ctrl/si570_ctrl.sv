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

  // TODO: Auto-generated HDL template

  assign reset_out = 1'b0;


  // I2C tri-state bus driver
  assign scl_in = scl;
  assign sda_in = sda;
  assign scl = scl_oe ? 1'b0 : 1'bz;
  assign sda = sda_oe ? 1'b0 : 1'bz;
endmodule
