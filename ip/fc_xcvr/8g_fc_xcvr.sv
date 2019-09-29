// 8g_fc_xcvr.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module 8g_fc_xcvr (
		input  wire [31:0] tx_data,  //      tx.data
		output wire        tx_ready, //        .ready
		output wire [31:0] rx_data,  //      rx.data
		output wire        rx_valid, //        .valid
		output wire        td_p,     // line_tx.lvds
		input  wire        rd_p,     // line_rx.lvds
		input  wire        clk,      //     clk.clk
		input  wire        reset     //   reset.reset
	);

	// TODO: Auto-generated HDL template

	assign tx_ready = 1'b0;

	assign rx_valid = 1'b0;

	assign rx_data = 32'b00000000000000000000000000000000;

	assign td_p = 1'b0;

endmodule
