// Black-box lint model for fc_phy

`timescale 1 ps / 1 ps
module fc_phy (
    input  wire         phy_mgmt_clk,                //                phy_mgmt_clk.clk
    input  wire         phy_mgmt_clk_reset,          //          phy_mgmt_clk_reset.reset
    input  wire [8:0]   phy_mgmt_address,            //                    phy_mgmt.address
    input  wire         phy_mgmt_read,               //                            .read
    output wire [31:0]  phy_mgmt_readdata,           //                            .readdata
    output wire         phy_mgmt_waitrequest,        //                            .waitrequest
    input  wire         phy_mgmt_write,              //                            .write
    input  wire [31:0]  phy_mgmt_writedata,          //                            .writedata
    output wire         tx_ready,                    //                    tx_ready.export
    output wire         rx_ready,                    //                    rx_ready.export
    input  wire [0:0]   pll_ref_clk,                 //                 pll_ref_clk.clk
    output wire [0:0]   tx_serial_data,              //              tx_serial_data.export
    output wire [0:0]   pll_locked,                  //                  pll_locked.export
    input  wire [0:0]   rx_serial_data,              //              rx_serial_data.export
    output wire [3:0]   rx_runningdisp,              //              rx_runningdisp.export
    output wire [3:0]   rx_disperr,                  //                  rx_disperr.export
    output wire [3:0]   rx_errdetect,                //                rx_errdetect.export
    output wire [3:0]   rx_patterndetect,            //            rx_patterndetect.export
    output wire [3:0]   rx_syncstatus,               //               rx_syncstatus.export
    output wire [4:0]   rx_bitslipboundaryselectout, // rx_bitslipboundaryselectout.export
    output wire         tx_clkout,                   //                   tx_clkout.clk
    output wire         rx_clkout,                   //                   rx_clkout.clk
    input  wire [31:0]  tx_parallel_data,            //            tx_parallel_data.data
    input  wire [3:0]   tx_datak,                    //                    tx_datak.data
    input  wire [3:0]   tx_dispval,                  //                  tx_dispval.data
    input  wire [3:0]   tx_forcedisp,                //                tx_forcedisp.data
    output wire [31:0]  rx_parallel_data,            //            rx_parallel_data.data
    output wire [3:0]   rx_datak,                    //                    rx_datak.data
    output wire [91:0]  reconfig_from_xcvr,          //          reconfig_from_xcvr.reconfig_from_xcvr
    input  wire [139:0] reconfig_to_xcvr             //            reconfig_to_xcvr.reconfig_to_xcvr
  );

endmodule
