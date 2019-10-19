`timescale 1 ps / 1 ps
module fc_remove_idle (
    input  wire        reset,             // reset.reset
    input  wire        clk,               //   clk.clk
    input  wire [35:0] in_data,           //    in.data
    input  wire        in_valid,          //      .valid
    output wire [31:0] out_data,          //   out.data
    output wire        out_valid,         //      .valid
    input  wire        out_endofpacket,   //      .endofpacket
    input  wire        out_startofpacket  //      .startofpacket
  );

  // TODO: Auto-generated HDL template

  assign out_valid = 1'b0;

  assign out_data = 32'b00000000000000000000000000000000;

endmodule
