`timescale 1 ps / 1 ps
module fejkon_identity (
    output wire [31:0] mm_readdata, //    mm.readdata
    input  wire        clk,         //   clk.clk
    input  wire        reset        // reset.reset
  );

  // Format:
  // 0:1  0x0DE5 magic
  // 2    0x01   version
  // 3    0x01   ports
  assign mm_readdata = 32'h01010DE5;

endmodule
