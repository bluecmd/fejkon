// Testbench for PCIe Data Facility
//
//                                           Avalon-St
//                                    +-------------------+      +---------------->   Instant memory responder
//                                    |                   |      |
//                                    |                   v      |
//                                    |           +-------+------+--------+
//                                    |           |                       |
//                                    |           |   Fejkon PCIe Data    +<------+   Packet Data DMA
//                                 +--+--+        |       Facility        +------->   TX/RX Avalon-St
//                                 |     |        |                       |
//                                 |  A  |        +---+-------+-------+---+
//                                 |     |            |       |       |
//                                 |  D  |            v       v       v
// +----------------------+        |     |         +--+--+-+--+--+-+--+--+
// |                      |        |  A  |         |     | |     | |     |
// |                      +------->+     |         |  F  | |  F  | |  F  |
// |    MyHDL Testbench   |        |  P  |         |  I  | |  I  | |  I  |
// |                      +<-------+     |         |  F  | |  F  | |  F  |
// |                      |        |  T  |         |  O  | |  O  | |  O  |
// +----------------------+        |     |         |     | |     | |     |
//                                 |  E  |         +--+--+ +--+--+ +--+--+
//                                 |     |            |       |       |
//                                 |  R  |            v       v       v
//                                 |     |         +--+-------+-------+--+
//                                 +--+--+         |                     |
//                                    ^            |     Stream Mux      |
//                                    |            |                     |
//                                    |            +----------+----------+
//                                    |                       |
//                                    |       Avalon-St       |
//                                    +-----------------------+
`timescale 1ns / 1ps
module test;

  logic clk;
  logic reset;

  logic [7:0]   rx_st_bar;
  logic         rx_st_mask;
  logic [255:0] data_tx_data;
  logic         data_tx_valid;
  logic         data_tx_ready;
  logic [1:0]   data_tx_channel;
  logic         data_tx_endofpacket;
  logic         data_tx_startofpacket;
  logic [4:0]   data_tx_empty;
  logic [127:0] mem_access_req_data;
  logic         mem_access_req_ready;
  logic         mem_access_req_valid;
  logic [127:0] mem_access_resp_data;
  logic         mem_access_resp_ready;
  logic         mem_access_resp_valid;
  logic [3:0]   tl_cfg_add;
  logic [31:0]  tl_cfg_ctl;
  logic [52:0]  tl_cfg_sts;

  logic          tlp_rx_st_valid;
  logic  [255:0] tlp_rx_st_data;
  logic          tlp_rx_st_ready;
  logic          tlp_rx_st_startofpacket;
  logic          tlp_rx_st_endofpacket;
  logic          tlp_rx_st_error;
  logic    [2:0] tlp_rx_st_empty;

  logic          tlp_tx_data_st_valid;
  logic  [255:0] tlp_tx_data_st_data;
  logic          tlp_tx_data_st_ready;
  logic          tlp_tx_data_st_startofpacket;
  logic          tlp_tx_data_st_endofpacket;
  logic    [2:0] tlp_tx_data_st_empty;
  logic          tlp_tx_instant_st_valid;
  logic  [255:0] tlp_tx_instant_st_data;
  logic          tlp_tx_instant_st_ready;
  logic          tlp_tx_instant_st_startofpacket;
  logic          tlp_tx_instant_st_endofpacket;
  logic    [2:0] tlp_tx_instant_st_empty;
  logic          tlp_tx_response_st_valid;
  logic  [255:0] tlp_tx_response_st_data;
  logic          tlp_tx_response_st_ready;
  logic          tlp_tx_response_st_startofpacket;
  logic          tlp_tx_response_st_endofpacket;
  logic    [2:0] tlp_tx_response_st_empty;

  logic          tlp_data_fifo_out_valid;
  logic  [255:0] tlp_data_fifo_out_data;
  logic          tlp_data_fifo_out_ready;
  logic          tlp_data_fifo_out_startofpacket;
  logic          tlp_data_fifo_out_endofpacket;
  logic    [2:0] tlp_data_fifo_out_empty;
  logic          tlp_response_fifo_out_valid;
  logic  [255:0] tlp_response_fifo_out_data;
  logic          tlp_response_fifo_out_ready;
  logic          tlp_response_fifo_out_startofpacket;
  logic          tlp_response_fifo_out_endofpacket;
  logic    [2:0] tlp_response_fifo_out_empty;
  logic          tlp_instant_fifo_out_valid;
  logic  [255:0] tlp_instant_fifo_out_data;
  logic          tlp_instant_fifo_out_ready;
  logic          tlp_instant_fifo_out_startofpacket;
  logic          tlp_instant_fifo_out_endofpacket;
  logic    [2:0] tlp_instant_fifo_out_empty;

  logic          tlp_tx_multiplexer_out_valid;
  logic  [255:0] tlp_tx_multiplexer_out_data;
  logic          tlp_tx_multiplexer_out_ready;
  logic    [1:0] tlp_tx_multiplexer_out_channel;
  logic          tlp_tx_multiplexer_out_startofpacket;
  logic          tlp_tx_multiplexer_out_endofpacket;
  logic    [2:0] tlp_tx_multiplexer_out_empty;

  logic          tx_st_valid;
  logic  [255:0] tx_st_data;
  logic          tx_st_ready;
  logic          tx_st_startofpacket;
  logic          tx_st_endofpacket;
  logic          tx_st_error;
  logic    [1:0] tx_st_empty;
  logic    [0:0] rx_st_valid;
  logic  [255:0] rx_st_data;
  logic          rx_st_ready;
  logic    [0:0] rx_st_startofpacket;
  logic    [0:0] rx_st_endofpacket;
  logic    [0:0] rx_st_error;
  logic    [1:0] rx_st_empty;

  initial begin
    $from_myhdl(
      clk,
      reset,
      rx_st_data,
      rx_st_empty,
      rx_st_error,
      rx_st_startofpacket,
      rx_st_endofpacket,
      rx_st_valid,
      tx_st_ready,
      rx_st_bar,
      tl_cfg_add,
      tl_cfg_ctl,
      tl_cfg_sts
    );
    $to_myhdl(
      rx_st_ready,
      tx_st_data,
      tx_st_startofpacket,
      tx_st_endofpacket,
      tx_st_error,
      tx_st_empty,
      tx_st_valid,
      rx_st_mask
    );
  end

  fejkon_pcie_data dut(
    .clk(clk),
    .reset(reset),
    .tlp_rx_st_data(tlp_rx_st_data),
    .tlp_rx_st_empty(tlp_rx_st_empty),
    .tlp_rx_st_error(tlp_rx_st_error),
    .tlp_rx_st_startofpacket(tlp_rx_st_startofpacket),
    .tlp_rx_st_endofpacket(tlp_rx_st_endofpacket),
    .tlp_rx_st_ready(tlp_rx_st_ready),
    .tlp_rx_st_valid(tlp_rx_st_valid),
    .tlp_tx_instant_st_data(tlp_tx_instant_st_data),
    .tlp_tx_instant_st_startofpacket(tlp_tx_instant_st_startofpacket),
    .tlp_tx_instant_st_endofpacket(tlp_tx_instant_st_endofpacket),
    .tlp_tx_instant_st_empty(tlp_tx_instant_st_empty),
    .tlp_tx_instant_st_valid(tlp_tx_instant_st_valid),
    .tlp_tx_instant_st_ready(tlp_tx_instant_st_ready),
    .tlp_tx_response_st_data(tlp_tx_response_st_data),
    .tlp_tx_response_st_startofpacket(tlp_tx_response_st_startofpacket),
    .tlp_tx_response_st_endofpacket(tlp_tx_response_st_endofpacket),
    .tlp_tx_response_st_empty(tlp_tx_response_st_empty),
    .tlp_tx_response_st_valid(tlp_tx_response_st_valid),
    .tlp_tx_response_st_ready(tlp_tx_response_st_ready),
    .tlp_tx_data_st_data(tlp_tx_data_st_data),
    .tlp_tx_data_st_startofpacket(tlp_tx_data_st_startofpacket),
    .tlp_tx_data_st_endofpacket(tlp_tx_data_st_endofpacket),
    .tlp_tx_data_st_empty(tlp_tx_data_st_empty),
    .tlp_tx_data_st_valid(tlp_tx_data_st_valid),
    .tlp_tx_data_st_ready(tlp_tx_data_st_ready),
    .rx_st_bar(rx_st_bar),
    .rx_st_mask(rx_st_mask),
    .data_tx_data(data_tx_data),
    .data_tx_valid(data_tx_valid),
    .data_tx_ready(data_tx_ready),
    .data_tx_channel(data_tx_channel),
    .data_tx_endofpacket(data_tx_endofpacket),
    .data_tx_startofpacket(data_tx_startofpacket),
    .data_tx_empty(data_tx_empty),
    .mem_access_resp_data(mem_access_resp_data),
    .mem_access_resp_ready(mem_access_resp_ready),
    .mem_access_resp_valid(mem_access_resp_valid),
    .mem_access_req_data(mem_access_req_data),
    .mem_access_req_ready(mem_access_req_ready),
    .mem_access_req_valid(mem_access_req_valid),
    .tl_cfg_add(tl_cfg_add),
    .tl_cfg_ctl(tl_cfg_ctl),
    .tl_cfg_sts(tl_cfg_sts)
  );

  altera_avalon_sc_fifo #(
    .SYMBOLS_PER_BEAT    (8),
    .BITS_PER_SYMBOL     (32),
    .FIFO_DEPTH          (1024),
    .CHANNEL_WIDTH       (0),
    .ERROR_WIDTH         (0),
    .USE_PACKETS         (1),
    .USE_FILL_LEVEL      (1),
    .EMPTY_LATENCY       (3),
    .USE_MEMORY_BLOCKS   (1),
    .USE_STORE_FORWARD   (0),
    .USE_ALMOST_FULL_IF  (0),
    .USE_ALMOST_EMPTY_IF (0)
  ) tlp_data_fifo (
    .clk               (clk),
    .reset             (reset),
    .csr_address       (2'b0),
    .csr_read          (1'b0),
    .csr_write         (1'b0),
    .csr_readdata      (),
    .csr_writedata     (),
    .in_data           (tlp_tx_data_st_data),
    .in_valid          (tlp_tx_data_st_valid),
    .in_ready          (tlp_tx_data_st_ready),
    .in_startofpacket  (tlp_tx_data_st_startofpacket),
    .in_endofpacket    (tlp_tx_data_st_endofpacket),
    .in_empty          (tlp_tx_data_st_empty),
    .out_data          (tlp_data_fifo_out_data),
    .out_valid         (tlp_data_fifo_out_valid),
    .out_ready         (tlp_data_fifo_out_ready),
    .out_startofpacket (tlp_data_fifo_out_startofpacket),
    .out_endofpacket   (tlp_data_fifo_out_endofpacket),
    .out_empty         (tlp_data_fifo_out_empty),
    .almost_full_data  (),
    .almost_empty_data (),
    .in_error          (1'b0),
    .out_error         (),
    .in_channel        (1'b0),
    .out_channel       ()
  );

  altera_avalon_sc_fifo #(
    .SYMBOLS_PER_BEAT    (8),
    .BITS_PER_SYMBOL     (32),
    .FIFO_DEPTH          (1024),
    .CHANNEL_WIDTH       (0),
    .ERROR_WIDTH         (0),
    .USE_PACKETS         (1),
    .USE_FILL_LEVEL      (1),
    .EMPTY_LATENCY       (3),
    .USE_MEMORY_BLOCKS   (1),
    .USE_STORE_FORWARD   (0),
    .USE_ALMOST_FULL_IF  (0),
    .USE_ALMOST_EMPTY_IF (0)
  ) tlp_instant_fifo (
    .clk               (clk),
    .reset             (reset),
    .csr_address       (2'b0),
    .csr_read          (1'b0),
    .csr_write         (1'b0),
    .csr_readdata      (),
    .csr_writedata     (),
    .in_data           (tlp_tx_instant_st_data),
    .in_valid          (tlp_tx_instant_st_valid),
    .in_ready          (tlp_tx_instant_st_ready),
    .in_startofpacket  (tlp_tx_instant_st_startofpacket),
    .in_endofpacket    (tlp_tx_instant_st_endofpacket),
    .in_empty          (tlp_tx_instant_st_empty),
    .out_data          (tlp_instant_fifo_out_data),
    .out_valid         (tlp_instant_fifo_out_valid),
    .out_ready         (tlp_instant_fifo_out_ready),
    .out_startofpacket (tlp_instant_fifo_out_startofpacket),
    .out_endofpacket   (tlp_instant_fifo_out_endofpacket),
    .out_empty         (tlp_instant_fifo_out_empty),
    .almost_full_data  (),
    .almost_empty_data (),
    .in_error          (1'b0),
    .out_error         (),
    .in_channel        (1'b0),
    .out_channel       ()
  );

  altera_avalon_sc_fifo #(
    .SYMBOLS_PER_BEAT    (8),
    .BITS_PER_SYMBOL     (32),
    .FIFO_DEPTH          (1024),
    .CHANNEL_WIDTH       (0),
    .ERROR_WIDTH         (0),
    .USE_PACKETS         (1),
    .USE_FILL_LEVEL      (1),
    .EMPTY_LATENCY       (3),
    .USE_MEMORY_BLOCKS   (1),
    .USE_STORE_FORWARD   (0),
    .USE_ALMOST_FULL_IF  (0),
    .USE_ALMOST_EMPTY_IF (0)
  ) tlp_response_fifo (
    .clk               (clk),
    .reset             (reset),
    .csr_address       (2'b0),
    .csr_read          (1'b0),
    .csr_write         (1'b0),
    .csr_readdata      (),
    .csr_writedata     (),
    .in_data           (tlp_tx_response_st_data),
    .in_valid          (tlp_tx_response_st_valid),
    .in_ready          (tlp_tx_response_st_ready),
    .in_startofpacket  (tlp_tx_response_st_startofpacket),
    .in_endofpacket    (tlp_tx_response_st_endofpacket),
    .in_empty          (tlp_tx_response_st_empty),
    .out_data          (tlp_response_fifo_out_data),
    .out_valid         (tlp_response_fifo_out_valid),
    .out_ready         (tlp_response_fifo_out_ready),
    .out_startofpacket (tlp_response_fifo_out_startofpacket),
    .out_endofpacket   (tlp_response_fifo_out_endofpacket),
    .out_empty         (tlp_response_fifo_out_empty),
    .almost_full_data  (),
    .almost_empty_data (),
    .in_error          (1'b0),
    .out_error         (),
    .in_channel        (1'b0),
    .out_channel       ()
  );

  fejkon_pcie_tlp_tx_multiplexer tlp_tx_multiplexer(
    .clk(clk),
    .reset_n(~reset),
    .out_data(tlp_tx_multiplexer_out_data),
    .out_valid(tlp_tx_multiplexer_out_valid),
    .out_ready(tlp_tx_multiplexer_out_ready),
    .out_startofpacket(tlp_tx_multiplexer_out_startofpacket),
    .out_endofpacket(tlp_tx_multiplexer_out_endofpacket),
    .out_empty(tlp_tx_multiplexer_out_empty),
    .out_channel(tlp_tx_multiplexer_out_channel),
    .in0_data(tlp_data_fifo_out_data),
    .in0_valid(tlp_data_fifo_out_valid),
    .in0_ready(tlp_data_fifo_out_ready),
    .in0_startofpacket(tlp_data_fifo_out_startofpacket),
    .in0_endofpacket(tlp_data_fifo_out_endofpacket),
    .in0_empty(tlp_data_fifo_out_empty),
    .in1_data(tlp_response_fifo_out_data),
    .in1_valid(tlp_response_fifo_out_valid),
    .in1_ready(tlp_response_fifo_out_ready),
    .in1_startofpacket(tlp_response_fifo_out_startofpacket),
    .in1_endofpacket(tlp_response_fifo_out_endofpacket),
    .in1_empty(tlp_response_fifo_out_empty),
    .in2_data(tlp_instant_fifo_out_data),
    .in2_valid(tlp_instant_fifo_out_valid),
    .in2_ready(tlp_instant_fifo_out_ready),
    .in2_startofpacket(tlp_instant_fifo_out_startofpacket),
    .in2_endofpacket(tlp_instant_fifo_out_endofpacket),
    .in2_empty(tlp_instant_fifo_out_empty)
  );

  intel_pcie_tlp_adapter tlp_adapter (
    .clk                     (clk),
    .reset                   (reset),
    .phy_tx_st_data          (tx_st_data),
    .phy_tx_st_startofpacket (tx_st_startofpacket),
    .phy_tx_st_endofpacket   (tx_st_endofpacket),
    .phy_tx_st_error         (tx_st_error),
    .phy_tx_st_empty         (tx_st_empty),
    .phy_tx_st_valid         (tx_st_valid),
    .phy_tx_st_ready         (tx_st_ready),
    .phy_rx_st_data          (rx_st_data),
    .phy_rx_st_empty         (rx_st_empty),
    .phy_rx_st_error         (rx_st_error),
    .phy_rx_st_startofpacket (rx_st_startofpacket),
    .phy_rx_st_endofpacket   (rx_st_endofpacket),
    .phy_rx_st_ready         (rx_st_ready),
    .phy_rx_st_valid         (rx_st_valid),
    .tlp_rx_st_data          (tlp_rx_st_data),
    .tlp_rx_st_empty         (tlp_rx_st_empty),
    .tlp_rx_st_endofpacket   (tlp_rx_st_endofpacket),
    .tlp_rx_st_error         (tlp_rx_st_error),
    .tlp_rx_st_startofpacket (tlp_rx_st_startofpacket),
    .tlp_rx_st_valid         (tlp_rx_st_valid),
    .tlp_rx_st_ready         (tlp_rx_st_ready),
    .tlp_tx_st_data          (tlp_tx_multiplexer_out_data),
    .tlp_tx_st_empty         (tlp_tx_multiplexer_out_empty),
    .tlp_tx_st_endofpacket   (tlp_tx_multiplexer_out_endofpacket),
    .tlp_tx_st_startofpacket (tlp_tx_multiplexer_out_startofpacket),
    .tlp_tx_st_ready         (tlp_tx_multiplexer_out_ready),
    .tlp_tx_st_valid         (tlp_tx_multiplexer_out_valid)
  );

  logic [31:0] scratch_reg = ~32'h0;

  logic        compl_valid = 0;
  logic [15:0] compl_requester_id = 0;
  logic [7:0]  compl_tag = 0;
  logic [31:0] compl_data = 0;
  logic [6:0]  compl_lower_address = 0;
  logic [31:0] mem_access_req_address;
  assign mem_access_req_address = {mem_access_req_data[62:33], 2'b0};
  assign mem_access_resp_data = {64'b0, compl_data, 3'b0, compl_lower_address[6:2], compl_tag, compl_requester_id};
  assign mem_access_resp_valid = compl_valid;
  assign mem_access_req_ready = 1'b1;

  always @(posedge clk) begin
    compl_valid <= 1'b0;
    if (mem_access_req_valid) begin
      if (mem_access_req_data[0]) begin
        // Only support writing to scratch register
        if (mem_access_req_address == 32'h80) begin
          scratch_reg <= mem_access_req_data[32:1];
        end
      end else begin
        // Read
        compl_valid <= 1'b1;
        compl_requester_id <= mem_access_req_data[16:1];
        compl_tag <= mem_access_req_data[24:17];
        compl_lower_address <= mem_access_req_address[6:0];
        case (mem_access_req_address)
          32'h0: compl_data <= 32'h02010de5;
          32'h4: compl_data <= 32'hdeadbeef;
          32'h80: compl_data <= scratch_reg;
          default: compl_data <= ~32'h0;
        endcase
      end
    end
  end

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, test);
  end
endmodule
