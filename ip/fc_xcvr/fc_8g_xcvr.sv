`timescale 1 ps / 1 ps
module fc_8g_xcvr (
    input  wire [31:0] tx_data,        //       tx.data
    output wire        tx_ready,       //         .ready
    output wire [31:0] rx_data,        //       rx.data
    output wire        rx_valid,       //         .valid
    input  wire        reset,          //    reset.reset
    input  wire        mgmt_clk,       // mgmt_clk.clk
    input  wire [9:0]  mm_address,     //  mgmt_mm.address
    output wire        mm_waitrequest, //         .waitrequest
    input  wire        mm_read,        //         .read
    input  wire        mm_write,       //         .write
    output wire [31:0] mm_readdata,    //         .readdata
    input  wire [31:0] mm_writedata,   //         .writedata
    input  wire        rd_p,           //     line.rd_p
    input  wire        td_p,           //         .td_p
    output wire        tx_clk,         //   tx_clk.clk
    output wire        rx_clk          //   rx_clk.clk
  );

  // TODO: Auto-generated HDL template

  assign tx_ready = 1'b0;

  assign rx_valid = 1'b0;

  assign rx_data = 32'b00000000000000000000000000000000;

  assign mm_waitrequest = 1'b0;

  assign mm_readdata = 32'b00000000000000000000000000000000;

  assign tx_clk = 1'b0;

  assign rx_clk = 1'b0;

endmodule
