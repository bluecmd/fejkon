`timescale 1 us / 1 us
module rs422_ctrl (
    input  wire  clk,        //   clk.clk
    input  wire  reset,      // reset.reset
    output wire  rs422_re_n, // rs422.re_n
    output wire  rs422_de,   //      .de
    output wire  rs422_te    //      .te
  );

  // Driver enable
  assign rs422_de = 1'b1;

  // Receiver enable (active low)
  assign rs422_re_n = 1'b0;

  // 120 Ohm termination (more a RS-485 thing than RS-422)
  assign rs422_te = 1'b0;

endmodule
