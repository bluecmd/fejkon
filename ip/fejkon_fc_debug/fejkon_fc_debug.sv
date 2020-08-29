`timescale 1 us / 1 us
module fejkon_fc_debug (
    input  wire [3:0]   st_in_channel,        //  st_in.channel
    input  wire [255:0] st_in_data,           //       .data
    input  wire         st_in_startofpacket,  //       .startofpacket
    input  wire         st_in_endofpacket,    //       .endofpacket
    output wire         st_in_ready,          //       .ready
    input  wire [4:0]   st_in_empty,          //       .empty
    input  wire         st_in_valid,          //       .valid
    output wire [3:0]   st_out_channel,       // st_out.channel
    output wire [255:0] st_out_data,          //       .data
    output wire         st_out_endofpacket,   //       .endofpacket
    output wire         st_out_startofpacket, //       .startofpacket
    output wire         st_out_valid,         //       .valid
    input  wire         st_out_ready,         //       .ready
    output wire [4:0]   st_out_empty,         //       .empty
    input  wire         clk,                  //    clk.clk
    input  wire         reset,                //  reset.reset
    input  wire [7:0]   csr_address,          //    csr.address
    input  wire         csr_write,            //       .write
    input  wire         csr_read,             //       .read
    input  wire [31:0]  csr_writedata,        //       .writedata
    output wire [31:0]  csr_readdata          //       .readdata
  );

  logic         in_ready = 0;
  logic [3:0]   out_channel = 0;
  logic [255:0] out_data = 0;
  logic         out_endofpacket = 0;
  logic         out_startofpacket = 0;
  logic         out_valid = 0;
  logic [4:0]   out_empty = 0;

  assign csr_readdata = 0;

  always @(posedge clk) begin: out_driver
    if (reset) begin
      out_valid <= 0;
    end else begin
      out_valid <= st_in_valid;
      out_data <= st_in_data;
      out_channel <= st_in_channel;
      out_startofpacket <= st_in_startofpacket;
      out_endofpacket <= st_in_endofpacket;
      out_empty <= st_in_empty;
    end
  end

  always @(posedge clk) begin: ready_driver
    if (reset) begin
      in_ready <= 0;
    end else begin
      in_ready <= st_out_ready;
    end
  end

  assign st_in_ready = in_ready;
  assign st_out_valid = out_valid;
  assign st_out_data = out_data;
  assign st_out_channel = out_channel;
  assign st_out_startofpacket = out_startofpacket;
  assign st_out_endofpacket = out_endofpacket;
  assign st_out_empty = out_empty;

`ifdef COCOTB_SIM
  initial begin
    $dumpfile("fejkon_fc_debug.vcd");
    $dumpvars(0, fejkon_fc_debug);
    #1;
  end
`endif
endmodule
