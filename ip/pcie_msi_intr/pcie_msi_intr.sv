`timescale 1 us / 1 us
// TODO: Remove use of blocking assignments
// verilog_lint: waive-start always-ff-non-blocking
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
  // so this is always_ff low.
  assign app_int_sts = 1'b0;


  // Fit all MSI numbers even though we are not using all of them.
  // This is to make it easier for synth to know we are not overflowing our
  // array access.
  logic [31:0] irq_pending = 0;
  logic [31:0] irq_clear = 0;

  logic [7:0] irq_r = 0;

  // This is not well-documented but the alternative is spamming the host with
  // MSI MWrs. Doing a one-shot works fine, and we should not be worried about
  // losing them (they are real transactions after all, losing TLPs would be
  // catastrophic anyway).
  //
  // We just have to be sure that when the driver is loaded, all IRQs are let
  // down before MSI is re-enabled so the host doesn't get swamped by old
  // IRQs it cannot yet handle (or that it knows to ignore them).
  always_ff @(posedge clk) begin: irq_one_shot
    if (reset) begin
      irq_r <= 0;
    end else begin
      irq_r <= irq;
    end
  end

  always_ff @(posedge clk) begin: irq_buffer
    if (reset) begin
      irq_pending <= 0;
    end else begin
      irq_pending <= (irq_pending | {24'b0, irq & ~irq_r}) & ~irq_clear;
    end
  end

  logic       msi_req = 0;
  logic [4:0] msi_num = 0;

  always_ff @(posedge clk) begin: msi_tx
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

`ifdef COCOTB_SIM
  initial begin
    $dumpfile("pcie_msi_intr.vcd");
    $dumpvars(0, pcie_msi_intr);
    #1;
  end
`endif  // COCOTB_SIM

endmodule
// verilog_lint: waive-stop always-ff-non-blocking
