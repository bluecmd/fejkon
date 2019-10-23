`timescale 1ns/1ps
module top_tb;

  logic ref_clk;
  logic probe_clk;

  logic [31:0] data;

  freq_gauge #(
    .ReferenceClock(10000000)
  ) dut (
    .reset(1'b0),
    .ref_clk(ref_clk),
    .probe_clk(probe_clk),
    .mm_readdata(data)
  );

  // 10 MHz clock
  initial begin
    ref_clk = 1'b0;
    forever #50 ref_clk = ~ref_clk;
  end

  // ~106.25 MHz (106.383 MHz) clock
  initial begin
    probe_clk = 1'b0;
    forever #4.7 probe_clk = ~probe_clk;
  end

  initial begin
    // Wait 12 ms for the measurement to be done
    #12000000
    assert(data == 'd106383400);
    $display("If no asserts triggered, then eveything is good!");
    #1000
    $stop();
  end


endmodule
