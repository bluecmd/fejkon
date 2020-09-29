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
    output wire [4:0]   tlp_rx_st_empty,         //          .empty
    output wire         tlp_rx_st_endofpacket,   //          .endofpacket
    output wire         tlp_rx_st_error,         //          .error
    output wire         tlp_rx_st_startofpacket, //          .startofpacket
    output wire         tlp_rx_st_valid,         //          .valid
    input  wire         tlp_rx_st_ready,         //          .ready
    input  wire [255:0] tlp_tx_st_data,          // tlp_tx_st.data
    input  wire [4:0]   tlp_tx_st_empty,         //          .empty
    // NOTE: If we do not define channel here the standard way for Qsys
    // to convert a bus with channel to one without is to drop any data
    // not belonging to channel 0. Since we want all data, but don't care
    // which channel it is from, we declare we support 255 channels and
    // then simply ignore the input.
    input  wire [7:0]   tlp_tx_st_channel,       //          .channel
    input  wire         tlp_tx_st_endofpacket,   //          .endofpacket
    input  wire         tlp_tx_st_startofpacket, //          .startofpacket
    output wire         tlp_tx_st_ready,         //          .ready
    input  wire         tlp_tx_st_valid          //          .valid
  );

  timeunit      1ns;
  timeprecision 1ns;

  logic [1:0] phy_tx_st_empty_out;
  logic [2:0] tlp_rx_st_empty_out;

  // Map Intel PCIe custom "empty" signal to Avalon-ST standard for 32-bit
  // words
  always_comb begin
    case (tlp_tx_st_empty[4:2])
      3'h0: phy_tx_st_empty_out = 2'h0;
      3'h1: phy_tx_st_empty_out = 2'h0;
      3'h2: phy_tx_st_empty_out = 2'h1;
      3'h3: phy_tx_st_empty_out = 2'h1;
      3'h4: phy_tx_st_empty_out = 2'h2;
      3'h5: phy_tx_st_empty_out = 2'h2;
      3'h6: phy_tx_st_empty_out = 2'h3;
      3'h7: phy_tx_st_empty_out = 2'h3;
      // TODO: Add assert on default case
      default: phy_tx_st_empty_out = 2'h0;
    endcase
  end

  always_comb begin
    case (phy_rx_st_empty)
      2'h0: tlp_rx_st_empty_out = 3'h0;
      2'h1: tlp_rx_st_empty_out = 3'h2;
      2'h2: tlp_rx_st_empty_out = 3'h4;
      2'h3: tlp_rx_st_empty_out = 3'h6;
      // TODO: Add assert on default case
      default: tlp_rx_st_empty_out = 3'h0;
    endcase
  end

  // Even though Avalon-ST has the property to describe where the first symbol
  // is, Intel chose to ignore that and make it all wrong. So we turn the
  // symbols around.
  assign phy_tx_st_data[31:0]    = tlp_tx_st_data[255:224];
  assign phy_tx_st_data[63:32]   = tlp_tx_st_data[223:192];
  assign phy_tx_st_data[95:64]   = tlp_tx_st_data[191:160];
  assign phy_tx_st_data[127:96]  = tlp_tx_st_data[159:128];
  assign phy_tx_st_data[159:128] = tlp_tx_st_data[127:96];
  assign phy_tx_st_data[191:160] = tlp_tx_st_data[95:64];
  assign phy_tx_st_data[223:192] = tlp_tx_st_data[63:32];
  assign phy_tx_st_data[255:224] = tlp_tx_st_data[31:0];
  assign tlp_rx_st_data[255:224] = phy_rx_st_data[31:0];
  assign tlp_rx_st_data[223:192] = phy_rx_st_data[63:32];
  assign tlp_rx_st_data[191:160] = phy_rx_st_data[95:64];
  assign tlp_rx_st_data[159:128] = phy_rx_st_data[127:96];
  assign tlp_rx_st_data[127:96]  = phy_rx_st_data[159:128];
  assign tlp_rx_st_data[95:64]   = phy_rx_st_data[191:160];
  assign tlp_rx_st_data[63:32]   = phy_rx_st_data[223:192];
  assign tlp_rx_st_data[31:0]    = phy_rx_st_data[255:224];

  assign phy_tx_st_valid = tlp_tx_st_valid;
  assign phy_tx_st_startofpacket = tlp_tx_st_startofpacket;
  assign phy_tx_st_endofpacket = tlp_tx_st_endofpacket;
  assign phy_tx_st_error = 1'b0;
  assign phy_tx_st_empty = phy_tx_st_empty_out;

  assign phy_rx_st_ready = tlp_rx_st_ready;

  assign tlp_rx_st_valid = phy_rx_st_valid;
  assign tlp_rx_st_error = phy_rx_st_error;
  assign tlp_rx_st_startofpacket = phy_rx_st_startofpacket;
  assign tlp_rx_st_endofpacket = phy_rx_st_endofpacket;
  assign tlp_rx_st_empty = {tlp_rx_st_empty_out, 2'h0};

  assign tlp_tx_st_ready = phy_tx_st_ready;

endmodule
