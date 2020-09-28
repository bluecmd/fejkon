`timescale 1 ps / 1 ps
`include "version.sv"

module fejkon_identity #(
    parameter logic [3:0] FcPorts  = 2,
    parameter logic [3:0] EthPorts = 2
  ) (
    output wire [31:0] mm_readdata, //    mm.readdata
    input  wire  [0:0] mm_address,  //    mm.address
    input  wire        clk,         //   clk.clk
    input  wire        reset        // reset.reset
  );

  assign mm_readdata = mm_address[0] ? `FEJKON_GIT_HASH : {EthPorts[3:0], FcPorts[3:0], 24'h010DE5};

endmodule
