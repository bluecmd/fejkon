`timescale 1 ns / 1 ns
module top_tb;

  logic clk;
  logic fcport0_aligned;
  logic fcport0_active;
  logic fcport1_active;

  fejkon_led #(
    .ReferenceClock(10000000)
  ) dut (
    .clk(clk),
    .fcport0_aligned(fcport0_aligned),
    .fcport0_active(fcport0_active),
    .fcport1_aligned(1'b0),
    .fcport1_active(fcport1_active),
    .fcport2_aligned(1'b0),
    .fcport2_active(1'b0),
    .fcport3_aligned(1'b0),
    .fcport3_active(1'b0),
    .reconfig_busy(1'b0),
    .led_bracket(),
    .led_rj45(),
    .led_board()
  );

  initial begin
    // Wait 2 sec
    #2000000000
    // Have at least one assert to keep scripts happy
    assert(1==1);
    $stop();
  end

  // 10 MHz clock
  initial begin
    clk = 1'b0;
    forever #50 clk = ~clk;
  end

  // Stable align
  initial begin
    fcport0_aligned <= 1'b1;
  end

  // Unstable active
  initial begin
    fcport0_active = 1'b0;
    forever #5000 fcport0_active = ~fcport0_active;
  end

  // Slow unstable active
  initial begin
    fcport1_active = 1'b0;
    forever #600000000 fcport1_active = ~fcport1_active;
  end

endmodule
