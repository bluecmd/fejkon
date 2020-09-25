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

  logic [3:0]   in_channel_r = 0;
  logic [255:0] in_data_r = 0;
  logic         in_startofpacket_r = 0;
  logic         in_endofpacket_r = 0;
  logic [4:0]   in_empty_r = 0;
  logic         in_valid_r = 0;

  logic [3:0]   out_channel = 0;
  logic [255:0] out_data = 0;
  logic         out_endofpacket = 0;
  logic         out_startofpacket = 0;
  logic         out_valid = 0;
  logic [4:0]   out_empty = 0;

  logic [3:0]   gen_channel;
  logic [255:0] gen_data;
  logic         gen_endofpacket;
  logic         gen_startofpacket;
  logic         gen_valid;
  logic [4:0]   gen_empty;

  logic source_generator = 0;

  generator generator(
    .clk(clk),
    .reset(reset),
    .st_out_channel(gen_channel),
    .st_out_data(gen_data),
    .st_out_endofpacket(gen_endofpacket),
    .st_out_startofpacket(gen_startofpacket),
    .st_out_valid(gen_valid),
    .st_out_ready(source_generator & st_out_ready),
    .st_out_empty(gen_empty)
  );

  logic [31:0] readdata = 0;

  int   enable_generator = 0;
  logic decr_generator = 0;

  assign csr_readdata = readdata;

  always @(posedge clk) begin: csr_wr
    if (reset) begin
      enable_generator <= 0;
    end else begin
      if (decr_generator && (enable_generator != ~0 && enable_generator != 0)) begin
          enable_generator <= enable_generator - 1;
      end
      if (csr_write) begin
        if (csr_address == 0) begin
          enable_generator <= csr_writedata;
        end
      end
    end
  end

  always @(posedge clk) begin: csr_rd
    if (reset) begin
      readdata <= 0;
    end else begin
      if (csr_read) begin
        casez (csr_address)
          8'h0: readdata <= enable_generator;
          default: readdata <= ~0;
        endcase
      end
    end
  end

  always @(posedge clk) begin: arbiter
    if (reset) begin
      source_generator <= 0;
    end else begin
      // Only consider switching source on EOP or no activity
      if ((gen_endofpacket & st_out_ready & gen_valid & source_generator) ||
          (in_endofpacket_r & st_out_ready & in_valid_r & ~source_generator) ||
          (~in_valid_r & ~source_generator)) begin
        // Give priorty to the input stream
        source_generator <= 0;
        if (st_in_valid || (enable_generator == 0)) begin
          source_generator <= 0;
        end else if (gen_valid && (~source_generator || enable_generator != 1)) begin
          source_generator <= 1;
        end
      end
    end
  end

  always @(posedge clk) begin: decr_gen
    if (reset) begin
      decr_generator <= 0;
    end else begin
      decr_generator <= 0;
      if (source_generator & st_out_startofpacket & st_out_valid & st_out_ready) begin
        decr_generator <= 1;
      end
    end
  end

  logic in_ready = 0;

  always @(posedge clk) begin
    if (reset) begin
      in_valid_r <= 0;
    end else begin
      if (in_ready) begin
        in_valid_r <= st_in_valid;
        in_data_r <= st_in_data;
        in_channel_r <= st_in_channel;
        in_startofpacket_r <= st_in_startofpacket;
        in_endofpacket_r <= st_in_endofpacket;
        in_empty_r <= st_in_empty;
      end
    end
  end

  always @(*) begin: out_driver
    if (source_generator) begin
      out_valid = gen_valid;
      out_data = gen_data;
      out_channel = gen_channel;
      out_startofpacket = gen_startofpacket;
      out_endofpacket = gen_endofpacket;
      out_empty = gen_empty;
    end else begin
      out_valid = in_valid_r;
      out_data = in_data_r;
      out_channel = in_channel_r;
      out_startofpacket = in_startofpacket_r;
      out_endofpacket = in_endofpacket_r;
      out_empty = in_empty_r;
    end
  end

  always @(*) begin: ready_driver
    if (reset) begin
      in_ready = 0;
    end else begin
      in_ready = ~source_generator & (~in_valid_r | st_out_ready);
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
