module av_st_fixed_mux #(
    parameter int SelectedPort   = 0,
    parameter int BitsPerSymbol  = 8,
    parameter int SymbolsPerBeat = 4,
    parameter int ChanWidth      = 1,
    // Derived parameters
    parameter int DataWidth = BitsPerSymbol * SymbolsPerBeat,
    parameter int EmptyWidth = $clog2(SymbolsPerBeat)
  ) (
    input  wire                   clk,               //   clk.clk
    input  wire                   reset,             // reset.reset
    output wire [ChanWidth-1:0]   out_channel,       //   out.channel
    output wire [DataWidth-1:0]   out_data,          //      .data
    output wire [EmptyWidth-1:0]  out_empty,         //      .empty
    output wire                   out_endofpacket,   //      .endofpacket
    output wire                   out_error,         //      .error
    input  wire                   out_ready,         //      .ready
    output wire                   out_startofpacket, //      .startofpacket
    output wire                   out_valid,         //      .valid
    input  wire [ChanWidth-1:0]   in0_channel,       //   in0.channel
    input  wire [DataWidth-1:0]   in0_data,          //      .data
    input  wire [EmptyWidth-1:0]  in0_empty,         //      .empty
    input  wire                   in0_endofpacket,   //      .endofpacket
    input  wire                   in0_error,         //      .error
    output wire                   in0_ready,         //      .ready
    input  wire                   in0_startofpacket, //      .startofpacket
    input  wire                   in0_valid,         //      .valid
    input  wire [ChanWidth-1:0]   in1_channel,       //   in1.channel
    input  wire [DataWidth-1:0]   in1_data,          //      .data
    input  wire [EmptyWidth-1:0]  in1_empty,         //      .empty
    input  wire                   in1_endofpacket,   //      .endofpacket
    input  wire                   in1_error,         //      .error
    output wire                   in1_ready,         //      .ready
    input  wire                   in1_startofpacket, //      .startofpacket
    input  wire                   in1_valid          //      .valid
  );

  timeunit      1ns;
  timeprecision 1ns;

  generate if (SelectedPort == 0) begin: gen_mux_port0
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

  generate if (SelectedPort == 1) begin: gen_mux_port1
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
