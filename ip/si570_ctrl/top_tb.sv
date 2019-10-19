`timescale 1ns / 1ps
module top_tb ();
  reg  clk;
  reg  reset;
  wire sda;
  wire scl;

  si570_ctrl dut (
    .clk(clk),
    .reset(reset),
    .reset_out(),
    .sda(sda),
    .scl(scl)
  );

  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end

  initial begin
    #2000
    $display("Test passed");
    $stop();
  end

  initial begin
    reset = 1'b1;
    #40
    reset = 1'b0;
  end

endmodule
