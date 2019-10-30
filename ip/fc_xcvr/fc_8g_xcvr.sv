`timescale 1 ps / 1 ps
module fc_8g_xcvr (
    input  wire [31:0]  avtx_data,                //                   avtx.data
    output wire         avtx_ready,               //                       .ready
    input  wire         avtx_valid,               //                       .valid
    input  wire         avtx_startofpacket,       //                       .startofpacket
    input  wire         avtx_endofpacket,         //                       .endofpacket
    output wire [31:0]  avrx_data,                //                   avrx.data
    output wire         avrx_valid,               //                       .valid
    input  wire         avrx_ready,               //                       .ready
    output wire         avrx_startofpacket,       //                       .startofpacket
    output wire         avrx_endofpacket,         //                       .endofpacket
    input  wire         reset,                    //                  reset.reset
    input  wire         mgmt_clk,                 //               mgmt_clk.clk
    input  wire [9:0]   mm_address,               //                mgmt_mm.address
    output wire         mm_waitrequest,           //                       .waitrequest
    input  wire         mm_read,                  //                       .read
    input  wire         mm_write,                 //                       .write
    output wire [31:0]  mm_readdata,              //                       .readdata
    input  wire [31:0]  mm_writedata,             //                       .writedata
    input  wire         rd_p,                     //                line_rd.lvds
    output wire         td_p,                     //                line_td.lvds
    output wire         tx_clk,                   //                 tx_clk.clk
    output wire         rx_clk,                   //                 rx_clk.clk
    input  wire         phy_clk,                  //                phy_clk.clk
    input  wire [139:0] reconfig_to_xcvr,         //       reconfig_to_xcvr.
    output wire  [91:0] reconfig_from_xcvr        //     reconfig_from_xcvr.
  );

  wire        pll_locked;

  wire        rx_xcvr_ready;
  wire        tx_xcvr_ready;
  wire [3:0]  tx_le_datak;
  wire [31:0] tx_le_data;
  wire [31:0] rx_le_data;
  wire [3:0]  rx_le_datak;
  wire [3:0]  tx_be_datak;
  wire [31:0] tx_be_data;
  wire [31:0] rx_be_data;
  wire [3:0]  rx_be_datak;
  wire [3:0]  rx_disperr;
  wire [3:0]  rx_errdetect;
  wire [3:0]  rx_patterndetect;
  wire [3:0]  rx_syncstatus;

  wire [31:0] status_word;

  wire [8:0]  mgmt_address;
  wire        mgmt_read;
  wire [31:0] mgmt_readdata;
  wire        mgmt_waitrequest;
  wire        mgmt_write;
  wire [31:0] mgmt_writedata;

  fc_phy phy(
    .phy_mgmt_clk(mgmt_clk),                   //                phy_mgmt_clk.clk
    .phy_mgmt_clk_reset(reset),                //          phy_mgmt_clk_reset.reset
    .phy_mgmt_address(mgmt_address),           //                    phy_mgmt.address
    .phy_mgmt_read(mgmt_read),                 //                            .read
    .phy_mgmt_readdata(mgmt_readdata),         //                            .readdata
    .phy_mgmt_waitrequest(mgmt_waitrequest),   //                            .waitrequest
    .phy_mgmt_write(mgmt_write),               //                            .write
    .phy_mgmt_writedata(mgmt_writedata),       //                            .writedata
    .tx_ready(tx_xcvr_ready),                  //                    tx_ready.export
    .rx_ready(rx_xcvr_ready),                  //                    rx_ready.export
    .pll_ref_clk(phy_clk) ,                    //                 pll_ref_clk.clk
    .tx_serial_data(td_p),                     //              tx_serial_data.export
    .pll_locked(pll_locked),                   //                  pll_locked.export
    .rx_serial_data(rd_p),                     //              rx_serial_data.export
    .rx_runningdisp(),                         //              rx_runningdisp.export
    .rx_disperr(rx_disperr),                   //                  rx_disperr.export
    .rx_errdetect(rx_errdetect),               //                rx_errdetect.export
    .rx_patterndetect(rx_patterndetect),       //            rx_patterndetect.export
    .rx_syncstatus(rx_syncstatus),             //               rx_syncstatus.export
    .rx_bitslipboundaryselectout(),            // rx_bitslipboundaryselectout.export
    .tx_clkout(tx_clk),                        //                   tx_clkout.clk
    .rx_clkout(rx_clk),                        //                   rx_clkout.clk
    .tx_parallel_data(tx_le_data),             //            tx_parallel_data.data
    .tx_datak(tx_le_datak),                    //                    tx_datak.data
    .tx_dispval(4'b0),                         //                  tx_dispval.data
    .tx_forcedisp(4'b0),                       //                tx_forcedisp.data
    .rx_parallel_data(rx_le_data),             //            rx_parallel_data.data
    .rx_datak(rx_le_datak),                    //                    rx_datak.data
    .reconfig_from_xcvr(reconfig_from_xcvr),   //          reconfig_from_xcvr.reconfig_from_xcvr
    .reconfig_to_xcvr(reconfig_to_xcvr)        //            reconfig_to_xcvr.reconfig_to_xcvr
  );

  assign status_word = {15'b0, pll_locked, rx_disperr, rx_errdetect, rx_patterndetect, rx_syncstatus};

  logic [31:0] status_word_cdc1 = 0;
  logic [31:0] status_word_cdc2 = 0;
  logic [31:0] status_word_xfered = 0;

  always @(posedge mgmt_clk) begin
    status_word_cdc1 <= status_word;
    status_word_cdc2 <= status_word_cdc1;
    status_word_xfered <= status_word_cdc2;
  end

  function bit [7:0] D(input int X, input int Y);
    return {Y[2:0], X[4:0]};
  endfunction

  int tx_primitive_cntrs [fc::PRIM_MAX];
  int rx_primitive_cntrs [fc::PRIM_MAX];

  fc::primitives_t tx_prim = fc::PRIM_UNKNOWN, rx_prim = fc::PRIM_UNKNOWN;

  always @(posedge rx_clk) begin
    if (rx_be_datak == 4'b1000) begin
      rx_prim = fc::map_primitive(rx_be_data);
      rx_primitive_cntrs[rx_prim]++;
    end
  end

  always @(posedge tx_clk) begin
    if (tx_be_datak == 4'b1000) begin
      tx_prim = fc::map_primitive(tx_be_data);
      tx_primitive_cntrs[tx_prim]++;
    end
  end

  assign mm_waitrequest = mm_address[9] ? mgmt_waitrequest : 1'b0;
  assign mm_readdata    = mm_address[9] ? mgmt_readdata : status_word_xfered;
  assign mgmt_read      = mm_address[9] ? mm_read  : 1'b0;
  assign mgmt_write     = mm_address[9] ? mm_write : 1'b0;
  assign mgmt_writedata = mm_address[9] ? mm_writedata : 32'b0;
  assign mgmt_address   = mm_address[9] ? mm_address[8:0] : 9'b0;

  // TODO: Handle running disparity if default is not good enough

  // From FC-FS-5, 5.2.7.1 General
  // Characters within 8B/10B Ordered Sets shall be transmitted sequentially
  // beginning with the special character used to distinguish the Ordered Set
  // (e.g., K28.5) and proceeding character by character from left to right
  // within the definition of the Ordered Set until all characters of the
  // Ordered Set are transmitted.
  //
  // Transmission order for the XCVR is little-endian (7:0 is first byte)
  // while it makes much more sense to write logic using big-endian.
  // Thus, we convert it before shipping it of to the XCVR.
  assign tx_le_data[7:0]   = tx_be_data[31:24];
  assign tx_le_data[15:8]  = tx_be_data[23:16];
  assign tx_le_data[23:16] = tx_be_data[15:8];
  assign tx_le_data[31:24] = tx_be_data[7:0];
  assign tx_le_datak = {tx_be_datak[0], tx_be_datak[1], tx_be_datak[2], tx_be_datak[3]};
  assign rx_be_data[7:0]   = rx_le_data[31:24];
  assign rx_be_data[15:8]  = rx_le_data[23:16];
  assign rx_be_data[23:16] = rx_le_data[15:8];
  assign rx_be_data[31:24] = rx_le_data[7:0];
  assign rx_be_datak = {rx_le_datak[0], rx_le_datak[1], rx_le_datak[2], rx_le_datak[3]};

  logic [31:0] user_tx_data;
  logic [3:0]  user_tx_datak;

  assign user_tx_data = avtx_valid ? avtx_data : fc::IDLE;
  // The start and end primitive of a frame is a K28.5, that's the only time
  // the avtx stream has a control character
  assign user_tx_datak = (avtx_valid | avtx_startofpacket | avtx_endofpacket) ? 4'b0000 : 4'b0001;

  // Driven by fc_state_rx
  wire fc::state_t state;

  fc_state_rx state_rx (
    .clk(rx_clk),
    .reset(reset),
    .data(rx_be_data),
    .datak(rx_be_datak),
    .state(state)
  );

  fc_state_tx state_tx (
    .clk(tx_clk),
    .data(tx_be_data),
    .datak(tx_be_datak),
    .state(state)
  );

  // TODO(bluecmd): Note: On entry to the Active State, an FC_Port shall
  // transmit a minimum of 6 IDLES before transmitting other Transmission Words

  assign avrx_valid = state == fc::STATE_AC;
  assign avrx_data = rx_be_data;

  assign avtx_ready = tx_xcvr_ready;

endmodule
