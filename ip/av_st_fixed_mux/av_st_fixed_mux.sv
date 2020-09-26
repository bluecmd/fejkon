`timescale 1 ns / 1 ns
module av_st_fixed_mux #(
    parameter SELECTED_PORT    = 0,
    parameter BITS_PER_SYMBOL  = 8,
    parameter SYMBOLS_PER_BEAT = 4,
    parameter CHAN_WIDTH       = 1,
    // Derived parameters
    parameter DATA_WIDTH = BITS_PER_SYMBOL * SYMBOLS_PER_BEAT,
    parameter EMPTY_WIDTH = $clog2(SYMBOLS_PER_BEAT)
  ) (
    input  wire                    clk,               //   clk.clk
    input  wire                    reset,             // reset.reset
    output wire [CHAN_WIDTH-1:0]   out_channel,       //   out.channel
    output wire [DATA_WIDTH-1:0]   out_data,          //      .data
    output wire [EMPTY_WIDTH-1:0]  out_empty,         //      .empty
    output wire                    out_endofpacket,   //      .endofpacket
    output wire                    out_error,         //      .error
    input  wire                    out_ready,         //      .ready
    output wire                    out_startofpacket, //      .startofpacket
    output wire                    out_valid,         //      .valid
    input  wire [CHAN_WIDTH-1:0]   in0_channel,       //   in0.channel
    input  wire [DATA_WIDTH-1:0]   in0_data,          //      .data
    input  wire [EMPTY_WIDTH-1:0]  in0_empty,         //      .empty
    input  wire                    in0_endofpacket,   //      .endofpacket
    input  wire                    in0_error,         //      .error
    output wire                    in0_ready,         //      .ready
    input  wire                    in0_startofpacket, //      .startofpacket
    input  wire                    in0_valid,         //      .valid
    input  wire [CHAN_WIDTH-1:0]   in1_channel,       //   in1.channel
    input  wire [DATA_WIDTH-1:0]   in1_data,          //      .data
    input  wire [EMPTY_WIDTH-1:0]  in1_empty,         //      .empty
    input  wire                    in1_endofpacket,   //      .endofpacket
    input  wire                    in1_error,         //      .error
    output wire                    in1_ready,         //      .ready
    input  wire                    in1_startofpacket, //      .startofpacket
    input  wire                    in1_valid          //      .valid
  );

  generate if (SELECTED_PORT == 0) begin: gen_mux_port0
  assign out_valid = in0_valid;
  assign out_data = in0_data;
  assign out_channel = in0_channel;
  assign out_startofpacket = in0_startofpacket;
  assign out_endofpacket = in0_endofpacket;
  assign out_error = in0_error;
  assign out_empty = in0_empty;
  assign in0_ready = out_ready;
  assign in1_ready = 1'b0;
  end
  endgenerate

  generate if (SELECTED_PORT == 1) begin: gen_mux_port1
  assign out_valid = in1_valid;
  assign out_data = in1_data;
  assign out_channel = in1_channel;
  assign out_startofpacket = in1_startofpacket;
  assign out_endofpacket = in1_endofpacket;
  assign out_error = in1_error;
  assign out_empty = in1_empty;
  assign in1_ready = out_ready;
  assign in0_ready = 1'b0;
  end
  endgenerate

endmodule
