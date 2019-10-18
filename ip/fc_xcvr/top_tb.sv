`define MGMT_CLK tb.tb_inst_clk_bfm
`define MGMT_RESET_N tb.tb_inst_reset_bfm
`define XCVR tb.tb_inst.fc_8g_xcvr_0
`define PHY tb.tb_inst.fc_8g_xcvr_0.phy

module top_tb();
  tb_tb tb();

  import verbosity_pkg::*;

  initial
  begin
    set_verbosity(VERBOSITY_INFO);
    wait(`PHY.rx_syncstatus != 0);
    $sformat(message, "%m: Test passed");
    print(VERBOSITY_INFO, message);
    $stop();
  end

  initial
  begin
    wait(`MGMT_RESET_N.reset == 1);
    $sformat(message, "%m: Reset released");
    print(VERBOSITY_INFO, message);
  end

  initial
  begin
    wait(`PHY.tx_ready == 1);
    $sformat(message, "%m: TX ready");
    print(VERBOSITY_INFO, message);
  end

  initial
  begin
    wait(`PHY.rx_ready == 1);
    $sformat(message, "%m: RX ready");
    print(VERBOSITY_INFO, message);
  end
endmodule
