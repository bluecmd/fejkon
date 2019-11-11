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
// turn off superfluous verilog processor warnings
// altera message_level Level1
// altera message_off 10034 10035 10036 10037 10230 10240 10030
//-----------------------------------------------------------------------------
// Title         : PCI Express Reference Design Example Application
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcierd_tl_cfg_sample.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description :
// This module extracts the configuration space register information from
// the multiplexed tl_cfg_ctl interface from the Hard IP core.  And synchronizes
// this info, as well as the tl_cfg_sts info to the Application clock.
//-----------------------------------------------------------------------------


module altpcierd_tl_cfg_sample #(
   parameter HIP_SV          = 0
   )(

  input                pld_clk,           // 125Mhz or 250Mhz
  input                rstn,
  input       [  3: 0] tl_cfg_add,        // from core_clk domain
  input       [ 31: 0] tl_cfg_ctl,        // from core_clk domain
  input                tl_cfg_ctl_wr,     // from core_clk domain
  input       [ 52: 0] tl_cfg_sts,        // from core_clk domain
  input                tl_cfg_sts_wr,     // from core_clk domain
  output reg  [ 12: 0] cfg_busdev,        // synced to pld_clk
  output reg  [ 31: 0] cfg_devcsr,        // synced to pld_clk
  output reg  [ 31: 0] cfg_linkcsr,       // synced to pld_clk
  output reg  [31:0]   cfg_prmcsr,

  output reg [19:0] cfg_io_bas,
  output reg [19:0] cfg_io_lim,
  output reg [11:0] cfg_np_bas,
  output reg [11:0] cfg_np_lim,
  output reg [43:0] cfg_pr_bas,
  output reg [43:0] cfg_pr_lim,

  output reg [23:0]    cfg_tcvcmap,
  output reg [15:0]    cfg_msicsr

);


  reg              tl_cfg_sts_wr_r;
  reg              tl_cfg_sts_wr_rr;
  reg              tl_cfg_sts_wr_rrr;
  
  
  reg  [3:0]        cfgctl_add_reg;
  reg  [3:0]        cfgctl_add_reg2;
  reg  [31:0]       cfgctl_data_reg;
  
  reg   [31:0]      captured_cfg_data_reg;     
  reg   [3:0]       captured_cfg_addr_reg;     
  reg               cfgctl_addr_change;        
  reg               cfgctl_addr_change2;       
  reg               cfgctl_addr_strobe;   

//Synchronise to pld side
always @(posedge pld_clk or negedge rstn) begin
    if (rstn == 0) begin
       cfgctl_add_reg  <= 4'h0;     
       cfgctl_data_reg <= 32'h0;    
    end
    else  begin
        cfgctl_add_reg  <= tl_cfg_add;
        cfgctl_add_reg2  <= cfgctl_add_reg;
        cfgctl_data_reg <= tl_cfg_ctl;
    end
end
 
//Synchronise to pld side
always @(posedge pld_clk or negedge rstn) begin
    if (rstn == 0) begin
        tl_cfg_sts_wr_r   <= 0;
        tl_cfg_sts_wr_rr  <= 0;
        tl_cfg_sts_wr_rrr <= 0;
    end
    else  begin
        tl_cfg_sts_wr_r   <= tl_cfg_sts_wr;
        tl_cfg_sts_wr_rr  <= tl_cfg_sts_wr_r;
        tl_cfg_sts_wr_rrr <= tl_cfg_sts_wr_rr;
    end
end

//Configuration Demux logic
always @(posedge pld_clk or negedge rstn) begin
   if (rstn == 0) begin
       cfg_busdev  <= 16'h0;
       cfg_devcsr  <= 32'h0;
       cfg_linkcsr <= 32'h0;
       cfg_msicsr  <= 16'h0;
       cfg_tcvcmap <= 24'h0;
       cfg_prmcsr  <= 32'h0;
       cfg_io_bas  <= 20'h0;
       cfg_io_lim  <= 20'h0;
       cfg_np_bas  <= 12'h0;
       cfg_np_lim  <= 12'h0;
       cfg_pr_bas  <= 44'h0;
       cfg_pr_lim  <= 44'h0;
   end
   else  begin
       cfg_prmcsr[26:25] <= 2'h0;
       cfg_prmcsr[23:16] <= 8'h0;
       cfg_devcsr[31:20] <= 12'h0;
       // tl_cfg_sts sampling
       if ((tl_cfg_sts_wr_rrr != tl_cfg_sts_wr_rr) || (HIP_SV==1)) begin
           cfg_devcsr[19 : 16] <= tl_cfg_sts[52 : 49];
           cfg_linkcsr[31:16]  <= tl_cfg_sts[46 : 31];
           cfg_prmcsr[31:27]   <= tl_cfg_sts[29:25];
           cfg_prmcsr[24]      <= tl_cfg_sts[24];
       end

       // tl_cfg_ctl_sampling
           if (captured_cfg_addr_reg==4'h0)  cfg_devcsr[15:0]  <= captured_cfg_data_reg[31:16];
           if (captured_cfg_addr_reg==4'h2)  cfg_linkcsr[15:0] <= captured_cfg_data_reg[31:16];
           if (captured_cfg_addr_reg==4'h3)  cfg_prmcsr[15:0]  <= captured_cfg_data_reg[23:8];
           if (captured_cfg_addr_reg==4'h5)  cfg_io_bas        <= captured_cfg_data_reg[19:0];
           if (captured_cfg_addr_reg==4'h6)  cfg_io_lim        <= captured_cfg_data_reg[19:0];
           if (captured_cfg_addr_reg==4'h7)  cfg_np_bas        <= captured_cfg_data_reg[23:12];
           if (captured_cfg_addr_reg==4'h7)  cfg_np_lim        <= captured_cfg_data_reg[11:0];
           if (captured_cfg_addr_reg==4'h8)  cfg_pr_bas[31:0]  <= captured_cfg_data_reg[31:0];
           if (captured_cfg_addr_reg==4'h9)  cfg_pr_bas[43:32] <= captured_cfg_data_reg[11:0];
           if (captured_cfg_addr_reg==4'hA)  cfg_pr_lim[31:0]  <= captured_cfg_data_reg[31:0];
           if (captured_cfg_addr_reg==4'hB)  cfg_pr_lim[43:32] <= captured_cfg_data_reg[11:0];
           if (captured_cfg_addr_reg==4'hD)  cfg_msicsr[15:0]  <= captured_cfg_data_reg[15:0];
           if (captured_cfg_addr_reg==4'hE)  cfg_tcvcmap[23:0] <= captured_cfg_data_reg[23:0];
           if (captured_cfg_addr_reg==4'hF)  cfg_busdev        <= captured_cfg_data_reg[12:0];
   end
end

/// sample the Cfg CTL interface a few clocks after transition
// detect the address transition
 always @(posedge pld_clk)
   begin
     cfgctl_addr_change <=   cfgctl_add_reg[3:0] != cfgctl_add_reg2[3:0];     // detect address change
     cfgctl_addr_change2 <=  cfgctl_addr_change;                      // delay two clock and use as strobe to sample the input 32-bit data
     cfgctl_addr_strobe  <=  cfgctl_addr_change2;
   end

// captured cfg ctl addr/data bus with the strobe
 always @(posedge pld_clk)
   if(cfgctl_addr_strobe)
     begin
        captured_cfg_addr_reg[3:0] <= cfgctl_add_reg[3:0];
        captured_cfg_data_reg[31:0] <= cfgctl_data_reg[31:0];
     end
 
endmodule
