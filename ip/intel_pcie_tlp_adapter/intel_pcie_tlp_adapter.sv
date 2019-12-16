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

  logic [1:0] phy_tx_st_empty_out;
  logic [2:0] tlp_rx_st_empty_out;

  // Map Intel PCIe custom "empty" signal to Avalon-ST standard for 32-bit
  // words
  always @(*) begin
    case (tlp_tx_st_empty)
      3'h0: phy_tx_st_empty_out = 2'h0;
      3'h1: phy_tx_st_empty_out = 2'h0;
      3'h2: phy_tx_st_empty_out = 2'h1;
      3'h3: phy_tx_st_empty_out = 2'h1;
      3'h4: phy_tx_st_empty_out = 2'h2;
      3'h5: phy_tx_st_empty_out = 2'h2;
      3'h6: phy_tx_st_empty_out = 2'h3;
      3'h7: phy_tx_st_empty_out = 2'h3;
    endcase
  end

  always @(*) begin
    case (phy_rx_st_empty)
      2'h0: tlp_rx_st_empty_out = 3'h0;
      2'h1: tlp_rx_st_empty_out = 3'h2;
      2'h2: tlp_rx_st_empty_out = 3'h4;
      2'h3: tlp_rx_st_empty_out = 3'h6;
    endcase
  end

  assign phy_tx_st_valid = tlp_tx_st_valid;
  assign phy_tx_st_data = tlp_tx_st_data;
  assign phy_tx_st_startofpacket = tlp_tx_st_startofpacket;
  assign phy_tx_st_endofpacket = tlp_tx_st_endofpacket;
  assign phy_tx_st_error = 1'b0;
  assign phy_tx_st_empty = phy_tx_st_empty_out;

  assign phy_rx_st_ready = tlp_rx_st_ready;

  assign tlp_rx_st_valid = phy_rx_st_valid;
  assign tlp_rx_st_data = phy_rx_st_data;
  assign tlp_rx_st_startofpacket = phy_rx_st_startofpacket;
  assign tlp_rx_st_endofpacket = phy_rx_st_endofpacket;
  assign tlp_rx_st_empty = tlp_rx_st_empty_out;

  assign tlp_tx_st_ready = phy_tx_st_ready;

endmodule
