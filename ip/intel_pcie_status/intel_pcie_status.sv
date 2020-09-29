`timescale 1 ps / 1 ps
module intel_pcie_status (
    input  wire        derr_cor_ext_rcv_drv,  // hip_status_drv.derr_cor_ext_rcv
    input  wire        derr_cor_ext_rpl_drv,  //               .derr_cor_ext_rpl
    input  wire        derr_rpl_drv,          //               .derr_rpl
    input  wire        dlup_exit_drv,         //               .dlup_exit
    input  wire        ev128ns_drv,           //               .ev128ns
    input  wire        ev1us_drv,             //               .ev1us
    input  wire        hotrst_exit_drv,       //               .hotrst_exit
    input  wire [3:0]  int_status_drv,        //               .int_status
    input  wire        l2_exit_drv,           //               .l2_exit
    input  wire [3:0]  lane_act_drv,          //               .lane_act
    input  wire [4:0]  ltssmstate_drv,        //               .ltssmstate
    input  wire        dlup_drv,              //               .dlup
    input  wire        rx_par_err_drv,        //               .rx_par_err
    input  wire [1:0]  tx_par_err_drv,        //               .tx_par_err
    input  wire        cfg_par_err_drv,       //               .cfg_par_err
    input  wire [7:0]  ko_cpl_spc_header_drv, //               .ko_cpl_spc_header
    input  wire [11:0] ko_cpl_spc_data_drv,   //               .ko_cpl_spc_data
    output wire        derr_cor_ext_rcv_out,  // hip_status_out.derr_cor_ext_rcv
    output wire        derr_cor_ext_rpl_out,  //               .derr_cor_ext_rpl
    output wire        derr_rpl_out,          //               .derr_rpl
    output wire        dlup_exit_out,         //               .dlup_exit
    output wire        ev128ns_out,           //               .ev128ns
    output wire        ev1us_out,             //               .ev1us
    output wire        hotrst_exit_out,       //               .hotrst_exit
    output wire [3:0]  int_status_out,        //               .int_status
    output wire        l2_exit_out,           //               .l2_exit
    output wire [3:0]  lane_act_out,          //               .lane_act
    output wire [4:0]  ltssmstate_out,        //               .ltssmstate
    output wire        dlup_out,              //               .dlup
    output wire        rx_par_err_out,        //               .rx_par_err
    output wire [1:0]  tx_par_err_out,        //               .tx_par_err
    output wire        cfg_par_err_out,       //               .cfg_par_err
    output wire [7:0]  ko_cpl_spc_header_out, //               .ko_cpl_spc_header
    output wire [11:0] ko_cpl_spc_data_out,   //               .ko_cpl_spc_data
    input  wire [3:0]  mm_address,            //             mm.address
    output wire [31:0] mm_readdata,           //               .readdata
    input  wire        mm_read,               //               .read
    input  wire        clk,                   //            clk.clk
    input  wire        reset                  //          reset.reset
  );

  assign derr_cor_ext_rcv_out = derr_cor_ext_rcv_drv;
  assign hotrst_exit_out = hotrst_exit_drv;
  assign rx_par_err_out = rx_par_err_drv;
  assign ko_cpl_spc_data_out = ko_cpl_spc_data_drv;
  assign dlup_exit_out = dlup_exit_drv;
  assign derr_cor_ext_rpl_out = derr_cor_ext_rpl_drv;
  assign l2_exit_out = l2_exit_drv;
  assign dlup_out = dlup_drv;
  assign int_status_out = int_status_drv;
  assign ev128ns_out = ev128ns_drv;
  assign ltssmstate_out = ltssmstate_drv;
  assign tx_par_err_out = tx_par_err_drv;
  assign lane_act_out = lane_act_drv;
  assign cfg_par_err_out = cfg_par_err_drv;
  assign derr_rpl_out = derr_rpl_drv;
  assign ev1us_out = ev1us_drv;
  assign ko_cpl_spc_header_out = ko_cpl_spc_header_drv;

  reg [31:0] readdata_r = ~0;

  always_ff @(posedge clk) begin
    if (reset) begin
      readdata_r <= ~0;
    end else begin
      if (mm_address == 4'h0) begin
        readdata_r <= {20'b0, lane_act_out, 3'b0, ltssmstate_drv};
      end else begin
        readdata_r <= ~0;
      end
    end
  end

  assign mm_readdata = readdata_r;

endmodule
