// (C) 2001-2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altpcied_sv_hwtcl # (
   parameter MAX_NUM_FUNC_SUPPORT             = 8,
   parameter num_of_func_hwtcl                = MAX_NUM_FUNC_SUPPORT,
   parameter device_family_hwtcl              = "Stratix V",
   parameter use_crc_forwarding_hwtcl         = 0,
   parameter pld_clockrate_hwtcl              = 125000000,
   parameter lane_mask_hwtcl                  = "x4",
   parameter max_payload_size_hwtcl           = 256,
   parameter gen123_lane_rate_mode_hwtcl      = "Gen1 (2.5 Gbps)",
   parameter ast_width_hwtcl                  = "Avalon-ST 64-bit",
   parameter port_width_data_hwtcl            = 64,
   parameter port_width_be_hwtcl              = 8,
   parameter extend_tag_field_hwtcl           = 32,
   parameter avalon_waddr_hwltcl              = 12,
   parameter check_bus_master_ena_hwtcl       = 1,
   parameter check_rx_buffer_cpl_hwtcl        = 1,
   parameter port_type_hwtcl                  = "Native endpoint",
   parameter apps_type_hwtcl                  = 2,
   parameter multiple_packets_per_cycle_hwtcl = 0,
   parameter use_ast_parity                   = 0

) (
      // Reset signals

      input                  reset_status,
      input                  serdes_pll_locked,
      input                  pld_clk_inuse,
      output                 pld_core_ready,

      // Clock
      input                  coreclkout_hip,
      output                 pld_clk_hip,
      input                  testin_zero,

      // HIP control signals
      output  [4 : 0]        hpg_ctrler,

      // Application signals inputs
      output  [4 : 0]        aer_msi_num,
      output  [(2**addr_width_delta(num_of_func_hwtcl))-1 : 0] app_int_sts,
      output  [2 : 0]        app_msi_func,
      output  [4 : 0]        app_msi_num,
      output                 app_msi_req,
      output  [2 : 0]        app_msi_tc,
      output  [4 : 0]        pex_msi_num,

      output  [addr_width_delta(num_of_func_hwtcl)+11 : 0] lmi_addr,
      output  [31 : 0]       lmi_din,
      output                 lmi_rden,
      output                 lmi_wren,
      output                 pm_auxpwr,
      output  [9 : 0]        pm_data,
      output                 pme_to_cr,
      output                 pm_event,
      output  [2 : 0]        pm_event_func,

      output  [port_width_data_hwtcl-1  : 0]          tx_st_data,
      output  [((device_family_hwtcl == "Arria V" || device_family_hwtcl == "Cyclone V")?1:2)-1:0] tx_st_empty,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_eop,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_err,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_sop,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_valid,
      output  [port_width_be_hwtcl-1:0]               tx_st_parity,
      input                                           tx_st_ready,
      input                                           tx_fifo_empty,

      output  [6 :0]         cpl_err,
      output  [num_of_func_hwtcl-1:0] cpl_pending,
      output  [2 :0]         cpl_err_func,

      // Input HIP Status signals
      input                derr_cor_ext_rcv,
      input                derr_cor_ext_rpl,
      input                derr_rpl,
      input                rx_par_err ,
      input [1:0]          tx_par_err ,
      input                cfg_par_err,
      input                dlup,
      input                dlup_exit,
      input                ev128ns,
      input                ev1us,
      input                hotrst_exit,
      input [3 : 0]        int_status,
      input                l2_exit,
      input [3:0]          lane_act,
      input [4 : 0]        ltssmstate,
      input [7:0]          ko_cpl_spc_header,
      input [11:0]         ko_cpl_spc_data,
      input                rxfc_cplbuf_ovf,

      input                app_int_ack,
      input                app_msi_ack,
      input                lmi_ack,
      input [31 : 0]       lmi_dout,
      input                pme_to_sr,

      // Output HIP status signals
      output                derr_cor_ext_rcv_drv,
      output                derr_cor_ext_rpl_drv,
      output                derr_rpl_drv,
      output                dlup_drv,
      output                dlup_exit_drv,
      output                ev128ns_drv,
      output                ev1us_drv,
      output                hotrst_exit_drv,
      output [3 : 0]        int_status_drv,
      output                l2_exit_drv,
      output [3:0]          lane_act_drv,
      output [4 : 0]        ltssmstate_drv,
      output                rx_par_err_drv,
      output [1:0]          tx_par_err_drv,
      output                cfg_par_err_drv,
      output [7:0]          ko_cpl_spc_header_drv,
      output [11:0]         ko_cpl_spc_data_drv,

      input [port_width_be_hwtcl-1  :0]            rx_st_parity,
      input [port_width_data_hwtcl-1:0]            rx_st_data,
      output                                       rx_st_ready,
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_sop,
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_valid,
      input [((device_family_hwtcl == "Arria V" || device_family_hwtcl == "Cyclone V")?1:2)-1:0] rx_st_empty,
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_eop,
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_err,

      input [port_width_be_hwtcl-1  :0] rx_st_be,
      output                            rx_st_mask,
      input [7 : 0]                     rx_st_bar,
      input [2 : 0]        rx_bar_dec_func_num,

      input                serr_out,
      input                sim_pipe_pclk_out,

      input [addr_width_delta(num_of_func_hwtcl)+3 : 0] tl_cfg_add,
      input [31 : 0]       tl_cfg_ctl,
      input [((num_of_func_hwtcl-1)*10)+52 : 0] tl_cfg_sts,
      input                tl_cfg_ctl_wr,
      input                tl_cfg_sts_wr,

      // tx credits
      input [11 : 0]       tx_cred_datafccp,
      input [11 : 0]       tx_cred_datafcnp,
      input [11 : 0]       tx_cred_datafcp,
      input [5 : 0]        tx_cred_fchipcons,
      input [5 : 0]        tx_cred_fcinfinite,
      input [7 : 0]        tx_cred_hdrfccp,
      input [7 : 0]        tx_cred_hdrfcnp,
      input [7 : 0]        tx_cred_hdrfcp

      );

      assign                derr_cor_ext_rcv_drv = derr_cor_ext_rcv;
      assign                derr_cor_ext_rpl_drv = derr_cor_ext_rpl;
      assign                derr_rpl_drv = derr_rpl;
      assign                dlup_drv = dlup;
      assign                dlup_exit_drv = dlup_exit;
      assign                ev128ns_drv = ev128ns;
      assign                ev1us_drv =  ev1us;
      assign                hotrst_exit_drv = hotrst_exit;
      assign                int_status_drv = int_status;
      assign                l2_exit_drv = l2_exit;
      assign                lane_act_drv = lane_act;
      assign                ltssmstate_drv = ltssmstate;
      assign                rx_par_err_drv = rx_par_err;
      assign                tx_par_err_drv = tx_par_err;
      assign                cfg_par_err_drv = cfg_par_err;
      assign                ko_cpl_spc_header_drv = ko_cpl_spc_header;
      assign                ko_cpl_spc_data_drv = ko_cpl_spc_data;


function integer clogb2 (input integer depth);
begin
   clogb2 = 0;
   for(clogb2=0; depth>1; clogb2=clogb2+1)
      depth = depth >> 1;
end
endfunction
function integer addr_width_delta (input integer num_of_func);
begin
   if (num_of_func > 1) begin
      addr_width_delta = clogb2(MAX_NUM_FUNC_SUPPORT);
   end
   else begin
      addr_width_delta = 0;
   end
end
endfunction

function integer is_pld_clk_250MHz;
   input [8*25:1] l_ast_width;
   input [8*25:1] l_gen123_lane_rate_mode;
   input [8*25:1] l_lane_mask;
   begin
           if ((l_ast_width=="Avalon-ST 64-bit" ) && (l_gen123_lane_rate_mode=="Gen2 (5.0 Gbps)") && (l_lane_mask=="x4")) is_pld_clk_250MHz=1;
      else if ((l_ast_width=="Avalon-ST 64-bit" ) && (l_gen123_lane_rate_mode=="Gen1 (2.5 Gbps)") && (l_lane_mask=="x8")) is_pld_clk_250MHz=1;
      else if ((l_ast_width=="Avalon-ST 128-bit") && (l_gen123_lane_rate_mode=="Gen2 (5.0 Gbps)") && (l_lane_mask=="x8")) is_pld_clk_250MHz=1;
      else                                                                                                                is_pld_clk_250MHz=0;
   end
endfunction

localparam rxtx_st_empty_width = (device_family_hwtcl == "Arria V" || device_family_hwtcl == "Cyclone V") ? 1 : 2;
localparam IS_ROOTPORT= (port_type_hwtcl == "Root port")?1:0;
localparam PLD_CLK_IS_250MHZ = is_pld_clk_250MHz(ast_width_hwtcl, gen123_lane_rate_mode_hwtcl, lane_mask_hwtcl);

//synthesis translate_off
localparam ALTPCIE_ED_SIM_ONLY  = 1;
//synthesis translate_on
//synthesis read_comments_as_HDL on
//localparam ALTPCIE_ED_SIM_ONLY  = 0;
//synthesis read_comments_as_HDL off

wire [  7: 0] open_msi_stream_data0;
wire          open_msi_stream_valid0;
wire [23: 0]  open_cfg_tcvcmap;

wire           app_rstn;
wire [127: 0]  err_desc;
wire [12: 0]   cfg_busdev;
wire [31: 0]   cfg_devcsr;
wire [19: 0]   cfg_io_bas;
wire [31: 0]   cfg_linkcsr;
wire [15: 0]   cfg_msicsr;
wire [11: 0]   cfg_np_bas;
wire [43: 0]   cfg_pr_bas;
wire [31: 0]   cfg_prmcsr;
wire [ 6: 0]   cpl_err_in;

wire [255:0] ZEROS = 256'h0;

// tl_cfg strobes not used in SV Reva Silicon
//wire tl_cfg_ctl_wr=1'b0;
//wire tl_cfg_sts_wr=1'b0;

wire         reset_status_hip;

wire coreclkout_pll_locked;
wire pld_clk;

reg [addr_width_delta(num_of_func_hwtcl)+3 : 0]  tl_cfg_add_r;
reg [31 : 0] tl_cfg_ctl_r;
reg [((num_of_func_hwtcl-1)*10)+52 : 0] tl_cfg_sts_r;
reg [2:0]   reset_status_sync_pldclk_r;

wire        reset_status_sync_pldclk;
wire        app_int_sts_vec_int;
wire        cpl_pending_int;
wire [11:0] lmi_addr_int;
wire [1:0]  tx_st_empty_int;

   generate begin : g_lmi_addr
      if (num_of_func_hwtcl==1) begin
         assign lmi_addr = lmi_addr_int;
      end
      else begin
         assign lmi_addr = {{clogb2(MAX_NUM_FUNC_SUPPORT){1'b0}}, lmi_addr_int};
      end
   end
   endgenerate
   generate begin : g_cpl_pending
      if (num_of_func_hwtcl==1) begin
         assign cpl_pending = cpl_pending_int;
      end
      else begin
         assign cpl_pending = {7'h0, cpl_pending_int};
      end
   end
   endgenerate
   generate begin : g_tl_app_int_sts_vec
      if (num_of_func_hwtcl==1) begin
         assign app_int_sts = app_int_sts_vec_int;
      end
      else begin
         assign app_int_sts = {7'h0, app_int_sts_vec_int};
      end
   end
   endgenerate

   assign tx_st_empty = tx_st_empty_int[rxtx_st_empty_width-1 : 0];

   assign app_msi_func = 3'd0;

   // Parity is currently not supported in the design example
   assign tx_st_parity =ZEROS[port_width_be_hwtcl-1:0];

   //////////////// SIMULATION-ONLY CONTENTS
   //synthesis translate_off
   initial begin
      reset_status_sync_pldclk_r = 3'b111;
   end
  //synthesis translate_on

   always @(posedge pld_clk or posedge reset_status) begin
      if (reset_status == 1'b1) begin
         reset_status_sync_pldclk_r <= 3'b111;
      end
      else begin
         reset_status_sync_pldclk_r[0] <= 1'b0;
         reset_status_sync_pldclk_r[1] <= reset_status_sync_pldclk_r[0];
         reset_status_sync_pldclk_r[2] <= reset_status_sync_pldclk_r[1];
      end
   end
   assign reset_status_sync_pldclk = reset_status_sync_pldclk_r[2];

   always @(posedge pld_clk or posedge reset_status_sync_pldclk) begin
      if (reset_status_sync_pldclk == 1'b1) begin
          tl_cfg_add_r        <= 0                 ;
          tl_cfg_ctl_r        <= ZEROS[31 : 0]     ;
          tl_cfg_sts_r        <= 0                 ;
      end
      else begin
          tl_cfg_add_r        <=  tl_cfg_add       ;
          tl_cfg_ctl_r        <=  tl_cfg_ctl       ;
          tl_cfg_sts_r        <=  tl_cfg_sts       ;
      end
   end

   assign reset_status_hip = ~reset_status_sync_pldclk;

   altpcierd_tl_cfg_sample #(
      .HIP_SV((device_family_hwtcl == "Arria V" || device_family_hwtcl == "Cyclone V") ? 0 : 1)
      ) cfgbus (
      .pld_clk          (pld_clk),
      .rstn             (app_rstn),
      .cfg_busdev       (cfg_busdev),
      .cfg_devcsr       (cfg_devcsr),
      .cfg_io_bas       (cfg_io_bas),
      .cfg_linkcsr      (cfg_linkcsr),
      .cfg_msicsr       (cfg_msicsr),
      .cfg_np_bas       (cfg_np_bas),
      .cfg_pr_bas       (cfg_pr_bas),
      .cfg_prmcsr       (cfg_prmcsr),
      .cfg_tcvcmap      (open_cfg_tcvcmap),
      .tl_cfg_add       (tl_cfg_add_r[3:0]),
      .tl_cfg_ctl       (tl_cfg_ctl_r),
      .tl_cfg_ctl_wr    (tl_cfg_ctl_wr),
      .tl_cfg_sts       (tl_cfg_sts_r[52:0]),
      .tl_cfg_sts_wr    (tl_cfg_sts_wr)
   );

   generate begin : g_enpoint
      if (IS_ROOTPORT == 0) begin
         wire open_cplerr_lmi_busy;
         altpcierd_cplerr_lmi lmi_blk (
            .clk_in (pld_clk),
            .rstn (app_rstn),
            .cpl_err_in (cpl_err_in),
            .cpl_err_out (cpl_err),
            .cplerr_lmi_busy (open_cplerr_lmi_busy),
            .err_desc (err_desc),
            .lmi_ack (lmi_ack),
            .lmi_addr (lmi_addr_int),
            .lmi_din (lmi_din),
            .lmi_rden (lmi_rden),
            .lmi_wren (lmi_wren)
         );
      end
   end
   endgenerate

   altpcierd_hip_rs rs_hip (
      .npor             (reset_status_hip & pld_clk_inuse),
      .pld_clk          (pld_clk),
      .dlup_exit        (dlup_exit),
      .hotrst_exit      (reset_status_hip),
      .l2_exit          (l2_exit),
      .ltssm            (ltssmstate),
      .app_rstn         (app_rstn),
      .test_sim         (testin_zero)
   );

   wire    [ 81: 0] rx_stream_data0;
   wire    [ 81: 0] rx_stream_data0_1;

   generate begin : g_rxstream
      if (ast_width_hwtcl=="Avalon-ST 128-bit") begin
         assign rx_stream_data0   = {rx_st_be[7 : 0], rx_st_sop[0], rx_st_empty[0], rx_st_bar, rx_st_data[63 : 0]} ;
         assign rx_stream_data0_1 = {rx_st_be[15: 8], rx_st_sop[0], rx_st_eop[0], rx_st_bar, rx_st_data[127 : 64]} ;
      end
      else begin
         assign rx_stream_data0   = {rx_st_be[7:0], rx_st_sop[0], rx_st_eop[0], rx_st_bar, rx_st_data};
         assign rx_stream_data0_1 = 82'h0;
      end
   end
   endgenerate


   generate begin : g_chaining_dma

      if (((ast_width_hwtcl=="Avalon-ST 64-bit")||(ast_width_hwtcl=="Avalon-ST 128-bit")) && (IS_ROOTPORT == 0)) begin

         wire    [ 74: 0] tx_stream_data0;
         wire    [ 74: 0] tx_stream_data0_1;
         wire    [127:0]  tx_st_data_int;

         assign tx_st_sop[0]  = tx_stream_data0[73];
         assign tx_st_err     = (multiple_packets_per_cycle_hwtcl==1)?{1'b0, tx_stream_data0[74]}:tx_stream_data0[74];
         assign tx_st_eop[0]                          = (ast_width_hwtcl=="Avalon-ST 128-bit")?tx_stream_data0_1[72]                              : tx_stream_data0[72];
         assign tx_st_empty_int[0]                    = (ast_width_hwtcl=="Avalon-ST 128-bit")?tx_stream_data0[72]                                : 1'b0;
         assign tx_st_empty_int[1]                    = 1'b0;
         assign tx_st_data_int                        = (ast_width_hwtcl=="Avalon-ST 128-bit")?{tx_stream_data0_1[63 : 0],tx_stream_data0[63 : 0]}: {64'h0,tx_stream_data0[63 : 0]} ;
         assign tx_st_data[port_width_data_hwtcl-1:0] = tx_st_data_int[port_width_data_hwtcl-1:0];

         altpcierd_example_app_chaining # (

            .AVALON_WADDR           (avalon_waddr_hwltcl),
            .CHECK_BUS_MASTER_ENA   (check_bus_master_ena_hwtcl),
            .CHECK_RX_BUFFER_CPL    (check_rx_buffer_cpl_hwtcl ),
            .CLK_250_APP            (is_pld_clk_250MHz(ast_width_hwtcl, gen123_lane_rate_mode_hwtcl, lane_mask_hwtcl )),
            .ECRC_FORWARD_CHECK     (0),
            .ECRC_FORWARD_GENER     (0),
            .MAX_NUMTAG             (20),
            .MAX_PAYLOAD_SIZE_BYTE  (max_payload_size_hwtcl),
            .TL_SELECTION           ((ast_width_hwtcl=="Avalon-ST 128-bit")?7:6),
            .INTENDED_DEVICE_FAMILY (device_family_hwtcl),
            .TXCRED_WIDTH           (36)

            ) app (

            .clk_in      (pld_clk),
            .rstn        (app_rstn),
            .test_sim    (testin_zero),

            .aer_msi_num (aer_msi_num),
            .app_int_ack (app_int_ack),
            .app_int_sts (app_int_sts_vec_int),
            .app_msi_ack (app_msi_ack),
            .app_msi_num (app_msi_num),
            .app_msi_req (app_msi_req),
            .app_msi_tc  (app_msi_tc),

            .pex_msi_num (pex_msi_num),
            .pm_data     (pm_data),

            .cfg_busdev  (cfg_busdev),
            .cfg_devcsr  (cfg_devcsr),
            .cfg_linkcsr (cfg_linkcsr),
            .cfg_msicsr  (cfg_msicsr),
            .cfg_prmcsr  (cfg_prmcsr),
            .cfg_tcvcmap (ZEROS[23:0]),

            .cpl_err          (cpl_err_in),
            .cpl_pending      (cpl_pending_int),
            .err_desc         (err_desc),
            .ko_cpl_spc_vc0   ({ko_cpl_spc_data,ko_cpl_spc_header}),

            .msi_stream_data0    (open_msi_stream_data0),
            .msi_stream_ready0   (1'b0),
            .msi_stream_valid0   (open_msi_stream_valid0),
            .tx_stream_fifo_empty0  (tx_fifo_empty),

            .rx_stream_data0_0      (rx_stream_data0),
            .rx_stream_data0_1      (rx_stream_data0_1),
            .rx_stream_mask0        (rx_st_mask),
            .rx_stream_ready0       (rx_st_ready),
            .rx_stream_valid0       (rx_st_valid[0]),

            .tx_stream_cred0        ({tx_cred_datafccp[11 : 0], tx_cred_hdrfccp[2 : 0], tx_cred_datafcnp[2 : 0],tx_cred_hdrfcnp[2 : 0],tx_cred_datafcp[11 : 0],tx_cred_hdrfcp[2 : 0]}),
            .tx_stream_data0_0      (tx_stream_data0),
            .tx_stream_data0_1      (tx_stream_data0_1),
            .tx_stream_mask0        (1'b0),
            .tx_stream_ready0       (tx_st_ready),
            .tx_stream_valid0       (tx_st_valid[0])
         );
   end
end
endgenerate

generate begin : g_target
   if ((ast_width_hwtcl=="Avalon-ST 256-bit") && (IS_ROOTPORT == 0)) begin

      altpcierd_ast256_downstream # (
         .AVALON_WADDR           (avalon_waddr_hwltcl),
         .CLK_250_APP            (0),
         .ECRC_FORWARD_CHECK     (0),
         .ECRC_FORWARD_GENER     (0),
         .MAX_NUMTAG             (extend_tag_field_hwtcl),
         .MAX_PAYLOAD_SIZE_BYTE  (max_payload_size_hwtcl),
         .TL_SELECTION           (9)
         ) app (

         .rstn                   (app_rstn),
         .clk_in                 (pld_clk),
         .test_sim               (testin_zero),

         .aer_msi_num            (aer_msi_num),
         .app_int_ack            (app_int_ack),
         .app_int_sts            (app_int_sts_vec_int),
         .app_msi_ack            (app_msi_ack),
         .app_msi_num            (app_msi_num),
         .app_msi_req            (app_msi_req),
         .app_msi_tc             (app_msi_tc),

         .pex_msi_num            (pex_msi_num),
         .pm_data                (pm_data),

         .cfg_busdev             (cfg_busdev),
         .cfg_devcsr             (cfg_devcsr),
         .cfg_linkcsr            (cfg_linkcsr),
         .cfg_msicsr             (cfg_msicsr),
         .cfg_prmcsr             (cfg_prmcsr),
         .cfg_tcvcmap            (ZEROS[23:0]),

         .cpl_err                (cpl_err_in),
         .cpl_pending            (cpl_pending_int),
         .err_desc               (err_desc),

         .ko_cpl_spc_vc0         ({ko_cpl_spc_data,ko_cpl_spc_header}),

         .rx_st_bardec0          (rx_st_bar     ),
         .rx_st_be0              (rx_st_be      ),
         .rx_st_data0            (rx_st_data    ),
         .rx_st_empty0           ((device_family_hwtcl == "Arria V" || device_family_hwtcl == "Cyclone V") ? {1'b0, rx_st_empty[0]} : rx_st_empty),
         .rx_st_eop0             (rx_st_eop[0]  ),
         .rx_st_err0             (rx_st_err[0]  ),
         .rx_st_mask0            (rx_st_mask    ),
         .rx_st_ready0           (rx_st_ready   ),
         .rx_st_sop0             (rx_st_sop[0]  ),
         .rx_st_valid0           (rx_st_valid[0]),

         .tx_cred_datafccp       (tx_cred_datafccp),
         .tx_cred_datafcnp       (tx_cred_datafcnp),
         .tx_cred_datafcp        (tx_cred_datafcp),
         .tx_cred_fchipcons      (tx_cred_fchipcons),
         .tx_cred_fcinfinite     (tx_cred_fcinfinite),
         .tx_cred_hdrfccp        (tx_cred_hdrfccp),
         .tx_cred_hdrfcnp        (tx_cred_hdrfcnp),
         .tx_cred_hdrfcp         (tx_cred_hdrfcp),

         .tx_st_data0            (tx_st_data),
         .tx_st_empty0           (tx_st_empty_int),
         .tx_st_eop0             (tx_st_eop[0]),
         .tx_st_err0             (tx_st_err[0]),
         .tx_st_ready0           (tx_st_ready),
         .tx_st_sop0             (tx_st_sop[0]),
         .tx_st_valid0           (tx_st_valid[0]));
   end
end
endgenerate

generate begin : g_root_port
   if ( (IS_ROOTPORT == 1) && (gen123_lane_rate_mode_hwtcl!="Gen3 (8.0 Gbps)") ) begin
      assign  aer_msi_num   = ZEROS[4 : 0]  ;
      assign  app_int_sts_vec_int = 1'b0    ;
      assign  app_msi_num   = ZEROS[4 : 0]  ;
      assign  app_msi_req   = 1'b0          ;
      assign  app_msi_tc    = ZEROS[2 : 0]  ;
      assign  pex_msi_num   = ZEROS[4 : 0]  ;
      assign  lmi_addr_int  = ZEROS[11:0]   ;
      assign  lmi_din       = ZEROS[31 : 0] ;
      assign  lmi_rden      = 1'b0          ;
      assign  lmi_wren      = 1'b0          ;
      assign  cpl_err       = ZEROS[6:0]    ;
      assign  cpl_pending_int = 1'b0        ;
      assign  pm_data       = ZEROS[9:0]    ;

   //////////////// SIMULATION-ONLY CONTENTS
   //synthesis translate_off
   //delay reset for RP
      reg srstn_r, srstn_rr;
      initial begin
         srstn_r  = 1'b0;
         srstn_rr = 1'b0;
      end

      wire [3:0] swdn_out=4'h1;
      wire [127:0] tx_st_data_int;

      assign tx_st_empty_int[1] = 1'b0;

      always @(posedge pld_clk or posedge reset_status_sync_pldclk) begin
         if (reset_status_sync_pldclk == 1'b1) begin
             srstn_r <= 0;
             srstn_rr <= 0;
         end
         else begin
             srstn_r <= 1;
             srstn_rr <= srstn_r;
         end
      end

      assign tx_st_data[port_width_data_hwtcl-1:0]  = tx_st_data_int[port_width_data_hwtcl-1:0];
      assign tx_st_err     = (multiple_packets_per_cycle_hwtcl==1)?2'b00:1'b0;

      altpcietb_bfm_rp_vc_driver  # (
        .ast_width_hwtcl   (ast_width_hwtcl),
        .apps_type_hwtcl   (apps_type_hwtcl)
          ) bfm_rp_vc_driver (
        .cfg_io_bas        (cfg_io_bas),
        .cfg_np_bas        (cfg_np_bas),
        .cfg_pr_bas        (cfg_pr_bas),
        .coreclkout_hip    (coreclkout_hip),
        .rstn              (srstn_rr),
        .rx_mask           (rx_st_mask),
        .rx_st_be          ((ast_width_hwtcl=="Avalon-ST 128-bit")?rx_st_be  :{8'h0,rx_st_be}),
        .rx_st_data        ((ast_width_hwtcl=="Avalon-ST 128-bit")?rx_st_data:{64'h0,rx_st_data}),
        .rx_st_empty       ((ast_width_hwtcl=="Avalon-ST 128-bit")?rx_st_empty[0]:1'b0),
        .rx_st_eop         (rx_st_eop[0]),
        .rx_st_ready       (rx_st_ready),
        .rx_st_sop         (rx_st_sop[0]),
        .rx_st_valid       (rx_st_valid[0]),
        .tx_cred           (36'hFFFFFFFFF),
        .tx_fifo_empty     (tx_fifo_empty),
        .tx_st_data        (tx_st_data_int),
        .tx_st_empty       (tx_st_empty_int[0]),
        .tx_st_eop         (tx_st_eop[0]),
        .tx_st_ready       (tx_st_ready),
        .tx_st_sop         (tx_st_sop[0]),
        .tx_st_valid       (tx_st_valid[0]),
        .ltssmstate        (ltssmstate),
        .reset_status_hip  (reset_status_hip),
        .INTA              (swdn_out[0]),
        .INTB              (swdn_out[1]),
        .INTC              (swdn_out[2]),
        .INTD              (swdn_out[3]),
        .sim_pipe_pclk_out (sim_pipe_pclk_out)
      );

   //////////////// END SIMULATION-ONLY CONTENTS
   //synthesis translate_on
   // The section bellow is for synthesis only and is not used for simulation
   // The RP DUT is using basic loopback rx AST --> AST
   //synthesis read_comments_as_HDL on
   //     reg [port_width_data_hwtcl-1:0] tx_st_data_loop;
   //     reg                             tx_st_sop_loop   ;
   //     reg                             tx_st_eop_loop   ;
   //     reg                             tx_st_empty_loop ;
   //     reg                             tx_st_valid_loop  ;
   //     reg [port_width_be_hwtcl-1:0]   tx_st_data_r;
   //     reg                             tx_st_sop_r   ;
   //     reg                             tx_st_eop_r   ;
   //     reg                             tx_st_empty_r ;
   //     reg                             tx_st_valid_r  ;
   //
   //     always @(posedge pld_clk or posedge reset_status_sync_pldclk) begin
   //        if (reset_status_sync_pldclk == 1'b1) begin
   //           tx_st_data_loop  <= ZEROS[port_width_data_hwtcl-1:0];
   //           tx_st_sop_loop   <= 1'b0;
   //           tx_st_eop_loop   <= 1'b0;
   //           tx_st_empty_loop <= 1'b0;
   //           tx_st_valid_loop <= 1'b0;
   //           tx_st_data_r     <= ZEROS[port_width_data_hwtcl-1:0] ;
   //           tx_st_sop_r      <= 1'b0;
   //           tx_st_eop_r      <= 1'b0;
   //           tx_st_empty_r    <= 1'b0;
   //           tx_st_valid_r    <= 1'b0;
   //        end
   //        else begin
   //           tx_st_data_loop    <= rx_st_data   ;
   //           tx_st_sop_loop     <= rx_st_sop[0] ;
   //           tx_st_eop_loop     <= rx_st_eop[0] ;
   //           tx_st_empty_loop   <= (ast_width_hwtcl=="Avalon-ST 128-bit")?rx_st_empty[0]:1'b0 ;
   //           tx_st_valid_loop   <= rx_st_valid[0]  ;
   //
   //           tx_st_data_r       <= tx_st_data_loop ;
   //           tx_st_sop_r        <= tx_st_sop_loop     ;
   //           tx_st_eop_r        <= tx_st_eop_loop     ;
   //           tx_st_empty_r      <= tx_st_empty_loop   ;
   //           tx_st_valid_r      <= tx_st_valid_loop   ;
   //        end
   //     end
   //
   //     assign tx_st_data         = tx_st_data_r   ;
   //     assign tx_st_sop[0]       = tx_st_sop_r    ;
   //     assign tx_st_eop[0]       = tx_st_eop_r    ;
   //     assign tx_st_empty_int[0] = tx_st_empty_r  ;
   //     assign tx_st_valid[0]     = tx_st_valid_r  ;
   //
   //     assign rx_st_ready        = 1'b1;
   //     assign rx_st_mask         = 1'b0;
   //synthesis read_comments_as_HDL off
   end

   else if ( (IS_ROOTPORT == 1) && (gen123_lane_rate_mode_hwtcl=="Gen3 (8.0 Gbps)") ) begin
      assign  aer_msi_num   = ZEROS[4 : 0]  ;
      assign  app_int_sts_vec_int   = 1'b0  ;
      assign  app_msi_num   = ZEROS[4 : 0]  ;
      assign  app_msi_req   = 1'b0          ;
      assign  app_msi_tc    = ZEROS[2 : 0]  ;
      assign  pex_msi_num   = ZEROS[4 : 0]  ;
      assign  lmi_addr_int  = ZEROS[11 : 0] ;
      assign  lmi_din       = ZEROS[31 : 0] ;
      assign  lmi_rden      = 1'b0          ;
      assign  lmi_wren      = 1'b0          ;
      assign  cpl_err       = ZEROS[6:0]    ;
      assign  cpl_pending_int = 1'b0        ;
      assign  pm_data       = ZEROS[9:0]    ;

   //////////////// SIMULATION-ONLY CONTENTS
   //synthesis translate_off
   //delay reset for RP
      reg srstn_r, srstn_rr;
      initial begin
         srstn_r  = 1'b0;
         srstn_rr = 1'b0;
      end

      wire [3:0] swdn_out = int_status;
      wire       driver_rp_dummy_out;
      wire [127:0] tx_st_data_int;

      always @(posedge pld_clk or posedge reset_status_sync_pldclk) begin
         if (reset_status_sync_pldclk == 1'b1) begin
             srstn_r <= 0;
             srstn_rr <= 0;
         end
         else begin
             srstn_r <= 1;
             srstn_rr <= srstn_r;
         end
      end

      altpcietb_bfm_vc_intf_ast  # (
        .AVALON_ST_256       ((ast_width_hwtcl=="Avalon-ST 256-bit")?1:0),
        .AVALON_ST_128       ((ast_width_hwtcl=="Avalon-ST 128-bit")?1:0),
        .ECRC_FORWARD_CHECK  (0),
        .ECRC_FORWARD_GENER  (0),
        .VC_NUM              (0)
          ) app_vc0 (
        .cfg_io_bas    (cfg_io_bas),
        .cfg_np_bas    (cfg_np_bas),
        .cfg_pr_bas    (cfg_pr_bas),
        .clk_in        (coreclkout_hip),
        .rstn          (srstn_rr),
        .rx_mask       (rx_st_mask),
        .rx_st_be      ((ast_width_hwtcl=="Avalon-ST 128-bit")?rx_st_be  :{8'h0,rx_st_be}),
        .rx_st_data    (rx_st_data),
        .rx_st_empty   (rx_st_empty),
        .rx_st_eop     (rx_st_eop),
        .rx_st_ready   (rx_st_ready),
        .rx_st_sop     (rx_st_sop),
        .rx_st_valid   (rx_st_valid[0]),
        .tx_cred       (36'hFFFFFFFFF),
        .tx_fifo_empty (tx_fifo_empty),
        .tx_st_data    (tx_st_data),
        .tx_st_empty   (tx_st_empty),
        .tx_st_eop     (tx_st_eop),
        .tx_st_ready   (tx_st_ready),
        .tx_st_sop     (tx_st_sop),
        .tx_st_valid   (tx_st_valid[0])
      );

      assign tx_st_err     = (multiple_packets_per_cycle_hwtcl==1)?2'b00:1'b0;

      altpcietb_bfm_driver_rp # (
         .TEST_LEVEL(1),
         .APPS_TYPE_HWTCL(apps_type_hwtcl)
         ) drvr (
         .INTA (swdn_out[0]),
         .INTB (swdn_out[1]),
         .INTC (swdn_out[2]),
         .INTD (swdn_out[3]),
         .clk_in (sim_pipe_pclk_out),
         .dummy_out (driver_rp_dummy_out),
         .rstn (srstn_rr));

   //////////////// END SIMULATION-ONLY CONTENTS
   //synthesis translate_on
   // The section bellow is for synthesis only and is not used for simulation
   // The RP DUT is using basic loopback rx AST --> AST
   //synthesis read_comments_as_HDL on
   //     reg [port_width_data_hwtcl-1:0] tx_st_data_loop;
   //     reg                             tx_st_sop_loop   ;
   //     reg                             tx_st_eop_loop   ;
   //     reg                             tx_st_empty_loop ;
   //     reg                             tx_st_valid_loop  ;
   //     reg [port_width_be_hwtcl-1:0]   tx_st_data_r;
   //     reg                             tx_st_sop_r   ;
   //     reg                             tx_st_eop_r   ;
   //     reg                             tx_st_empty_r ;
   //     reg                             tx_st_valid_r  ;
   //
   //     always @(posedge pld_clk or posedge reset_status_sync_pldclk) begin
   //        if (reset_status_sync_pldclk == 1'b1) begin
   //           tx_st_data_loop  <= ZEROS[port_width_data_hwtcl-1:0];
   //           tx_st_sop_loop   <= 1'b0;
   //           tx_st_eop_loop   <= 1'b0;
   //           tx_st_empty_loop <= 1'b0;
   //           tx_st_valid_loop <= 1'b0;
   //           tx_st_data_r     <= ZEROS[port_width_data_hwtcl-1:0] ;
   //           tx_st_sop_r      <= 1'b0;
   //           tx_st_eop_r      <= 1'b0;
   //           tx_st_empty_r    <= 1'b0;
   //           tx_st_valid_r    <= 1'b0;
   //        end
   //        else begin
   //           tx_st_data_loop    <= rx_st_data   ;
   //           tx_st_sop_loop     <= rx_st_sop[0] ;
   //           tx_st_eop_loop     <= rx_st_eop[0] ;
   //           tx_st_empty_loop   <= (ast_width_hwtcl=="Avalon-ST 128-bit")?rx_st_empty[0]:1'b0 ;
   //           tx_st_valid_loop   <= rx_st_valid[0]  ;
   //
   //           tx_st_data_r       <= tx_st_data_loop ;
   //           tx_st_sop_r        <= tx_st_sop_loop     ;
   //           tx_st_eop_r        <= tx_st_eop_loop     ;
   //           tx_st_empty_r      <= tx_st_empty_loop   ;
   //           tx_st_valid_r      <= tx_st_valid_loop   ;
   //        end
   //     end
   //
   //     assign tx_st_data         = tx_st_data_r   ;
   //     assign tx_st_sop[0]       = tx_st_sop_r    ;
   //     assign tx_st_eop[0]       = tx_st_eop_r    ;
   //     assign tx_st_empty_int[0] = tx_st_empty_r  ;
   //     assign tx_st_valid[0]     = tx_st_valid_r  ;
   //
   //     assign rx_st_ready        = 1'b1;
   //     assign rx_st_mask         = 1'b0;
   //synthesis read_comments_as_HDL off
   end
end
endgenerate


// Power management
assign pm_auxpwr     =1'b0;
assign pme_to_cr     =1'b0;
assign pm_event      =1'b0;
assign pm_event_func =3'b0;
// Hot plug
assign hpg_ctrler = 5'h0;

assign pld_core_ready =  serdes_pll_locked;

   //synthesis translate_off
   assign pld_clk = coreclkout_hip;
   //synthesis translate_on

   //synthesis read_comments_as_HDL on
   //global u_global_buffer_coreclkout (.in(coreclkout_hip), .out(pld_clk));
   //synthesis read_comments_as_HDL off

   assign pld_clk_hip   = coreclkout_hip;

endmodule

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpcietb_bfm_rp_vc_driver (coreclkout_hip, sim_pipe_pclk_out, rstn,
                                  rx_mask,  rx_st_be,  rx_st_sop, rx_st_eop, rx_st_empty, rx_st_data, rx_st_valid, rx_st_ready,
                                  tx_cred, tx_st_ready, tx_st_sop, tx_st_eop, tx_st_empty, tx_st_valid, tx_st_data, tx_fifo_empty,
                                  cfg_io_bas, cfg_np_bas, cfg_pr_bas, ltssmstate, reset_status_hip, INTA, INTB, INTC, INTD );
   parameter ast_width_hwtcl                  = "Avalon-ST 64-bit";
   parameter apps_type_hwtcl                  = 2;
   input            coreclkout_hip;
   input            sim_pipe_pclk_out;
   input            rstn;
   output           rx_mask;
   input[35:0]      tx_cred;
   input[19:0]      cfg_io_bas;
   input[11:0]      cfg_np_bas;
   input[43:0]      cfg_pr_bas;
   input            rx_st_sop;
   input            rx_st_valid;
   output           rx_st_ready;
   input            rx_st_eop;
   input            rx_st_empty;
   input[127:0]     rx_st_data;
   input[15:0]      rx_st_be;
   input            tx_st_ready;
   output           tx_st_sop;
   output           tx_st_eop;
   output           tx_st_empty;
   output           tx_st_valid;
   output[127:0]    tx_st_data;
   input            tx_fifo_empty;
   input [4:0]      ltssmstate;
   input            reset_status_hip;
   input            INTA;
   input            INTB;
   input            INTC;
   input            INTD;

   wire       bfm_log_common_dummy_out;
   wire       driver_rp_dummy_out;
   wire       bfm_req_intf_common_dummy_out;
   wire       bfm_shmem_common_dummy_out;
   wire       ltssm_dummy_out;

   altpcietb_bfm_log_common bfm_log_common ( .dummy_out (bfm_log_common_dummy_out));
   altpcietb_bfm_req_intf_common bfm_req_intf_common ( .dummy_out (bfm_req_intf_common_dummy_out));
   altpcietb_bfm_shmem_common bfm_shmem_common ( .dummy_out (bfm_shmem_common_dummy_out));
   altpcietb_ltssm_mon ltssm_mon ( .dummy_out (ltssm_dummy_out), .ep_ltssm (5'h0), .rp_clk (sim_pipe_pclk_out), .rp_ltssm (ltssmstate), .rstn (reset_status_hip));

   altpcietb_bfm_vc_intf_ast  # (
        .AVALON_ST_128       ((ast_width_hwtcl=="Avalon-ST 128-bit")?1:0),
        .ECRC_FORWARD_CHECK  (0),
        .ECRC_FORWARD_GENER  (0),
        .VC_NUM              (0)
          ) app_vc0 (
        .cfg_io_bas    (cfg_io_bas),
        .cfg_np_bas    (cfg_np_bas),
        .cfg_pr_bas    (cfg_pr_bas),
        .clk_in        (coreclkout_hip),
        .rstn          (rstn),
        .rx_mask       (rx_mask),
        .rx_st_be      ((ast_width_hwtcl=="Avalon-ST 128-bit")?rx_st_be  :{8'h0,rx_st_be}),
        .rx_st_data    (rx_st_data),
        .rx_st_empty   (rx_st_empty),
        .rx_st_eop     (rx_st_eop),
        .rx_st_ready   (rx_st_ready),
        .rx_st_sop     (rx_st_sop),
        .rx_st_valid   (rx_st_valid),
        .tx_cred       (tx_cred),
        .tx_fifo_empty (tx_fifo_empty),
        .tx_st_data    (tx_st_data),
        .tx_st_empty   (tx_st_empty),
        .tx_st_eop     (tx_st_eop),
        .tx_st_ready   (tx_st_ready),
        .tx_st_sop     (tx_st_sop),
        .tx_st_valid   (tx_st_valid)
      );

      altpcietb_bfm_driver_rp # (
         .TEST_LEVEL(1)
         ) drvr (
         .INTA (INTA),
         .INTB (INTB),
         .INTC (INTC),
         .INTD (INTD),
         .clk_in (sim_pipe_pclk_out),
         .dummy_out (driver_rp_dummy_out),
         .rstn (rstn));

endmodule
