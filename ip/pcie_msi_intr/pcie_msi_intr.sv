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
    input  wire [23:0] irq             //     irq.irq
  );

  // Always use traffic class zero for MSI.
  // There is nothing stopping us from implementing other classes but let's
  // Keep It Simple.
  assign app_msi_tc = 3'b000;

  // Controls legacy interrupts. We do not support falling back to non-MSI
  // so this is always low.
  assign app_int_sts = 1'b0;

  // TODO: Good thing: no TLP magic needed here, it's all generated in the
  // hard IP core. Just assert app_msi_req with the correct
  // app_msi_{num,tc} and you're good to go.

  assign app_msi_req = 1'b0;
  assign app_msi_num = 5'b00000;

endmodule
