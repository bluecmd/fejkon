`define MGMT_CLK tb.tb_inst_clk_bfm
`define MGMT_RESET_N tb.tb_inst_reset_bfm
`define PHY0_RESET_N tb.tb_inst.phy0_rst_src
`define PHYA_RESET_N tb.tb_inst.phya_rst_src
`define PHYB_RESET_N tb.tb_inst.phyb_rst_src
`define PHY1_RESET_N tb.tb_inst.phy1_rst_src
`define XCVR0 tb.tb_inst.xcvr0
`define PHY0 tb.tb_inst.xcvr0.phy
`define PHY1 tb.tb_inst.xcvr1.phy
`define TX0 tb.tb_inst_usertx0_bfm
`define PMA0_CLK tb.tb_inst.xcvr0.phy.fc_phy_inst.genblk1.S5.transceiver_core.pll_out_clk
`define FRAMER0 tb.tb_inst.framer0
`define FRAMER1 tb.tb_inst.framer1
`define FRAMERA tb.tb_inst.framera
`define FRAMERB tb.tb_inst.framerb

`timescale 1ps / 1fs

module top_tb;

  tb_tb tb();

  import verbosity_pkg::*;

  initial begin
    set_verbosity(VERBOSITY_INFO);
    wait(`FRAMER0.state == fc::STATE_AC);
    wait(`FRAMER1.state == fc::STATE_AC);
    wait(`FRAMERA.state == fc::STATE_AC);
    wait(`FRAMERB.state == fc::STATE_AC);
    $sformat(message, "%m: Test passed");
    print(VERBOSITY_INFO, message);
    // Run one 10 us more for more wave data
    #10000000
    // Keep at least one assert in here for the simulation script
    assert(1==1);
    $stop();
  end

  initial begin
    wait(`TX0.reset == 0);
    `TX0.init();
    `TX0.set_response_timeout(0);
    `TX0.set_transaction_sop(1);
    `TX0.set_transaction_data(fc::SOFI3);
    `TX0.push_transaction();
    `TX0.set_transaction_sop(0);
    for (int i = 1; i < 10; i++) begin
      `TX0.set_transaction_data(32'hf00f0000 + i);
      `TX0.push_transaction();
    end
    `TX0.set_transaction_eop(1);
    `TX0.set_transaction_data(fc::EOFT_N);
    `TX0.push_transaction();
    wait(`FRAMER1.state == fc::STATE_AC);
    `TX0.set_transaction_sop(1);
    `TX0.set_transaction_eop(1);
    `TX0.set_transaction_data(fc::R_RDY);
    `TX0.push_transaction();
  end

  initial begin
    wait(`MGMT_RESET_N.reset == 1);
    $sformat(message, "%m: Mgmt reset released");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY0_RESET_N.reset == 1);
    $sformat(message, "%m: PHY0 reset released");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHYA_RESET_N.reset == 1);
    $sformat(message, "%m: PHYA reset released");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHYB_RESET_N.reset == 1);
    $sformat(message, "%m: PHYB reset released");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY1_RESET_N.reset == 1);
    $sformat(message, "%m: PHY1 reset released");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY0.tx_ready == 1);
    $sformat(message, "%m: TX0 ready");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY0.rx_ready == 1);
    $sformat(message, "%m: RX0 ready");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY1.tx_ready == 1);
    $sformat(message, "%m: TX1 ready");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY1.rx_ready == 1);
    $sformat(message, "%m: RX1 ready");
    print(VERBOSITY_INFO, message);
  end

  // Serial line XCVR decoder
  wire ref_8g_clk;
  reg [9:0] symbol_r;
  reg [9:0] symbol_rr;
  int bit_cntr = 0;
  string symbol;

  assign ref_8g_clk = `PMA0_CLK & `PHY0.pll_locked;

  // Used to manually reference tick/tocks on the serial XCVR lines
  // Double-edge clocked
  always_ff @(edge ref_8g_clk) begin
    symbol_r[0] <= `PHY0.tx_serial_data;
    symbol_r[9:1] <= symbol_r[8:0];
    bit_cntr <= bit_cntr + 1;
    // Calculated to match simuation model latency
    // Simply look for the K28.5 in RD- (0x0FA) and match
    if (bit_cntr == 9) begin
      bit_cntr <= 0;
      symbol_rr <= symbol_r;
      case (symbol_r)
`include "tb_8b10b.sv.inc"
      default : begin
        symbol <= "<Unknown>";
        $error("8B/10B decode error");
      end
      endcase
    end
  end

  initial begin
    wait(`PHY0.rx_ready == 1);
    // K28.5 should only ever occur with positive running disparity in an EOF
    wait(symbol == "K28.5 +");
    $error("Found K28.5 +, investigate");
  end

endmodule
