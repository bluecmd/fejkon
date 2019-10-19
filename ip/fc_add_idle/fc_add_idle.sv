`timescale 1 ps / 1 ps
module fc_add_idle (
    input  wire        reset,             // reset.reset
    input  wire        clk,               //   clk.clk
    input  wire [31:0] in_data,           //    in.data
    output wire        in_ready,          //      .ready
    input  wire        in_endofpacket,    //      .endofpacket
    input  wire        in_startofpacket,  //      .startofpacket
    output wire [35:0] out_data,          //   out.data
    input  wire        out_ready          //      .ready
  );

  // TODO: Auto-generated HDL template

  assign in_ready = 1'b0;

  // TODO: Send IDLE (K28.5 D21.4 D21.5 D21.5)
  assign out_data = {1'b0, 8'hB5, 1'b0, 8'hB5, 1'b0, 8'h95, 1'b1, 8'hBC};

endmodule
