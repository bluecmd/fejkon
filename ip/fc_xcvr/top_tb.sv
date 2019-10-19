`define MGMT_CLK tb.tb_inst_clk_bfm
`define MGMT_RESET_N tb.tb_inst_reset_bfm
`define XCVR tb.tb_inst.fc_8g_xcvr_0
`define PHY tb.tb_inst.fc_8g_xcvr_0.phy

`timescale 1ps / 1fs

module top_tb();

  tb_tb tb();

  import verbosity_pkg::*;

  initial begin
    set_verbosity(VERBOSITY_INFO);
    wait(`PHY.rx_syncstatus != 0);
    $sformat(message, "%m: Test passed");
    print(VERBOSITY_INFO, message);
    $stop();
  end

  initial begin
    wait(`MGMT_RESET_N.reset == 1);
    $sformat(message, "%m: Reset released");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY.tx_ready == 1);
    $sformat(message, "%m: TX ready");
    print(VERBOSITY_INFO, message);
  end

  initial begin
    wait(`PHY.rx_ready == 1);
    $sformat(message, "%m: RX ready");
    print(VERBOSITY_INFO, message);
  end

  // Serial line XCVR decoder
  reg ref_8g_clk;
  reg [9:0] symbol_r;
  reg [9:0] symbol_rr;
  int bit_cntr = 0;
  string symbol;

  // Used to manually reference tick/tocks on the serial XCVR lines
  // Half clock period in ps:
  // TODO: Use the high-speed SerDes clock
  localparam time HALF_CLOCK_PERIOD = 1000000.000000/(8500*2);

  always begin
    #HALF_CLOCK_PERIOD;
    ref_8g_clk = `PHY.pll_locked;

    #HALF_CLOCK_PERIOD;
    ref_8g_clk = 1'b0;
   end

   always @(posedge ref_8g_clk) begin
     symbol_r[0] <= `PHY.tx_serial_data;
     symbol_r[9:1] <= symbol_r[8:0];
     bit_cntr <= bit_cntr + 1;
     // Calculated to match simuation model latency
     // Simply look for the K28.5 in RD- (0x0FA) and match
     if (bit_cntr == 11) begin
       bit_cntr <= 2;
       symbol_rr <= symbol_r;
       case (symbol_r)
`include "tb_8b10b.sv"
         default : symbol <= "<Unknown>";
       endcase
     end
   end
endmodule
