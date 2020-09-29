`timescale 1 ps / 1 ps
module fc_8g_xcvr (
    input  wire [35:0]  avtx_data,                //                   avtx.data
    input  wire         avtx_valid,               //                       .valid
    output wire         avtx_ready,               //                       .ready
    output wire [35:0]  avrx_data,                //                   avrx.data
    output wire         avrx_valid,               //                       .valid
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
    output wire  [91:0] reconfig_from_xcvr,       //     reconfig_from_xcvr.
    output wire         aligned                   //                aligned.aligned
  );

  wire         pll_locked;

  logic [3:0]  rx_le_datak;
  logic [31:0] rx_le_data;
  logic [3:0]  rx_le_runningdisp;
  logic [3:0]  rx_be_datak_r;
  logic [31:0] rx_be_data;
  logic [31:0] rx_be_data_r;
  logic [3:0]  rx_be_datak;
  logic [3:0]  rx_be_runningdisp;
  wire  [3:0]  rx_disperr;
  wire  [3:0]  rx_errdetect;
  wire  [3:0]  rx_patterndetect;
  wire  [3:0]  rx_syncstatus;

  wire         tx_xcvr_ready_raw;
  logic        tx_xcvr_ready;
  logic [3:0]  tx_le_datak;
  logic [31:0] tx_le_data;
  wire  [31:0] tx_be_data;
  wire  [3:0]  tx_be_datak;
  logic [3:0]  tx_be_datak_r;

  // Alignment registers
  logic [31:0] rx_le_data_raw;
  logic [31:0] rx_le_data_raw_r;
  logic [3:0]  rx_le_datak_raw;
  logic [3:0]  rx_le_datak_raw_r;
  logic [3:0]  rx_le_runningdisp_raw;
  logic [3:0]  rx_le_runningdisp_raw_r;

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
    .tx_ready(tx_xcvr_ready_raw),              //                    tx_ready.export
    .rx_ready(),                               //                    rx_ready.export
    .pll_ref_clk(phy_clk) ,                    //                 pll_ref_clk.clk
    .tx_serial_data(td_p),                     //              tx_serial_data.export
    .pll_locked(pll_locked),                   //                  pll_locked.export
    .rx_serial_data(rd_p),                     //              rx_serial_data.export
    .rx_runningdisp(rx_le_runningdisp_raw),    //              rx_runningdisp.export
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
    .rx_parallel_data(rx_le_data_raw),         //            rx_parallel_data.data
    .rx_datak(rx_le_datak_raw),                //                    rx_datak.data
    .reconfig_from_xcvr(reconfig_from_xcvr),   //          reconfig_from_xcvr.reconfig_from_xcvr
    .reconfig_to_xcvr(reconfig_to_xcvr)        //            reconfig_to_xcvr.reconfig_to_xcvr
  );

  logic [3:0] saved_patterndetect = 0;
  assign status_word = {15'b0, pll_locked, rx_disperr, rx_errdetect, saved_patterndetect, rx_syncstatus};

  logic [31:0] status_word_mgmt_cdc1 = 0;
  logic [31:0] status_word_mgmt_cdc2 = 0;
  logic [31:0] status_word_mgmt_xfered = 0;

  always_ff @(posedge mgmt_clk) begin
    status_word_mgmt_cdc1 <= status_word;
    status_word_mgmt_cdc2 <= status_word_mgmt_cdc1;
    status_word_mgmt_xfered <= status_word_mgmt_cdc2;
  end

  // Align
  // TODO: Test this in testbench
  always_ff @(posedge rx_clk) begin
    rx_le_data_raw_r <= rx_le_data_raw;
    rx_le_datak_raw_r <= rx_le_datak_raw;
    rx_le_runningdisp_raw_r <= rx_le_runningdisp_raw;
    if (saved_patterndetect == 4'b1000) begin
      rx_le_data <= {rx_le_data_raw[23:0], rx_le_data_raw_r[31:24]};
      rx_le_datak <= {rx_le_datak_raw[2:0], rx_le_datak_raw_r[3]};
      rx_le_runningdisp <= {rx_le_runningdisp_raw[2:0], rx_le_runningdisp_raw_r[3]};
    end else if (saved_patterndetect == 4'b0100) begin
      rx_le_data <= {rx_le_data_raw[15:0], rx_le_data_raw_r[31:16]};
      rx_le_datak <= {rx_le_datak_raw[1:0], rx_le_datak_raw_r[3:2]};
      rx_le_runningdisp <= {rx_le_runningdisp_raw[1:0], rx_le_runningdisp_raw_r[3:2]};
    end else if (saved_patterndetect == 4'b0010) begin
      rx_le_data <= {rx_le_data_raw[7:0], rx_le_data_raw_r[31:8]};
      rx_le_datak <= {rx_le_datak_raw[0], rx_le_datak_raw_r[3:1]};
      rx_le_runningdisp <= {rx_le_runningdisp_raw[0], rx_le_runningdisp_raw_r[3:1]};
    end else if (saved_patterndetect == 4'b0001) begin
      rx_le_data <= rx_le_data_raw_r;
      rx_le_datak <= rx_le_datak_raw_r;
      rx_le_runningdisp <= rx_le_runningdisp_raw_r;
    end
  end

  logic is_aligned_r0;
  logic is_aligned_r1;
  logic is_aligned_r2;
  logic is_aligned;
  assign is_aligned_r0 =
    (rx_syncstatus == 4'b1111) &&
    (saved_patterndetect == 4'b0100 || saved_patterndetect == 4'b0001 ||
     saved_patterndetect == 4'b1000 || saved_patterndetect == 4'b0010);

  always_ff @(posedge rx_clk) begin
    // rx_patterndetect is only valid for K28.5 comma. We need
    // to store the pattern detect outcome when we see an aligned K28.5
    if (rx_syncstatus == 4'b1111 &&
      (rx_patterndetect == 4'b0100 || rx_patterndetect == 4'b0001 ||
       rx_patterndetect == 4'b1000 || rx_patterndetect == 4'b0010)) begin
      saved_patterndetect <= rx_patterndetect;
    end
  end

  always_ff @(posedge rx_clk) begin
    // Match latency of rx_be_data*
    is_aligned_r1 <= is_aligned_r0; // Latency from alignment     (aligned with rx_le_data_raw_r)
    is_aligned_r2 <= is_aligned_r1; // Latency from alignment     (aligned with rx_le_data)
    is_aligned <= is_aligned_r2;    // Latency from endian switch (aligned with rx_be_data)
  end

  // This is best-effort to mgmt clock domain, do not depend on accuracy
  int tx_primitive_cntrs [fc::PRIM_MAX];
  int rx_primitive_cntrs [fc::PRIM_MAX];

  fc::primitives_t tx_prim = fc::PRIM_UNKNOWN, rx_prim = fc::PRIM_UNKNOWN;

  // Signal used for trigging debug traces
  (* noprune *) logic rx_unknown_prim;
  logic [31:0] rx_last_unknown;
  always_ff @(posedge rx_clk) begin
    // Sample unknown primitives for debugging
    if (tx_be_datak_r == 4'b1000 && is_aligned) begin
      rx_unknown_prim <= rx_prim == fc::PRIM_UNKNOWN;
      if (rx_prim == fc::PRIM_UNKNOWN)
        rx_last_unknown <= rx_be_data_r;
    end
  end

  always_ff @(posedge rx_clk) begin
    rx_be_datak_r <= rx_be_datak;
    rx_be_data_r <= rx_be_data;
    if (rx_be_datak == 4'b1000)
      rx_prim <= fc::map_primitive(rx_be_data);
    if (rx_be_datak_r == 4'b1000 && is_aligned)
      rx_primitive_cntrs[rx_prim]++;
  end

  always_ff @(posedge tx_clk) begin
    tx_be_datak_r <= tx_be_datak;
    if (tx_be_datak == 4'b1000)
      tx_prim <= fc::map_primitive(tx_be_data);
    if (tx_be_datak_r == 4'b1000)
      tx_primitive_cntrs[tx_prim]++;
  end

  logic [31:0] reg_readdata;
  assign mm_waitrequest = mm_address[9] ? mgmt_waitrequest : 1'b0;
  assign mm_readdata    = mm_address[9] ? mgmt_readdata : reg_readdata;
  assign mgmt_read      = mm_address[9] ? mm_read  : 1'b0;
  assign mgmt_write     = mm_address[9] ? mm_write : 1'b0;
  assign mgmt_writedata = mm_address[9] ? mm_writedata : 32'b0;
  assign mgmt_address   = mm_address[9] ? mm_address[8:0] : 9'b0;

  logic [4:0] prim_addr;
  assign prim_addr = mm_address[4:0];

  logic valid_prim_addr;
  assign valid_prim_addr = fc::primitives_t'(prim_addr) < fc::PRIM_MAX;

  always_comb begin
    case (mm_address[8:5])
      4'h0: begin
        case (mm_address[4:0])
          5'h0: reg_readdata = status_word_mgmt_xfered;
          5'h1: reg_readdata = rx_last_unknown;
          default: reg_readdata = 32'hffffffff;
        endcase
      end
      // TODO: This is very much best-effort and quite hacky
      // No CDC for tx/rx clk -> mgmt as this is meant only for debugging
      4'h1: reg_readdata = valid_prim_addr ? rx_primitive_cntrs[prim_addr] : 32'hffffffff;
      4'h2: reg_readdata = valid_prim_addr ? tx_primitive_cntrs[prim_addr] : 32'hffffffff;
      default: reg_readdata = 32'hffffffff;
    endcase
  end

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

  always_ff @(posedge tx_clk) begin
    tx_le_data[7:0]   <= tx_be_data[31:24];
    tx_le_data[15:8]  <= tx_be_data[23:16];
    tx_le_data[23:16] <= tx_be_data[15:8];
    tx_le_data[31:24] <= tx_be_data[7:0];
    tx_le_datak <= {tx_be_datak[0], tx_be_datak[1], tx_be_datak[2], tx_be_datak[3]};
  end

  always_ff @(posedge rx_clk) begin
    rx_be_data[7:0]   <= rx_le_data[31:24];
    rx_be_data[15:8]  <= rx_le_data[23:16];
    rx_be_data[23:16] <= rx_le_data[15:8];
    rx_be_data[31:24] <= rx_le_data[7:0];
    rx_be_datak <= {rx_le_datak[0], rx_le_datak[1], rx_le_datak[2], rx_le_datak[3]};
    rx_be_runningdisp <= {
      rx_le_runningdisp[0],
      rx_le_runningdisp[1],
      rx_le_runningdisp[2],
      rx_le_runningdisp[3]
    };
  end

  // The TX stream is required to always have a valid frame, if it does not
  // treat it as a catastrophic failure and kill the link
  assign tx_be_data  = avtx_valid ? avtx_data[31:0] : fc::NOS;
  assign tx_be_datak = avtx_valid ? avtx_data[35:32] : 4'b1000;

  always_ff @(posedge mgmt_clk) begin
    tx_xcvr_ready <= tx_xcvr_ready_raw;
  end

  logic tx_xcvr_ready_cdc1 = 1'b0;
  logic tx_xcvr_ready_cdc2 = 1'b0;
  logic tx_xcvr_ready_xfered = 1'b0;

  always_ff @(posedge tx_clk) begin
    tx_xcvr_ready_cdc1 <= tx_xcvr_ready;
    tx_xcvr_ready_cdc2 <= tx_xcvr_ready_cdc1;
    tx_xcvr_ready_xfered <= tx_xcvr_ready_cdc2;
  end

  assign avtx_ready = tx_xcvr_ready_xfered;
  assign avrx_valid = is_aligned;

  assign avrx_data = {rx_be_datak, rx_be_data};

  assign aligned = is_aligned;

endmodule
