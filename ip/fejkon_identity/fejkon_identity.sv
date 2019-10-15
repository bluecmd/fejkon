`timescale 1 ps / 1 ps
`include "version.sv"

module fejkon_identity (
    output wire [31:0] mm_readdata, //    mm.readdata
    input  wire  [0:0] mm_address,  //    mm.address
    input  wire        clk,         //   clk.clk
    input  wire        reset        // reset.reset
  );

  // Format for 0x0:
  // 0:1  0x0DE5 magic
  // 2    0x01   version
  // 3    0x01   ports
  assign mm_readdata = mm_address[0] ? `FEJKON_GIT_HASH : 32'h01010DE5;

endmodule
