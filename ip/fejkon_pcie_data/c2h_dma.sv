// Card-to-Host (C2H) DMA Avalon-ST sink and TLP source
//
//           +-------+   +------------+   +-------+
//           |       +-->+    FIFO    +-->+       |
//           |       |   +------------+   |       |
//   +------>+ Stg.  |                    |  TLP  +------>
//  data_tx  |       +------------------->+       | tlp_data
//           |       |      metadata      |       |
//           +-------+                    +-------+

`timescale 1 ps / 1 ps
module c2h_dma (
    input  wire         clk,                              //                clk.clk
    input  wire         reset,                            //              reset.reset
    input  wire [15:0]  my_id,
    input  wire         my_id_valid,
    input  wire [255:0] data_tx_data,                     //            data_tx.data
    input  wire         data_tx_valid,                    //                   .valid
    output wire         data_tx_ready,                    //                   .ready
    input  wire [1:0]   data_tx_channel,                  //                   .channel
    input  wire         data_tx_endofpacket,              //                   .endofpacket
    input  wire         data_tx_startofpacket,            //                   .startofpacket
    input  wire [4:0]   data_tx_empty,                    //                   .empty
    output wire [255:0] tlp_tx_data_st_data,              //     tlp_tx_data_st.data
    output wire         tlp_tx_data_st_startofpacket,     //                   .startofpacket
    output wire         tlp_tx_data_st_endofpacket,       //                   .endofpacket
    output wire [4:0]   tlp_tx_data_st_empty,             //                   .empty
    input  wire         tlp_tx_data_st_ready,             //                   .ready
    output wire         tlp_tx_data_st_valid,             //                   .valid
    output wire         staging_done_strobe,
    output wire         dma_done_strobe,
    input  wire [31:0]  dma_card_write_ptr
  );

  logic [271:0] staging_data;
  logic         staging_read_req = 0;
  logic         staging_fifo_enqueue;
  logic         staging_fifo_empty;

  (* keep *) wire [255:0] staging_pkt_data;
  (* keep *) wire [1:0]   staging_pkt_channel;
  (* keep *) wire         staging_pkt_eop;
  (* keep *) wire [2:0]   staging_pkt_empty;
  (* keep *) wire [9:0]   staging_pkt_length; // dwords
  (* keep *) wire         staging_pkt_valid;

  pcie_data_fifo staging_data_fifo (
    .clock(clk),
    .sclr(reset),
    .data({1'b1, 8'h0, data_tx_empty[4:2], data_tx_endofpacket, 3'h0, data_tx_data}),
    .rdreq(staging_read_req),
    .wrreq(staging_fifo_enqueue),
    .empty(staging_fifo_empty),
    .q(staging_data));

  int   staging_offset = 0; // Position of packet currently being ingested (dwords)
  int   staging_enqueued = 0; // Number of packets in the fifo
  logic staging_done = 0; // Set when a packet has passed through ingress
  logic staging_read_ready = 0;

  logic [2:0] [11:0] staging_enq_data = 0;

  assign staging_pkt_data = staging_data[255:0];
  assign staging_pkt_eop = staging_data[259];
  assign staging_pkt_empty = staging_data[262:260];
  assign staging_pkt_length = staging_enq_data[0][9:0];
  assign staging_pkt_channel = staging_enq_data[0][11:10];
  assign staging_pkt_valid = staging_enqueued != 0 && staging_pkt_length != 0 && ~staging_fifo_empty;

  assign staging_fifo_enqueue = data_tx_valid && data_tx_ready;

  logic dma_tlp_tx_busy;

  // Signal when the staging is ready to accept more data
  logic staging_start_next;

  // Staging streams in the acquired data at the same time as the previous
  // packet is being transmitted. Maximum 1 packet pressure though to keep
  // logic simple.
  always_comb begin
    staging_start_next = 0;
    if (reset) begin
      staging_start_next = 1;
    end else if (staging_enqueued == 0) begin
      staging_start_next = 1;
    end else if (dma_tlp_tx_busy && staging_enqueued == 1) begin
      // We are sending, so we can ingest another one at the same time
      // without issue
      staging_start_next = 1;
    end
  end

  // Staging ingest block
  always @(posedge clk) begin: staging_ingest
    if (reset) begin
      staging_offset <= 0;
    end else begin
      if (staging_start_next) begin
        staging_read_ready <= 1'b1;
      end
      if (data_tx_valid && staging_read_ready) begin
        if (data_tx_endofpacket) begin
          staging_read_ready <= 1'b0;
        end
        if (data_tx_startofpacket) begin
          staging_offset <= (8 - {29'h0, data_tx_empty[4:2]});
        end else begin
          staging_offset <= staging_offset + (8 - {29'h0, data_tx_empty[4:2]});
        end
      end
    end
  end

  always @(posedge clk) begin: staging_enqueue_cntr
    if (reset) begin
      staging_enqueued = 0;
      staging_done <= 1'b0;
    end else begin
      staging_done <= 1'b0;
      if (data_tx_valid && data_tx_endofpacket && staging_read_ready) begin
        staging_done <= 1'b1;
        staging_enq_data[staging_enqueued] <= {data_tx_channel, staging_offset[9:0] + (10'd8 - {7'h0, data_tx_empty[4:2]})};
        staging_enqueued = staging_enqueued + 1;
      end
      if (staging_read_req && staging_pkt_eop) begin
        staging_enqueued = staging_enqueued - 1;
        staging_enq_data[0] <= staging_enq_data[1];
        staging_enq_data[1] <= staging_enq_data[2];
      end
    end
  end

  assign data_tx_ready = staging_read_ready && ~reset;

  //
  // Outgoing TLP construction for C2H DMA
  //

  logic              tlp_tx_data_frm_valid = 0;
  logic              tlp_tx_data_frm_startofpacket = 0;
  logic              tlp_tx_data_frm_endofpacket = 0;
  logic        [4:0] tlp_tx_data_frm_empty = 0;
  logic [7:0] [31:0] tlp_tx_data_frm_dword = 0;

  logic tx_running = 0;
  int   tx_fragment_left = 0;

  assign dma_tlp_tx_busy = tx_running;

  always @(posedge clk) begin: dma_tlp_sender
    if (reset) begin
      tx_running <= 0;
      tx_fragment_left <= 0;
      tlp_tx_data_frm_valid <= 0;
      tlp_tx_data_frm_startofpacket <= 0;
      tlp_tx_data_frm_endofpacket <= 0;
      tlp_tx_data_frm_empty <= 0;
      tlp_tx_data_frm_dword = 0;
    end else begin
      tlp_tx_data_frm_startofpacket <= 0;
      tlp_tx_data_frm_endofpacket <= 0;
      tlp_tx_data_frm_empty <= 0;
      if (staging_pkt_valid && ~tx_running) begin
        logic [3:0] data_start;
        logic [3:0] data_header_length;

        // Check "Data Alignment and Timing for 256-Bit
        // Avalon-ST RX Interface" in the "Stratix V Hard IP for PCI Express
        // User Guide" for why the following needs to be done.
        // "Non-qword aligned address occur when address[2] is set"
        // => use aligned (4) when address[2] is not set.
        if (~dma_card_write_ptr[2]) begin
          data_start = 4'h4;
        end else begin
          data_start = 4'h3;
        end
        // Align the header so that the payload is clockable at 32 byte beats
        data_header_length = 4'h8 - data_start;

        // Only send the TLP if the write ptr address is sane
        tlp_tx_data_frm_valid <= (dma_card_write_ptr != 0) && my_id_valid;
        tlp_tx_data_frm_startofpacket <= 1;
        tlp_tx_data_frm_dword = 0;
        tlp_tx_data_frm_dword[0][31:29] = 3'b010;        // TLP Fmt
        tlp_tx_data_frm_dword[0][28:24] = 5'b00000;      // TLP Type (MWr)
        // TODO: Implement proper fragmentation
        if (staging_pkt_length[9:0] > 10'd56) begin
          tlp_tx_data_frm_dword[0][9:0] = 10'd56 + {6'h0, data_header_length}; // Length
        end else begin
          tlp_tx_data_frm_dword[0][9:0] = staging_pkt_length[9:0] + {6'h0, data_header_length}; // Length
        end
        tlp_tx_data_frm_dword[1][31:16] = my_id;         // Requester ID
        tlp_tx_data_frm_dword[1][15:8] = 0;              // Tag
        tlp_tx_data_frm_dword[1][7:4] = 4'hf;            // Last BE
        tlp_tx_data_frm_dword[1][3:0] = 4'hf;            // 1st BE
        tlp_tx_data_frm_dword[2][31:2] = dma_card_write_ptr[31:2]; // Address
        tlp_tx_data_frm_dword[2][1:0] = 0;               // Processing Hints (PH)

        // Format of first header bytes:
        // 3:0 - length of header in dwords
        // 13:4  - length of packet in dwords (32 byte header + acquired length)
        // 15:14 - channel

        for (int i = 3; i < 8; i++) begin
          tlp_tx_data_frm_dword[i] = 0;
        end

        if (data_start == 4'h3) begin
          tlp_tx_data_frm_dword[3][3:0] = data_header_length;
          tlp_tx_data_frm_dword[3][13:4] = staging_pkt_length[9:0];
          tlp_tx_data_frm_dword[3][15:14] = staging_pkt_channel;
          tlp_tx_data_frm_dword[3][31:16] = 0;
        end else if (data_start == 4'h4) begin
          tlp_tx_data_frm_dword[4][3:0] = data_header_length;
          tlp_tx_data_frm_dword[4][13:4] = staging_pkt_length[9:0];
          tlp_tx_data_frm_dword[4][15:14] = staging_pkt_channel;
          tlp_tx_data_frm_dword[4][31:16] = 0;
        end
        tx_running <= 1'b1;
        staging_read_req <= 1'b1;
        // MaxPayload is assumed to be 256B (-32B for header) = 224B payload
        // 224B / 4 => 56 DWs
        if (staging_pkt_length[9:0] > 10'd56) begin
          tx_fragment_left <= 56;
        end else begin
          tx_fragment_left <= {22'h0, staging_pkt_length};
        end
      end else if (tx_running) begin
        // Correct endianness on the data. I am not 100% sure why this is
        // needed but even so I'd rather do this in hardware than in the CPU.
        {
          tlp_tx_data_frm_dword[0][7:0],
          tlp_tx_data_frm_dword[0][15:8],
          tlp_tx_data_frm_dword[0][23:16],
          tlp_tx_data_frm_dword[0][31:24],
          tlp_tx_data_frm_dword[1][7:0],
          tlp_tx_data_frm_dword[1][15:8],
          tlp_tx_data_frm_dword[1][23:16],
          tlp_tx_data_frm_dword[1][31:24],
          tlp_tx_data_frm_dword[2][7:0],
          tlp_tx_data_frm_dword[2][15:8],
          tlp_tx_data_frm_dword[2][23:16],
          tlp_tx_data_frm_dword[2][31:24],
          tlp_tx_data_frm_dword[3][7:0],
          tlp_tx_data_frm_dword[3][15:8],
          tlp_tx_data_frm_dword[3][23:16],
          tlp_tx_data_frm_dword[3][31:24],
          tlp_tx_data_frm_dword[4][7:0],
          tlp_tx_data_frm_dword[4][15:8],
          tlp_tx_data_frm_dword[4][23:16],
          tlp_tx_data_frm_dword[4][31:24],
          tlp_tx_data_frm_dword[5][7:0],
          tlp_tx_data_frm_dword[5][15:8],
          tlp_tx_data_frm_dword[5][23:16],
          tlp_tx_data_frm_dword[5][31:24],
          tlp_tx_data_frm_dword[6][7:0],
          tlp_tx_data_frm_dword[6][15:8],
          tlp_tx_data_frm_dword[6][23:16],
          tlp_tx_data_frm_dword[6][31:24],
          tlp_tx_data_frm_dword[7][7:0],
          tlp_tx_data_frm_dword[7][15:8],
          tlp_tx_data_frm_dword[7][23:16],
          tlp_tx_data_frm_dword[7][31:24]
        } = staging_pkt_data;
        tlp_tx_data_frm_empty <= {staging_pkt_empty, 2'h0};
        tlp_tx_data_frm_endofpacket <= staging_pkt_eop;
        // TODO: Implement fragmentation. Right now only truncate
        if (tx_fragment_left == 0) begin
          tlp_tx_data_frm_valid <= 0;
        end else if (tx_fragment_left <= 8) begin
          tlp_tx_data_frm_endofpacket <= 1'b1;
          tx_fragment_left <= 0;
        end else begin
          tx_fragment_left <= tx_fragment_left - 8;
        end
        if (staging_pkt_eop) begin
          staging_read_req <= 0;
          tx_running <= 0;
        end
      end else begin
        staging_read_req <= 0;
        tlp_tx_data_frm_valid <= 0;
      end
    end
  end

  logic dma_done = 0;

  // Signal done on the same cycle as the TLP EOP is being produced.
  // This allows the DMA write pointer to be updated and for a new TLP to be
  // started in the next cycle.
  always_comb begin: dma_done_strobe_driver
    if (reset) begin
      dma_done = 0;
    end else begin
      dma_done = staging_read_req && (tx_fragment_left <= 8) && tlp_tx_data_frm_valid;
      // TODO: Change to staging_pkt_eop ^^^^^^^^^^^^^^^^^^
      // This was changed to allow for truncated packets.
    end
  end

  assign tlp_tx_data_st_data = {
    tlp_tx_data_frm_dword[0], tlp_tx_data_frm_dword[1], tlp_tx_data_frm_dword[2], tlp_tx_data_frm_dword[3],
    tlp_tx_data_frm_dword[4], tlp_tx_data_frm_dword[5], tlp_tx_data_frm_dword[6], tlp_tx_data_frm_dword[7]
  };
  assign tlp_tx_data_st_valid = tlp_tx_data_frm_valid;
  assign tlp_tx_data_st_startofpacket = tlp_tx_data_frm_startofpacket;
  assign tlp_tx_data_st_endofpacket = tlp_tx_data_frm_endofpacket;
  assign tlp_tx_data_st_empty = tlp_tx_data_frm_empty;

  assign staging_done_strobe = staging_done;
  assign dma_done_strobe = dma_done;
endmodule
