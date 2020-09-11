// PCIe TLP handler for Fejkon
//
// Note about SystemVerilog:
// We could use SystemVerilog structures for this module, and some things
// would be easier to reason about - but Icarus Verilog which we use for MyHDL
// does not support it.
//
// Personal note:
// Oh well, most likely not going to use MyHDL and iverilog in the future, it
// was been quite annoying to rely on its quirks.
//
// Requirements:
//  - Lower Address should never contain the BAR region, so ensure it's bigger
//    than 2^7 bytes => 128 bytes

`timescale 1 ps / 1 ps
module fejkon_pcie_data (
    input  wire         clk,                              //                clk.clk
    input  wire         reset,                            //              reset.reset
    // PCIe TLP TX/RX
    input  wire [255:0] tlp_rx_st_data,                   //          tlp_rx_st.data
    input  wire [4:0]   tlp_rx_st_empty,                  //                   .empty
    input  wire         tlp_rx_st_error,                  //                   .error
    input  wire         tlp_rx_st_startofpacket,          //                   .startofpacket
    input  wire         tlp_rx_st_endofpacket,            //                   .endofpacket
    output wire         tlp_rx_st_ready,                  //                   .ready
    input  wire         tlp_rx_st_valid,                  //                   .valid
    // WARNING! This one is not processed through the adapter logic, so it is
    // something like ~3 cycles behind the TLP RX bus - so don't use it
    input  wire [7:0]   rx_st_bar,                        //          rx_bar_be.rx_st_bar
    output wire         rx_st_mask,                       //                   .rx_st_mask
    // Used for outgoing DMA TLPs
    output wire [255:0] tlp_tx_data_st_data,              //     tlp_tx_data_st.data
    output wire         tlp_tx_data_st_startofpacket,     //                   .startofpacket
    output wire         tlp_tx_data_st_endofpacket,       //                   .endofpacket
    output wire [4:0]   tlp_tx_data_st_empty,             //                   .empty
    input  wire         tlp_tx_data_st_ready,             //                   .ready
    output wire         tlp_tx_data_st_valid,             //                   .valid
    // Used for unsuccessful completion generation
    output wire [255:0] tlp_tx_instant_st_data,           //  tlp_tx_instant_st.data
    output wire         tlp_tx_instant_st_startofpacket,  //                   .startofpacket
    output wire         tlp_tx_instant_st_endofpacket,    //                   .endofpacket
    output wire [4:0]   tlp_tx_instant_st_empty,          //                   .empty
    input  wire         tlp_tx_instant_st_ready,          //                   .ready
    output wire         tlp_tx_instant_st_valid,          //                   .valid
    // Used for successful BAR memory read completions
    output wire [255:0] tlp_tx_response_st_data,          // tlp_tx_response_st.data
    output wire         tlp_tx_response_st_startofpacket, //                   .startofpacket
    output wire         tlp_tx_response_st_endofpacket,   //                   .endofpacket
    output wire [4:0]   tlp_tx_response_st_empty,         //                   .empty
    input  wire         tlp_tx_response_st_ready,         //                   .ready
    output wire         tlp_tx_response_st_valid,         //                   .valid
    // Incoming packet data to transmit to host memory
    input  wire [255:0] data_tx_data,                     //            data_tx.data
    input  wire         data_tx_valid,                    //                   .valid
    output wire         data_tx_ready,                    //                   .ready
    input  wire [1:0]   data_tx_channel,                  //                   .channel
    input  wire         data_tx_endofpacket,              //                   .endofpacket
    input  wire         data_tx_startofpacket,            //                   .startofpacket
    input  wire [4:0]   data_tx_empty,                    //                   .empty
    input  wire [127:0] mem_access_resp_data,             //    mem_access_resp.data
    output wire         mem_access_resp_ready,            //                   .ready
    input  wire         mem_access_resp_valid,            //                   .valid
    output wire [127:0] mem_access_req_data,              //     mem_access_req.data
    input  wire         mem_access_req_ready,             //                   .ready
    output wire         mem_access_req_valid,             //                   .valid
    input  wire         csr_read,                         //                csr.read
    input  wire         csr_write,                        //                   .write
    output wire [31:0]  csr_readdata,                     //                   .readdata
    input  wire [31:0]  csr_writedata,                    //                   .writedata
    input  wire [5:0]   csr_address,                      //                   .address
    input  wire [3:0]   tl_cfg_add,                       //          config_tl.tl_cfg_add
    input  wire [31:0]  tl_cfg_ctl,                       //                   .tl_cfg_ctl
    input  wire [52:0]  tl_cfg_sts,                       //                   .tl_cfg_sts
    output wire [4:0]   hpg_ctrler,                       //                   .hpg_ctrler
    output wire [6:0]   cpl_err,                          //                   .cpl_err
    output wire         cpl_pending,                      //                   .cpl_pending
    output wire         irq_c2h_avail,                    //      irq_c2h_avail.irq_c2h_avail
    output wire         irq_c2h_drop                      //       irq_c2h_drop.irq_c2h_drop
  );

  typedef enum integer {
    TLP_UNKNOWN = 0,
    TLP_MRD,
    TLP_MRDLK,
    TLP_MWR,
    TLP_CPL,
    TLP_CPLD
  } tlp_t;

  // From Intel example design, altpcied_ep_256bit_downstream.v
  //
  // RX Header
  // Downstream Memory TLP Format Header
  //       ||31                                                                  0||
  //       ||7|6|5|4|3|2|1|0|7|6|5|4|3|2|1|0 | 7|6 |5|4 |3|2|1|0 | 7|6|5|4|3|2|1|0||
  // rx_h0 ||R|Fmt| type    |R|TC   |  R     |TD|EP|Attr|R  |  Length             ||
  // rx_h1 ||     Requester ID               |     Tag           |LastBE  |FirstBE||
  // rx_h2 ||                          Address [63:32]                            ||
  // rx_h3 ||                          Address [31: 2]                        | R ||

  //
  // Downstream Completer TLP Format Header
  //       ||31                                                                  0||
  //       ||7|6|5|4|3|2|1|0|7|6|5|4|3|2|1|0 | 7|6 |5|4 |3|2|1|0 | 7|6|5|4|3|2|1|0||
  // rx_h0 ||R|Fmt| type    |R|TC   |  R     |TD|EP|Attr|R  |  Length             ||
  // rx_h1 ||    Completer ID                |Cplst| |  Byte Count                ||
  // rx_h2 ||     Requester ID               |     Tag           |LastBE  |FirstBE||
  //

  (* keep *) wire [15:0] my_id;

  logic my_id_valid;

  tl_cfg_module tl_cfg_mod (
    .clk(clk),
    .reset(reset),
    .tl_cfg_add(tl_cfg_add),
    .tl_cfg_ctl(tl_cfg_ctl),
    .tl_cfg_sts(tl_cfg_sts),
    .my_id(my_id),
    .my_id_valid(my_id_valid)
  );

  logic is_ready;
  // Signal indicating if we are happy to process work
  assign is_ready = ~reset & my_id_valid;

  logic tlp_rx_st_ok;
  // Signal indicating if we should process the current RX TLP stream
  // TODO(bluecmd): What about tlp_rx_st_error ?
  assign tlp_rx_st_ok = is_ready & tlp_rx_st_valid;

  //
  // Incoming TLP field accessors
  //
  logic [7:0] [31:0] tlp_rx_st_dword;
  tlp_t              tlp_rx_st_type;
  logic [2:0]        tlp_rx_st_fmt;
  logic [4:0]        tlp_rx_st_raw_type;
  logic [9:0]        tlp_rx_st_len;
  logic              tlp_rx_st_is_4dw;

  assign {
    tlp_rx_st_dword[0], tlp_rx_st_dword[1], tlp_rx_st_dword[2], tlp_rx_st_dword[3],
    tlp_rx_st_dword[4], tlp_rx_st_dword[5], tlp_rx_st_dword[6], tlp_rx_st_dword[7]
  } = tlp_rx_st_data;

  assign tlp_rx_st_fmt      = tlp_rx_st_dword[0][31:29];
  assign tlp_rx_st_raw_type = tlp_rx_st_dword[0][28:24];
  assign tlp_rx_st_len      = tlp_rx_st_dword[0][9:0];
  assign tlp_rx_st_is_4dw   = tlp_rx_st_fmt[0];

  always @(*) begin: tlp_rx_st_type_driver
    case ({tlp_rx_st_fmt[1], tlp_rx_st_raw_type})
      6'b000000: tlp_rx_st_type = TLP_MRD;
      6'b000001: tlp_rx_st_type = TLP_MRDLK;
      6'b100000: tlp_rx_st_type = TLP_MWR;
      6'b001010: tlp_rx_st_type = TLP_CPL;
      6'b101010: tlp_rx_st_type = TLP_CPLD;
      default: tlp_rx_st_type = TLP_UNKNOWN;
    endcase
  end

  //
  // Incoming TLP processing
  //

  // TODO(bluecmd): Abort any TLP if we get !rx_st_valid - from example code
  // TLP being processed, valid for whole packet duration
  tlp_t        tlp_rx_frm_type = TLP_UNKNOWN;
  logic [7:0]  tlp_rx_frm_tag = 0;
  logic [15:0] tlp_rx_frm_requester_id = 0;
  logic        tlp_rx_frm_is_start = 0;
  logic        tlp_rx_frm_is_end = 0;
  logic [63:0] tlp_rx_frm_address = 0;
  logic [63:0] tlp_rx_frm_masked_address = 0;       // Address within region
  logic        tlp_rx_frm_is_npr = 0;               // Non-Posted Request
  logic        tlp_rx_frm_is_pr = 0;                // Posted Request
  logic        tlp_rx_frm_unsupported = 0;
  logic [9:0]  tlp_rx_frm_len = 0;
  logic [11:0] tlp_rx_frm_total_byte_count = 0;
  logic [31:0] tlp_rx_frm_data = 0;

  // Process incoming TLP
  // This process converts from the Avalon-ST (rx_st_*) to the internal
  // registers for the current frame (rx_frm_*)
  always @(posedge clk) begin: process_incoming_tlp
    tlp_rx_frm_is_start <= 1'b0;
    if (is_ready && tlp_rx_st_valid && tlp_rx_st_startofpacket) begin
      tlp_rx_frm_is_start <= 1'b1;
      tlp_rx_frm_type <= tlp_rx_st_type;
      tlp_rx_frm_len <= tlp_rx_st_len;
      if (tlp_rx_st_type == TLP_CPL || tlp_rx_st_type == TLP_CPLD) begin
        tlp_rx_frm_tag <= tlp_rx_st_dword[2][15:8];
        tlp_rx_frm_requester_id <= tlp_rx_st_dword[2][31:16];
      end else if (tlp_rx_st_type == TLP_MRD || tlp_rx_st_type == TLP_MWR) begin
        tlp_rx_frm_tag <= tlp_rx_st_dword[1][15:8];
        tlp_rx_frm_requester_id <= tlp_rx_st_dword[1][31:16];
        if (tlp_rx_st_is_4dw) begin
          tlp_rx_frm_address <= {tlp_rx_st_dword[2], tlp_rx_st_dword[3][31:2], 2'b0};
          tlp_rx_frm_data <= tlp_rx_st_dword[4];
        end else begin
          tlp_rx_frm_address <= {32'b0, tlp_rx_st_dword[2][31:2], 2'b0};
          // Check "Data Alignment and Timing for 256-Bit
          // Avalon-ST RX Interface" in the "Stratix V Hard IP for PCI Express
          // User Guide" for why the following needs to be done.
          // "Non-qword aligned address occur when address[2] is set"
          // => use aligned (4) when address[2] is not set.
          // (We do the same for TX)
          if (~tlp_rx_st_dword[2][2]) begin
            tlp_rx_frm_data <= tlp_rx_st_dword[4];
          end else begin
            tlp_rx_frm_data <= tlp_rx_st_dword[3];
          end
        end
      end
    end
    tlp_rx_frm_is_end <= is_ready && tlp_rx_st_valid && tlp_rx_st_endofpacket;
  end

  // Masked address calculation
  always @(*) begin: masked_address_driver
    // TODO(bluecmd): Hard-coded to 64 KiB region
    tlp_rx_frm_masked_address = tlp_rx_frm_address & 64'h000000000000ffff;
  end

  // Posted/Non-posted Request classification
  always @(posedge clk) begin: npr_driver
    // A NPR requires a completion to be sent, a PR does not.
    // We want to figure out what we are handling to make sure we send
    // a completion if we need to, and to account the request correctly.
    if (tlp_rx_st_valid && tlp_rx_st_startofpacket) begin
      tlp_rx_frm_is_npr <= 1'b0;
      tlp_rx_frm_is_pr <= 1'b0;
      casez ({tlp_rx_st_fmt[1], tlp_rx_st_raw_type})
        6'b00000?: tlp_rx_frm_is_npr <= 1'b1;  // MRd / MRdLk
        6'b?00010: tlp_rx_frm_is_npr <= 1'b1;  // IORd / IOWr
        6'b1011??: tlp_rx_frm_is_npr <= 1'b1;  // AtomicOp
        6'b100000: tlp_rx_frm_is_pr <= 1'b1;   // MWr
        6'b?10???: tlp_rx_frm_is_pr <= 1'b1;   // Msg / MsgD
        default: ;
      endcase
    end
  end

  // Total byte count calculation
  always @(posedge clk) begin: total_byte_driver
    if (tlp_rx_st_valid && tlp_rx_st_startofpacket &&
      (tlp_rx_st_type == TLP_MRD || tlp_rx_st_type == TLP_MWR)) begin
      casez ({tlp_rx_st_dword[1][3:0], tlp_rx_st_dword[1][7:4]})
        // Source:
        // "Table 2-32:  Calculating Byte Count from Length and Byte Enables"
        8'b1??10000: tlp_rx_frm_total_byte_count <= 12'd4;
        8'b01?10000: tlp_rx_frm_total_byte_count <= 12'd3;
        8'b1?100000: tlp_rx_frm_total_byte_count <= 12'd3;
        8'b00110000: tlp_rx_frm_total_byte_count <= 12'd2;
        8'b01100000: tlp_rx_frm_total_byte_count <= 12'd2;
        8'b11000000: tlp_rx_frm_total_byte_count <= 12'd2;
        8'b00010000: tlp_rx_frm_total_byte_count <= 12'd1;
        8'b00100000: tlp_rx_frm_total_byte_count <= 12'd1;
        8'b01000000: tlp_rx_frm_total_byte_count <= 12'd1;
        8'b10000000: tlp_rx_frm_total_byte_count <= 12'd1;
        8'b00000000: tlp_rx_frm_total_byte_count <= 12'd1;
        8'b???11???: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0};
        8'b???101??: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd1;
        8'b???1001?: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd2;
        8'b???10001: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd3;
        8'b??101???: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd1;
        8'b??1001??: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd2;
        8'b??10001?: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd3;
        8'b??100001: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd4;
        8'b?1001???: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd2;
        8'b?10001??: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd3;
        8'b?100001?: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd4;
        8'b?1000001: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd5;
        8'b10001???: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd3;
        8'b100001??: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd4;
        8'b1000001?: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd5;
        8'b10000001: tlp_rx_frm_total_byte_count <= {tlp_rx_st_len, 2'b0} - 12'd6;
        default: tlp_rx_frm_total_byte_count <= 0; // Invalid
      endcase
    end
  end

  // A NPR requires a completion to be sent, a PR does not.
  // Signal unsupported requests
  always @(*) begin: tlp_unsupported_driver
    tlp_rx_frm_unsupported = 1'b0;
    if (tlp_rx_frm_type == TLP_UNKNOWN)
      tlp_rx_frm_unsupported = 1'b1; // Unknwon TLP type
    else if (tlp_rx_frm_type == TLP_CPL || tlp_rx_frm_type == TLP_MRDLK)
      tlp_rx_frm_unsupported = 1'b1; // Unsupported TLP type
    else if (tlp_rx_st_is_4dw)
      tlp_rx_frm_unsupported = 1'b1; // Unsupported 64 bit addressing
    else if (tlp_rx_frm_type == TLP_MRD || tlp_rx_frm_type == TLP_MWR) begin
      if (tlp_rx_frm_len != 10'h1)
        tlp_rx_frm_unsupported = 1'b1; // Only 1DW read/writes are allowed
      else if (tlp_rx_frm_total_byte_count != 12'h0 && tlp_rx_frm_total_byte_count != 12'h4)
        tlp_rx_frm_unsupported = 1'b1; // Only allow 32 bit reads, or zero-length
    end
  end

  logic        mem_access_out_valid = 0;
  logic [94:0] mem_access_out = 0;
  // Post incoming access to outgoing FIFO
  always @(posedge clk) begin: mem_access_driver
    mem_access_out_valid <= 1'b0;
    // TODO(bluecmd): mem_access_req_ready is not handled currently. It should
    // not overflow however, given the number of pending tags are the same as
    // the FIFO queue.
    if (is_ready && tlp_rx_frm_is_end && ~tlp_rx_frm_unsupported) begin
      mem_access_out_valid <= 1'b1;
      if (tlp_rx_frm_type == TLP_MRD) begin
        // Format for MRD:
        // [0]     0
        // [16:1]  tlp_rx_frm_requester_id
        // [24:17] tlp_rx_frm_tag
        // [32:25] unused
        // [94:33] tlp_rx_frm_masked_address[63:2]
        mem_access_out <= {tlp_rx_frm_masked_address[63:2], 8'b0, tlp_rx_frm_tag, tlp_rx_frm_requester_id, 1'b0};
      end else if (tlp_rx_frm_type == TLP_MWR) begin
        // Format for MWR:
        // [0]     1
        // [32:1]  tlp_rx_frm_data
        // [94:33] tlp_rx_frm_masked_address[63:2]
        mem_access_out <= {tlp_rx_frm_masked_address[63:2], tlp_rx_frm_data, 1'b1};
      end
    end
  end

  //
  // Incoming memory access response field accessors
  //
  logic [15:0] mem_access_resp_requester_id;
  logic [7:0]  mem_access_resp_tag;
  logic [6:0]  mem_access_resp_lower_address;
  logic [31:0] mem_access_resp_rddata;

  assign mem_access_resp_requester_id = mem_access_resp_data[15:0];
  assign mem_access_resp_tag = mem_access_resp_data[23:16];
  assign mem_access_resp_lower_address = {mem_access_resp_data[28:24], 2'b0};
  assign mem_access_resp_rddata = mem_access_resp_data[63:32];

  //
  // Outgoing TLP construction for instant & response
  //  - Response is used for responding to host mem read/writes
  //  - Instant is used to respond with things like Unsupported Requests,
  //    and other things that can be trivially calculated
  //
  logic              tlp_tx_instant_frm_valid = 0;
  logic              tlp_tx_instant_frm_startofpacket = 0;
  logic              tlp_tx_instant_frm_endofpacket = 0;
  logic        [4:0] tlp_tx_instant_frm_empty = 0;
  logic [7:0] [31:0] tlp_tx_instant_frm_dword = 0;

  logic              tlp_tx_response_frm_valid = 0;
  logic              tlp_tx_response_frm_startofpacket = 0;
  logic              tlp_tx_response_frm_endofpacket = 0;
  logic        [4:0] tlp_tx_response_frm_empty = 0;
  logic [7:0] [31:0] tlp_tx_response_frm_dword = 0;

  // Instant sender (UR and zero-length reads)
  always @(posedge clk) begin: instant_tlp_sender
    tlp_tx_instant_frm_valid <= 1'b0;
    tlp_tx_instant_frm_startofpacket <= 1'b0;
    tlp_tx_instant_frm_endofpacket <= 1'b0;
    tlp_tx_instant_frm_empty <= 5'h0;
    // Ready latency is zero, so we don't care about ready
    if (is_ready && tlp_rx_frm_is_end && tlp_rx_frm_is_npr) begin
      if (tlp_rx_frm_unsupported) begin
        // Unsupported Request Completion
        tlp_tx_instant_frm_dword <= 256'b0;
        tlp_tx_instant_frm_dword[0][31:29] <= 3'b000;   // Cpl Fmt
        tlp_tx_instant_frm_dword[0][28:24] <= 5'b01010; // Cpl Type
        tlp_tx_instant_frm_dword[0][9:0] <= 10'h0;      // Length
        tlp_tx_instant_frm_dword[1][31:16] <= my_id;    // Completer ID
        tlp_tx_instant_frm_dword[1][15:13] <= 3'h1;     // Status Unsupported Request (UR)
        tlp_tx_instant_frm_dword[1][11:0] <= tlp_rx_frm_total_byte_count;
        tlp_tx_instant_frm_dword[2][31:16] <= tlp_rx_frm_requester_id;
        tlp_tx_instant_frm_dword[2][15:8] <= tlp_rx_frm_tag;
        tlp_tx_instant_frm_dword[2][6:0] <= tlp_rx_frm_address[6:0]; // Lower address
        tlp_tx_instant_frm_empty <= 5'h14;
        tlp_tx_instant_frm_valid <= 1'b1;
        tlp_tx_instant_frm_startofpacket <= 1'b1;
        tlp_tx_instant_frm_endofpacket <= 1'b1;
      end else if (tlp_rx_frm_total_byte_count == 12'h0) begin
        // Zero-length read
        // TODO(bluecmd): I assume CplD with byte count 0 is what we want here?
        tlp_tx_instant_frm_dword[0][31:29] <= 3'b010;   // CplD Fmt
        tlp_tx_instant_frm_dword[0][28:24] <= 5'b01010; // CplD Type
        tlp_tx_instant_frm_dword[0][9:0] <= 0;          // Length
        tlp_tx_instant_frm_dword[1][31:16] <= my_id;    // Completer ID
        tlp_tx_instant_frm_dword[1][15:13] <= 0;        // Status OK
        tlp_tx_instant_frm_dword[1][11:0] <= 0;         // Byte Count
        tlp_tx_instant_frm_dword[2][31:16] <= tlp_rx_frm_requester_id;
        tlp_tx_instant_frm_dword[2][15:8] <= tlp_rx_frm_tag;
        tlp_tx_instant_frm_dword[2][6:0] <= tlp_rx_frm_address[6:0]; // Lower address
        tlp_tx_instant_frm_empty <= 5'h14;
        tlp_tx_instant_frm_valid <= 1'b1;
        tlp_tx_instant_frm_startofpacket <= 1'b1;
        tlp_tx_instant_frm_endofpacket <= 1'b1;
      end
    end
  end

  // Successful completion sender
  always @(posedge clk) begin: response_tlp_sender
    tlp_tx_response_frm_valid <= 1'b0;
    tlp_tx_response_frm_startofpacket <= 1'b0;
    tlp_tx_response_frm_endofpacket <= 1'b0;
    tlp_tx_response_frm_empty <= 5'h0;
    // Ready latency is zero, so we don't care about ready
    if (is_ready && mem_access_resp_valid) begin
      tlp_tx_response_frm_valid <= 1'b1;
      tlp_tx_response_frm_startofpacket <= 1'b1;
      tlp_tx_response_frm_endofpacket <= 1'b1;
      tlp_tx_response_frm_dword <= 256'b0;
      tlp_tx_response_frm_dword[0][31:29] <= 3'b010;   // CplD Fmt
      tlp_tx_response_frm_dword[0][28:24] <= 5'b01010; // CplD Type
      tlp_tx_response_frm_dword[0][9:0] <= 10'h1;      // Length
      tlp_tx_response_frm_dword[1][31:16] <= my_id;    // Completer ID
      tlp_tx_response_frm_dword[1][15:13] <= 0;        // Status OK
      tlp_tx_response_frm_dword[1][11:0] <= 4;         // Byte Count
      tlp_tx_response_frm_dword[2][31:16] <= mem_access_resp_requester_id;
      tlp_tx_response_frm_dword[2][15:8] <= mem_access_resp_tag;
      tlp_tx_response_frm_dword[2][6:0] <= mem_access_resp_lower_address;
      // Note: This is really poorly documented, but for some reason, if the
      // offset of the lower address *is* 8-aligned, we have to pad the
      // header with one dword - essentially shifting everything 4 bytes.
      // (We do the same for RX)
      if (mem_access_resp_lower_address[2] == 0) begin
        // Align header to 8-bytes, start data at 5th DW
        tlp_tx_response_frm_empty <= 5'hC;
        tlp_tx_response_frm_dword[4] <= mem_access_resp_rddata;
      end else begin
        tlp_tx_response_frm_empty <= 5'h10;
        tlp_tx_response_frm_dword[3] <= mem_access_resp_rddata;
      end
    end
  end

  // Outgoing errors signals
  logic cpl_err_ur_np;
  logic cpl_err_ur_p;
  assign cpl_err_ur_np = tlp_rx_frm_unsupported & tlp_rx_frm_is_npr & tlp_rx_frm_is_start;
  assign cpl_err_ur_p = tlp_rx_frm_unsupported & tlp_rx_frm_is_pr & tlp_rx_frm_is_start;

  //
  // Incoming data (C2H) - staging
  //
  // input  wire [255:0] data_tx_data,                     //            data_tx.data
  // input  wire         data_tx_valid,                    //                   .valid
  // output wire         data_tx_ready,                    //                   .ready
  // input  wire [1:0]   data_tx_channel,                  //                   .channel
  // input  wire         data_tx_endofpacket,              //                   .endofpacket
  // input  wire         data_tx_startofpacket,            //                   .startofpacket
  // input  wire [4:0]   data_tx_empty,                    //                   .empty
  //

  logic c2h_staging_done;
  logic c2h_dma_done;

  logic        c2h_dma_buf_reset_write = 0;
  logic [31:0] c2h_dma_buf_start_addr = 0;
  logic [31:0] c2h_dma_buf_end_addr = 0;
  logic [31:0] c2h_dma_host_read_ptr = 0;
  logic [31:0] c2h_dma_card_write_ptr = 0;

  c2h_dma c2h_dma (
    .clk(clk),
    .reset(reset),
    .my_id(my_id),
    .my_id_valid(my_id_valid),
    .data_tx_data(data_tx_data),
    .data_tx_valid(data_tx_valid),
    .data_tx_ready(data_tx_ready),
    .data_tx_channel(data_tx_channel),
    .data_tx_endofpacket(data_tx_endofpacket),
    .data_tx_startofpacket(data_tx_startofpacket),
    .data_tx_empty(data_tx_empty),
    .tlp_tx_data_st_data(tlp_tx_data_st_data),
    .tlp_tx_data_st_startofpacket(tlp_tx_data_st_startofpacket),
    .tlp_tx_data_st_endofpacket(tlp_tx_data_st_endofpacket),
    .tlp_tx_data_st_empty(tlp_tx_data_st_empty),
    .tlp_tx_data_st_valid(tlp_tx_data_st_valid),
    .tlp_tx_data_st_ready(tlp_tx_data_st_ready),
    .staging_done_strobe(c2h_staging_done),
    .dma_done_strobe(c2h_dma_done),
    .dma_card_write_ptr(c2h_dma_card_write_ptr)
  );

  logic c2h_dma_pkt_available = 0;
  always @(posedge clk) begin: c2h_dma_pkt_avail_driver
    if (reset) begin
      c2h_dma_pkt_available <= 0;
    end else begin
      c2h_dma_pkt_available <= c2h_dma_card_write_ptr != c2h_dma_host_read_ptr;
    end
  end

  always @(posedge clk) begin: c2h_dma_address
    if (reset) begin
      c2h_dma_card_write_ptr <= 0;
    end else begin
      if (c2h_dma_buf_reset_write) begin
        c2h_dma_card_write_ptr <= c2h_dma_buf_start_addr;
      end else if (c2h_dma_done) begin
        // Advance one frame if there is enough space for one more frame
        if (c2h_dma_card_write_ptr + 4096*2 >= c2h_dma_buf_end_addr) begin
          c2h_dma_card_write_ptr <= c2h_dma_buf_start_addr;
        end else begin
          c2h_dma_card_write_ptr <= c2h_dma_card_write_ptr + 4096;
        end
      end
    end
  end

  //
  // Internal control status
  //

  int csr_rx_tlp_counter = 0;
  int csr_rx_unsupported_tlp_counter = 0;
  int csr_tx_data_tlp_counter = 0;
  int csr_tx_instant_tlp_counter = 0;
  int csr_tx_response_tlp_counter = 0;
  int csr_c2h_staging_counter = 0;

  logic [7:0] [31:0] csr_rx_tlp = 256'b0;
  logic [7:0] [31:0] csr_tx_data_tlp = 256'b0;
  logic [7:0] [31:0] csr_tx_instant_tlp = 256'b0;
  logic [7:0] [31:0] csr_tx_response_tlp = 256'b0;

  // Process internal statistics bookkeeping
  always @(posedge clk) begin: internal_statistics
    if (reset) begin
      csr_rx_tlp_counter <= 0;
      csr_rx_unsupported_tlp_counter <= 0;
      csr_tx_data_tlp_counter <= 0;
      csr_tx_instant_tlp_counter <= 0;
      csr_tx_response_tlp_counter <= 0;
      csr_c2h_staging_counter <= 0;
      csr_rx_tlp <= 256'b0;
      csr_tx_data_tlp <= 256'b0;
      csr_tx_instant_tlp <= 256'b0;
      csr_tx_response_tlp <= 256'b0;
    end else begin
      if (tlp_rx_st_ok && tlp_rx_st_startofpacket) begin
        csr_rx_tlp_counter <= csr_rx_tlp_counter + 1;
        csr_rx_tlp <= tlp_rx_st_dword;
        // Mask out the parts we're supposed to only care about
        if (tlp_rx_st_endofpacket) begin
          case (tlp_rx_st_empty[4:2])
            3'h2: csr_rx_tlp[7:6] <= ~0;
            3'h4: csr_rx_tlp[7:4] <= ~0;
            3'h6: csr_rx_tlp[7:2] <= ~0;
            default: ;
          endcase
        end
      end
      if (tlp_rx_frm_is_end && tlp_rx_frm_unsupported) begin
        csr_rx_unsupported_tlp_counter <= csr_rx_unsupported_tlp_counter + 1;
      end
      if (c2h_staging_done) begin
        csr_c2h_staging_counter <= csr_c2h_staging_counter + 1;
      end
      if (tlp_tx_data_st_valid && tlp_tx_data_st_startofpacket) begin
        csr_tx_data_tlp_counter <= csr_tx_data_tlp_counter + 1;
        {csr_tx_data_tlp[0], csr_tx_data_tlp[1], csr_tx_data_tlp[2], csr_tx_data_tlp[3],
         csr_tx_data_tlp[4], csr_tx_data_tlp[5], csr_tx_data_tlp[6], csr_tx_data_tlp[7]} <= tlp_tx_data_st_data;
        // Mask out the parts we're supposed to only care about
        if (tlp_tx_data_st_endofpacket) begin
          case (tlp_tx_data_st_empty[4:2])
            3'h1: csr_tx_data_tlp[7:7] <= ~0;
            3'h2: csr_tx_data_tlp[7:6] <= ~0;
            3'h3: csr_tx_data_tlp[7:5] <= ~0;
            3'h4: csr_tx_data_tlp[7:4] <= ~0;
            3'h5: csr_tx_data_tlp[7:3] <= ~0;
            3'h6: csr_tx_data_tlp[7:2] <= ~0;
            3'h7: csr_tx_data_tlp[7:1] <= ~0;
            default: ;
          endcase
        end
      end
      if (tlp_tx_instant_frm_valid && tlp_tx_instant_frm_startofpacket) begin
        csr_tx_instant_tlp_counter <= csr_tx_instant_tlp_counter + 1;
        csr_tx_instant_tlp <= tlp_tx_instant_frm_dword;
        // Mask out the parts we're supposed to only care about
        if (tlp_tx_instant_frm_endofpacket) begin
          case (tlp_tx_instant_frm_empty[4:2])
            3'h1: csr_tx_instant_tlp[7:7] <= ~0;
            3'h2: csr_tx_instant_tlp[7:6] <= ~0;
            3'h3: csr_tx_instant_tlp[7:5] <= ~0;
            3'h4: csr_tx_instant_tlp[7:4] <= ~0;
            3'h5: csr_tx_instant_tlp[7:3] <= ~0;
            3'h6: csr_tx_instant_tlp[7:2] <= ~0;
            3'h7: csr_tx_instant_tlp[7:1] <= ~0;
            default: ;
          endcase
        end
      end
      if (tlp_tx_response_frm_valid && tlp_tx_response_frm_startofpacket) begin
        csr_tx_response_tlp_counter <= csr_tx_response_tlp_counter + 1;
        csr_tx_response_tlp <= tlp_tx_response_frm_dword;
        // Mask out the parts we're supposed to only care about
        if (tlp_tx_response_frm_endofpacket) begin
          case (tlp_tx_response_frm_empty[4:2])
            3'h1: csr_tx_response_tlp[7:7] <= ~0;
            3'h2: csr_tx_response_tlp[7:6] <= ~0;
            3'h3: csr_tx_response_tlp[7:5] <= ~0;
            3'h4: csr_tx_response_tlp[7:4] <= ~0;
            3'h5: csr_tx_response_tlp[7:3] <= ~0;
            3'h6: csr_tx_response_tlp[7:2] <= ~0;
            3'h7: csr_tx_response_tlp[7:1] <= ~0;
            default: ;
          endcase
        end
      end
    end
  end

  logic [31:0] csr_readdata_reg;

  // Process Control Status Register (CSR) accesses
  // This handles reading statistics and control the DMA engine
  always @(posedge clk) begin
    if (csr_read) begin
      casez (csr_address)
        6'h0: csr_readdata_reg <= {14'b0, reset, my_id_valid, my_id};
        6'h1: csr_readdata_reg <= csr_rx_tlp_counter;
        6'h2: csr_readdata_reg <= csr_rx_unsupported_tlp_counter;
        6'h3: csr_readdata_reg <= csr_tx_data_tlp_counter;
        6'h4: csr_readdata_reg <= csr_tx_instant_tlp_counter;
        6'h5: csr_readdata_reg <= csr_tx_response_tlp_counter;
        6'h6: csr_readdata_reg <= csr_c2h_staging_counter;
        // Reserved for 6'h7: csr_readdata_reg <= h2c_pkt_counter;
        6'b001???: csr_readdata_reg <= csr_rx_tlp[csr_address[2:0]];
        6'b010???: csr_readdata_reg <= csr_tx_data_tlp[csr_address[2:0]];
        6'b011???: csr_readdata_reg <= csr_tx_instant_tlp[csr_address[2:0]];
        6'b100???: csr_readdata_reg <= csr_tx_response_tlp[csr_address[2:0]];
        6'h28: csr_readdata_reg <= c2h_dma_buf_start_addr;
        6'h29: csr_readdata_reg <= c2h_dma_buf_end_addr;
        6'h2a: csr_readdata_reg <= c2h_dma_host_read_ptr;
        6'h2b: csr_readdata_reg <= c2h_dma_card_write_ptr;
        default: csr_readdata_reg <= 32'hffffffff;
      endcase
    end
  end

  always @(posedge clk) begin
    c2h_dma_buf_reset_write <= 0;
    if (reset) begin
      c2h_dma_buf_start_addr <= 0;
      c2h_dma_buf_end_addr <= 0;
      c2h_dma_host_read_ptr <= 0;
      c2h_dma_buf_reset_write <= 0;
    end else if (csr_write) begin
      casez (csr_address)
        6'h28: c2h_dma_buf_start_addr <= csr_writedata;
        6'h29: c2h_dma_buf_end_addr <= csr_writedata;
        6'h2a: c2h_dma_host_read_ptr <= csr_writedata;
        default: ;
      endcase
      if (csr_address == 6'h28 || csr_address == 6'h29) begin
        // Reset the write pointer
        c2h_dma_buf_reset_write <= 1;
      end
    end
  end

  //
  // Assignment of PCIe outputs
  //

  assign csr_readdata = csr_readdata_reg;

  assign tlp_rx_st_ready = is_ready;

  assign tlp_tx_instant_st_data = {
    tlp_tx_instant_frm_dword[0], tlp_tx_instant_frm_dword[1], tlp_tx_instant_frm_dword[2], tlp_tx_instant_frm_dword[3],
    tlp_tx_instant_frm_dword[4], tlp_tx_instant_frm_dword[5], tlp_tx_instant_frm_dword[6], tlp_tx_instant_frm_dword[7]
  };
  assign tlp_tx_instant_st_valid = tlp_tx_instant_frm_valid;
  assign tlp_tx_instant_st_startofpacket = tlp_tx_instant_frm_startofpacket;
  assign tlp_tx_instant_st_endofpacket = tlp_tx_instant_frm_endofpacket;
  assign tlp_tx_instant_st_empty = tlp_tx_instant_frm_empty;

  assign tlp_tx_response_st_data = {
    tlp_tx_response_frm_dword[0], tlp_tx_response_frm_dword[1], tlp_tx_response_frm_dword[2], tlp_tx_response_frm_dword[3],
    tlp_tx_response_frm_dword[4], tlp_tx_response_frm_dword[5], tlp_tx_response_frm_dword[6], tlp_tx_response_frm_dword[7]
  };
  assign tlp_tx_response_st_valid = tlp_tx_response_frm_valid;
  assign tlp_tx_response_st_startofpacket = tlp_tx_response_frm_startofpacket;
  assign tlp_tx_response_st_endofpacket = tlp_tx_response_frm_endofpacket;
  assign tlp_tx_response_st_empty = tlp_tx_response_frm_empty;
  // Used to stall the sending of non-posted TLPs from the PCIe IP.
  // Since we have to deal with posted TLPs anyway it seems not so useful to
  // implement it.
  assign rx_st_mask = 1'b0;

  // TODO: Set to 1 when we're waiting for completions as the master
  assign cpl_pending = 1'b0;
  // TODO: PCie completion errors for DMA
  // cpl_err[0]: Completion timeout error with recovery.
  // cpl_err[1]: Completion timeout error without recovery.
  // cpl_err[2]: Completer abort error.
  // cpl_err[3]: Unexpected completion error.
  // cpl_err[4]: Unsupported Request (UR) error for posted TLP.
  // cpl_err[5]: Unsupported Request error for non-posted TLP.
  // cpl_err[6]: Log header.
  assign cpl_err = {1'b0, cpl_err_ur_np, cpl_err_ur_p, 4'b0};

  assign mem_access_req_valid = mem_access_out_valid;
  assign mem_access_req_data = {33'b0, mem_access_out};
  assign mem_access_resp_ready = is_ready;

  assign hpg_ctrler = 5'b0;

  assign irq_c2h_drop = 1'b0;
  assign irq_c2h_avail = c2h_dma_pkt_available;

endmodule
