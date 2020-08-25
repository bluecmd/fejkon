`timescale 1 ps / 1 ps
module pcie_msi_intr (
    output wire        app_int_sts,    // int_msi.app_int_sts
    output wire [4:0]  app_msi_num,    //        .app_msi_num
    output wire        app_msi_req,    //        .app_msi_req
    output wire [2:0]  app_msi_tc,     //        .app_msi_tc
    input  wire        app_int_ack,    //        .app_int_ack
    input  wire        app_msi_ack,    //        .app_msi_ack
    input  wire        clk,            //     clk.clk
    input  wire        reset,          //   reset.reset
    input  wire [7:0]  irq             //     irq.irq
  );

  // Always use traffic class zero for MSI.
  // There is nothing stopping us from implementing other classes but let's
  // Keep It Simple.
  assign app_msi_tc = 3'b000;

  // Controls legacy interrupts. We do not support falling back to non-MSI
  // so this is always low.
  assign app_int_sts = 1'b0;


  // Fit all MSI numbers even though we are not using all of them.
  // This is to make it easier for synth to know we are not overflowing our
  // array access.
  logic [31:0] irq_pending = 0;
  logic [31:0] irq_clear = 0;


  always @(posedge clk) begin: irq_buffer
    if (reset) begin
      irq_pending <= 0;
    end else begin
      irq_pending <= (irq_pending | {24'b0, irq}) & ~irq_clear;
    end
  end

  logic       msi_req = 0;
  logic [4:0] msi_num = 0;

  always @(posedge clk) begin: msi_tx
    if (reset) begin
      msi_req = 0;
      msi_num = 0;
      irq_clear <= 0;
    end else begin
      if (app_msi_ack) begin
        msi_req = 0;
        msi_num = 0;
      end
      msi_req = 1'b1;
      casez (irq_pending[7:0])
        8'b???????1: msi_num = 0;
        8'b??????10: msi_num = 1;
        8'b?????100: msi_num = 2;
        8'b????1000: msi_num = 3;
        8'b???10000: msi_num = 4;
        8'b??100000: msi_num = 5;
        8'b?1000000: msi_num = 6;
        8'b10000000: msi_num = 7;
        default: msi_req = 0;
      endcase
      if (msi_req) begin
        irq_clear <= 1'b1 << msi_num;
      end else begin
        irq_clear <= 0;
      end
    end
  end

  assign app_msi_req = msi_req;
  assign app_msi_num = msi_num;

endmodule
