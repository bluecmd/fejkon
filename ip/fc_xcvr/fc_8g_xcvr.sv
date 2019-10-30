`timescale 1 ps / 1 ps
module fc_8g_xcvr (
    input  wire [31:0]  tx_data,                  //                     tx.data
    output wire         tx_ready,                 //                       .ready
    input  wire         tx_valid,                 //                       .valid
    input  wire         tx_startofpacket,         //                       .startofpacket
    input  wire         tx_endofpacket,           //                       .endofpacket
    output wire [31:0]  rx_data,                  //                     rx.data
    output wire         rx_valid,                 //                       .valid
    input  wire         rx_ready,                 //                       .ready
    output wire         rx_startofpacket,         //                       .startofpacket
    output wire         rx_endofpacket,           //                       .endofpacket
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
  wire [3:0]  tx_datak;
  wire [31:0] tx_parallel_data;
  wire [31:0] rx_parallel_data;
  wire [3:0]  rx_datak;
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
    .tx_parallel_data(tx_parallel_data),       //            tx_parallel_data.data
    .tx_datak(tx_datak),                       //                    tx_datak.data
    .tx_dispval(4'b0),                         //                  tx_dispval.data
    .tx_forcedisp(4'b0),                       //                tx_forcedisp.data
    .rx_parallel_data(rx_parallel_data),       //            rx_parallel_data.data
    .rx_datak(rx_datak),                       //                    rx_datak.data
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

  typedef enum integer {
    PRIM_IDLE = 0,
    PRIM_R_RDY,
    PRIM_BB_SCS,
    PRIM_BB_SCR,
    PRIM_SOFC1,
    PRIM_SOFI1,
    PRIM_SOFN1,
    PRIM_SOFI2,
    PRIM_SOFN2,
    PRIM_SOFI3,
    PRIM_SOFN3,
    PRIM_SOFC4,
    PRIM_SOFI4,
    PRIM_SOFN4,
    PRIM_SOFF,
    PRIM_EOFT,
    PRIM_EOFDT,
    PRIM_EOFA,
    PRIM_EOFN,
    PRIM_EOFNI,
    PRIM_EOFDTI,
    PRIM_EOFRT,
    PRIM_EOFRTI,
    PRIM_NOS,
    PRIM_OLS,
    PRIM_LR,
    PRIM_LRR,
    PRIM_MAX
  } primitives_t;

  int primitive_cntrs [PRIM_MAX];

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
  // Transmission order is:
  // - Byte 0 - bit 7:0
  // - ...
  // - Byte 3 - bit 31:24
  assign tx_parallel_data = tx_data;
  assign tx_datak = 4'b0000;

  typedef enum integer {
    STATE_ACTIVE,
    STATE_LR1,
    STATE_LR2,
    STATE_LR3,
    STATE_LF1,
    STATE_LF2,
    STATE_OL1,
    STATE_OL2,
    STATE_OL3
  } state_t;

  state_t state = STATE_OL1;

  assign rx_valid = state == STATE_ACTIVE;
  assign rx_data = rx_parallel_data;

  assign tx_ready = tx_xcvr_ready;

endmodule
