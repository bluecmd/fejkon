`timescale 1 ps / 1 ps
module fejkon_pcie_data (
		output wire [31:0]  bar2_mm_address,       //   bar2_mm.address
		input  wire         bar2_mm_readdatavalid, //          .readdatavalid
		input  wire [31:0]  bar2_mm_readdata,      //          .readdata
		output wire         bar2_mm_read,          //          .read
		output wire         bar2_mm_write,         //          .write
		output wire [31:0]  bar2_mm_writedata,     //          .writedata
		input  wire         clk,                   //       clk.clk
		input  wire         reset,                 //     reset.reset
		input  wire [255:0] pcie_rx_data,          //   pcie_rx.data
		input  wire         pcie_rx_empty,         //          .empty
		input  wire         pcie_rx_error,         //          .error
		input  wire         pcie_rx_startofpacket, //          .startofpacket
		input  wire         pcie_rx_endofpacket,   //          .endofpacket
		output wire         pcie_rx_ready,         //          .ready
		input  wire         pcie_rx_valid,         //          .valid
		output wire [255:0] pcie_tx_data,          //   pcie_tx.data
		output wire         pcie_tx_startofpacket, //          .startofpacket
		output wire         pcie_tx_endofpacket,   //          .endofpacket
		output wire         pcie_tx_error,         //          .error
		output wire         pcie_tx_empty,         //          .empty
		output wire         pcie_tx_valid,         //          .valid
		input  wire [7:0]   rx_st_bar,             // rx_bar_be.rx_st_bar
		output wire         rx_st_mask             //          .rx_st_mask
	);

	// TODO: Auto-generated HDL template

	assign bar2_mm_address = 32'b00000000000000000000000000000000;

	assign bar2_mm_read = 1'b0;

	assign bar2_mm_write = 1'b0;

	assign bar2_mm_writedata = 32'b00000000000000000000000000000000;

	assign pcie_rx_ready = 1'b0;

	assign pcie_tx_valid = 1'b0;

	assign pcie_tx_data = 256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

	assign pcie_tx_startofpacket = 1'b0;

	assign pcie_tx_endofpacket = 1'b0;

	assign pcie_tx_error = 1'b0;

	assign pcie_tx_empty = 1'b0;

	assign rx_st_mask = 1'b0;

endmodule
