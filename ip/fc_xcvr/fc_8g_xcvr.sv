`timescale 1 ps / 1 ps
module fc_8g_xcvr (
    input  wire [31:0]  tx_data,                  //                     tx.data
    output wire         tx_ready,                 //                       .ready
    output wire [31:0]  rx_data,                  //                     rx.data
    output wire         rx_valid,                 //                       .valid
    input  wire         reset,                    //                  reset.reset
    input  wire         mgmt_clk,                 //               mgmt_clk.clk
    input  wire [9:0]   mm_address,               //                mgmt_mm.address
    output wire         mm_waitrequest,           //                       .waitrequest
    input  wire         mm_read,                  //                       .read
    input  wire         mm_write,                 //                       .write
    output wire [31:0]  mm_readdata,              //                       .readdata
    input  wire [31:0]  mm_writedata,             //                       .writedata
    input  wire         rd_p,                     //                line_rd.lvds
    input  wire         td_p,                     //                line_td.lvds
    output wire         tx_clk,                   //                 tx_clk.clk
    output wire         rx_clk,                   //                 rx_clk.clk
    input  wire         phy_clk,                  //                phy_clk.clk
    input  wire [139:0] reconfig_to_xcvr,         //       reconfig_to_xcvr.
    output wire  [91:0] reconfig_from_xcvr        //     reconfig_from_xcvr.
  );

  wire [3:0]  tx_datak;
  wire [31:0] tx_parallel_data;
  wire [31:0] rx_parallel_data;
  wire [3:0]  rx_syncstatus;

  fc_phy phy(
    .phy_mgmt_clk(mgmt_clk),                   //                phy_mgmt_clk.clk
    .phy_mgmt_clk_reset(reset),                //          phy_mgmt_clk_reset.reset
    .phy_mgmt_address(),                       //                    phy_mgmt.address
    .phy_mgmt_read(),                          //                            .read
    .phy_mgmt_readdata(),                      //                            .readdata
    .phy_mgmt_waitrequest(),                   //                            .waitrequest
    .phy_mgmt_write(),                         //                            .write
    .phy_mgmt_writedata(),                     //                            .writedata
    .tx_ready(tx_ready),                       //                    tx_ready.export
    .rx_ready(),                               //                    rx_ready.export
    .pll_ref_clk(phy_clk) ,                    //                 pll_ref_clk.clk
    .tx_serial_data(td_p),                     //              tx_serial_data.export
    .pll_locked(pll_locked),                   //                  pll_locked.export
    .rx_serial_data(rd_p),                     //              rx_serial_data.export
    .rx_runningdisp(),                         //              rx_runningdisp.export
    .rx_disperr(),                             //                  rx_disperr.export
    .rx_errdetect(),                           //                rx_errdetect.export
    .rx_patterndetect(),                       //            rx_patterndetect.export
    .rx_syncstatus(rx_syncstatus),             //               rx_syncstatus.export
    .rx_bitslipboundaryselectout(),            // rx_bitslipboundaryselectout.export
    .tx_clkout(tx_clk),                        //                   tx_clkout.clk
    .rx_clkout(rx_clk),                        //                   rx_clkout.clk
    .tx_parallel_data(tx_parallel_data),       //            tx_parallel_data.data
    .tx_datak(tx_datak),                       //                    tx_datak.data
    .tx_dispval(4'b0),                         //                  tx_dispval.data
    .tx_forcedisp(4'b0),                       //                tx_forcedisp.data
    .rx_parallel_data(rx_parallel_data),       //            rx_parallel_data.data
    .rx_datak(),                               //                    rx_datak.data
    .reconfig_from_xcvr(reconfig_from_xcvr),   //          reconfig_from_xcvr.reconfig_from_xcvr
    .reconfig_to_xcvr(reconfig_to_xcvr)        //            reconfig_to_xcvr.reconfig_to_xcvr
  );

  // TODO: Handle running disparity

  // TODO: Send only IDLE (K28.5 D21.4 D21.5 D21.5) for now
  // TODO: Verify bit order
  //
  // From FC-FS-5, 5.2.7.1 General
  // Characters within 8B/10B Ordered Sets shall be transmitted sequentially
  // beginning with the special character used to distinguish the Ordered Set
  // (e.g., K28.5) and proceeding character by character from left to right
  // within the definition of the Ordered Set until all characters of the
  // Ordered Set are transmitted.
  assign tx_parallel_data = 32'hB5B595BC;
  assign tx_datak = 4'b0001;

  assign rx_valid = rx_syncstatus == 4'b1111;
  // TODO: change stream data format to be 9-bit for K-bit
  assign rx_data = rx_parallel_data;

  assign mm_waitrequest = 1'b0;
  assign mm_readdata = 32'b00000000000000000000000000000000;

  endmodule
