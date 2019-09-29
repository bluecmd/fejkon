// sfp_port.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module sfp_port (
		input  wire       clk,              //   clk.clk
		input  wire       reset,            // reset.reset
		input  wire       los,              //   sfp.los
		input  wire       mod0_prsnt_n,     //      .prsnt_n
		input  wire       tx_disable,       //      .txdis
		inout  wire       mod1_scl,         //      .scl
		inout  wire       mod2_sda,         //      .sda
		output wire [1:0] ratesel,          //      .ratesel
		input  wire       tx_fault,         //      .txfail
		input  wire [9:0] mm_address,       //    mm.address
		input  wire       mm_read,          //      .read
		output wire [7:0] mm_readdata,      //      .readdata
		input  wire       mm_write,         //      .write
		input  wire [7:0] mm_writedata,     //      .writedata
		output wire       mm_readdatavalid, //      .readdatavalid
		output wire       mm_waitrequest    //      .waitrequest
	);

	// TODO: Auto-generated HDL template

	assign ratesel = 2'b00;

	assign mm_readdata = 8'b00000000;

	assign mm_waitrequest = 1'b0;

	assign mm_readdatavalid = 1'b0;

endmodule
