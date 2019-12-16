// intel_pcie_tlp_adapter.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module intel_pcie_tlp_adapter (
		input  wire         clk,                     //       clk.clk
		input  wire         reset,                   //     reset.reset
		output wire [255:0] phy_tx_st_data,          // phy_tx_st.data
		output wire         phy_tx_st_startofpacket, //          .startofpacket
		output wire         phy_tx_st_endofpacket,   //          .endofpacket
		output wire         phy_tx_st_error,         //          .error
		output wire [1:0]   phy_tx_st_empty,         //          .empty
		output wire         phy_tx_st_valid,         //          .valid
		input  wire         phy_tx_st_ready,         //          .ready
		input  wire [255:0] phy_rx_st_data,          // phy_rx_st.data
		input  wire [1:0]   phy_rx_st_empty,         //          .empty
		input  wire         phy_rx_st_error,         //          .error
		input  wire         phy_rx_st_startofpacket, //          .startofpacket
		input  wire         phy_rx_st_endofpacket,   //          .endofpacket
		output wire         phy_rx_st_ready,         //          .ready
		input  wire         phy_rx_st_valid,         //          .valid
		output wire [255:0] tlp_rx_st_data,          // tlp_rx_st.data
		output wire [2:0]   tlp_rx_st_empty,         //          .empty
		output wire         tlp_rx_st_endofpacket,   //          .endofpacket
		output wire         tlp_rx_st_startofpacket, //          .startofpacket
		output wire         tlp_rx_st_valid,         //          .valid
		input  wire         tlp_rx_st_ready,         //          .ready
		input  wire [255:0] tlp_tx_st_data,          // tlp_tx_st.data
		input  wire [2:0]   tlp_tx_st_empty,         //          .empty
		input  wire         tlp_tx_st_endofpacket,   //          .endofpacket
		input  wire         tlp_tx_st_startofpacket, //          .startofpacket
		output wire         tlp_tx_st_ready,         //          .ready
		input  wire         tlp_tx_st_valid          //          .valid
	);

	// TODO: Auto-generated HDL template

	assign phy_tx_st_valid = 1'b0;

	assign phy_tx_st_data = 256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

	assign phy_tx_st_startofpacket = 1'b0;

	assign phy_tx_st_endofpacket = 1'b0;

	assign phy_tx_st_error = 1'b0;

	assign phy_tx_st_empty = 2'b00;

	assign phy_rx_st_ready = 1'b0;

	assign tlp_rx_st_valid = 1'b0;

	assign tlp_rx_st_data = 256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

	assign tlp_rx_st_startofpacket = 1'b0;

	assign tlp_rx_st_endofpacket = 1'b0;

	assign tlp_rx_st_empty = 3'b000;

	assign tlp_tx_st_ready = 1'b0;

endmodule
