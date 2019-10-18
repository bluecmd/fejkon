`define MGMT_CLK tb.tb_inst_clk_bfm
`define MGMT_RESET_N tb.tb_inst_reset_bfm

module top_tb();
  tb_tb tb();

  import verbosity_pkg::*;

  initial
  begin
    set_verbosity(VERBOSITY_INFO);
    wait(`MGMT_RESET_N.reset == 1);
    $sformat(message, "%m: Test Passed");
    print(VERBOSITY_INFO, message);
    $stop();
  end

endmodule
