`timescale 1 ns / 1 ns
module stream_capture (
    output wire [19:0] port0_mem_address,   //   port0_mem.address
    output wire [63:0] port0_mem_writedata, //            .writedata
    output wire        port0_mem_write,     //            .write
    input  wire [3:0]  csr_address,         //         csr.address
    input  wire        csr_write,           //            .write
    input  wire        csr_read,            //            .read
    input  wire [31:0] csr_writedata,       //            .writedata
    output wire [31:0] csr_readdata,        //            .readdata
    output wire [19:0] port1_mem_address,   //   port1_mem.address
    output wire        port1_mem_write,     //            .write
    output wire [63:0] port1_mem_writedata, //            .writedata
    input  wire [35:0] port0_st_data,       //    port0_st.data
    input  wire        port0_st_valid,      //            .valid
    input  wire [35:0] port1_st_data,       //    port1_st.data
    input  wire        port1_st_valid,      //            .valid
    input  wire        clk,                 //         clk.clk
    input  wire        reset,               //       reset.reset
    output wire        snoop_reset          // snoop_reset.reset
  );

  assign port0_mem_address = 20'h0;

  assign port0_mem_writedata = {28'hf00a, port0_st_data};

  assign port0_mem_write = 1'b1;

  assign csr_readdata = 32'h0;

  assign port1_mem_address = 20'h0;

  assign port1_mem_write = 1'b0;

  assign port1_mem_writedata = {28'hf00b, port1_st_data};

  assign snoop_reset = 1'b0;

endmodule
