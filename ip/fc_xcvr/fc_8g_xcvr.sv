`timescale 1 ps / 1 ps
module fc_8g_xcvr (
    input  wire [31:0] tx_data,        //       tx.data
    output wire        tx_ready,       //         .ready
    output wire [31:0] rx_data,        //       rx.data
    output wire        rx_valid,       //         .valid
    input  wire        reset,          //    reset.reset
    input  wire        mgmt_clk,       // mgmt_clk.clk
    input  wire [9:0]  mm_address,     //  mgmt_mm.address
    output wire        mm_waitrequest, //         .waitrequest
    input  wire        mm_read,        //         .read
    input  wire        mm_write,       //         .write
    output wire [31:0] mm_readdata,    //         .readdata
    input  wire [31:0] mm_writedata,   //         .writedata
    input  wire        rd_p,           //     line.rd_p
    input  wire        td_p,           //         .td_p
    output wire        tx_clk,         //   tx_clk.clk
    output wire        rx_clk          //   rx_clk.clk
  );

   fc_phy dut(
    .phy_mgmt_clk(mgmt_clk),           //                phy_mgmt_clk.clk
    .phy_mgmt_clk_reset(reset),        //          phy_mgmt_clk_reset.reset
    .phy_mgmt_address(),               //                    phy_mgmt.address
    .phy_mgmt_read(),                  //                            .read
    .phy_mgmt_readdata(),              //                            .readdata
    .phy_mgmt_waitrequest(),           //                            .waitrequest
    .phy_mgmt_write(),                 //                            .write
    .phy_mgmt_writedata(),             //                            .writedata
    .tx_ready(tx_ready),               //                    tx_ready.export
    .rx_ready(),                       //                    rx_ready.export
    .pll_ref_clk(mgmt_clk),            //                 pll_ref_clk.clk
    .tx_serial_data(),                 //              tx_serial_data.export
    .pll_locked(pll_locked),           //                  pll_locked.export
    .rx_serial_data(),                 //              rx_serial_data.export
    .rx_runningdisp(),                 //              rx_runningdisp.export
    .rx_disperr(),                     //                  rx_disperr.export
    .rx_errdetect(),                   //                rx_errdetect.export
    .rx_patterndetect(),               //            rx_patterndetect.export
    .rx_syncstatus(),                  //               rx_syncstatus.export
    .rx_bitslipboundaryselectout(),    // rx_bitslipboundaryselectout.export
    .tx_clkout0(tx_clk),               //                  tx_clkout0.clk
    .rx_clkout0(rx_clk),               //                  rx_clkout0.clk
    .tx_parallel_data0(),              //           tx_parallel_data0.data
    .tx_datak0(),                      //                   tx_datak0.data
    .tx_dispval0(),                    //                 tx_dispval0.data
    .tx_forcedisp0(),                  //               tx_forcedisp0.data
    .rx_parallel_data0(),              //           rx_parallel_data0.data
    .rx_datak0(),                      //                   rx_datak0.data
    .reconfig_from_xcvr(),             //          reconfig_from_xcvr.reconfig_from_xcvr
    .reconfig_to_xcvr()                //            reconfig_to_xcvr.reconfig_to_xcvr
  );


  assign rx_valid = 1'b0;

  assign rx_data = 32'b00000000000000000000000000000000;

  assign mm_waitrequest = 1'b0;

  assign mm_readdata = 32'b00000000000000000000000000000000;

endmodule
