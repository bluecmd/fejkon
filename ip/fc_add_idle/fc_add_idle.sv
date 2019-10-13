// fc_add_idle.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module fc_add_idle (
    input  wire        reset,             // reset.reset
    input  wire        clk,               //   clk.clk
    input  wire [31:0] in_data,           //    in.data
    output wire        in_ready,          //      .ready
    input  wire        in_endofpacket,    //      .endofpacket
    input  wire        in_startofpacket,  //      .startofpacket
    output wire [31:0] out_data,          //   out.data
    input  wire        out_ready          //      .ready
  );

  // TODO: Auto-generated HDL template

  assign in_ready = 1'b0;

  assign out_data = 32'b00000000000000000000000000000000;

endmodule
