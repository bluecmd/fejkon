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

`timescale 1 ps / 1 ps
module fejkon_pcie_data (
    input  wire         clk,                   //          clk.clk
    input  wire         reset,                 //        reset.reset
    input  wire [255:0] rx_st_data,            //        rx_st.data
    input  wire [1:0]   rx_st_empty,           //             .empty
    input  wire         rx_st_error,           //             .error
    input  wire         rx_st_startofpacket,   //             .startofpacket
    input  wire         rx_st_endofpacket,     //             .endofpacket
    output wire         rx_st_ready,           //             .ready
    input  wire         rx_st_valid,           //             .valid
    output wire [255:0] tx_st_data,            //        tx_st.data
    output wire         tx_st_startofpacket,   //             .startofpacket
    output wire         tx_st_endofpacket,     //             .endofpacket
    output wire         tx_st_error,           //             .error
    output wire [1:0]   tx_st_empty,           //             .empty
    input  wire         tx_st_ready,           //             .ready
    output wire         tx_st_valid,           //             .valid
    input  wire [7:0]   rx_st_bar,             //    rx_bar_be.rx_st_bar
    output wire         rx_st_mask,            //             .rx_st_mask
    input  wire [255:0] data_tx_data,          //      data_tx.data
    input  wire         data_tx_valid,         //             .valid
    output wire         data_tx_ready,         //             .ready
    input  wire [1:0]   data_tx_channel,       //             .channel
    input  wire         data_tx_endofpacket,   //             .endofpacket
    input  wire         data_tx_startofpacket, //             .startofpacket
    input  wire [4:0]   data_tx_empty,         //             .empty
    input  wire [127:0] mem_access_resp_data,  // mem_access_resp.data
    output wire         mem_access_resp_ready, //                .ready
    input  wire         mem_access_resp_valid, //                .valid
    output wire [127:0] mem_access_req_data,   //  mem_access_req.data
    input  wire         mem_access_req_ready,  //                .ready
    output wire         mem_access_req_valid,  //                .valid
    input  wire         csr_read,              //          csr.read
    output wire [31:0]  csr_readdata,          //             .readdata
    input  wire [5:0]   csr_address,           //             .address
    input  wire [3:0]   tl_cfg_add,            //    config_tl.tl_cfg_add
    input  wire [31:0]  tl_cfg_ctl,            //             .tl_cfg_ctl
    input  wire [52:0]  tl_cfg_sts,            //             .tl_cfg_sts
    input  wire [4:0]   hpg_ctrler,            //             .hpg_ctrler
    output wire [6:0]   cpl_err,               //             .cpl_err
    output wire         cpl_pending            //             .cpl_pending
  );

  typedef enum integer {
    TLP_MRD,
    TLP_MRDLK,
    TLP_MWR,
    TLP_CPL,
    TLP_CPLD,
    TLP_UNKNOWN
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

  logic [15:0] my_id;

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
  assign is_ready =  ~reset & my_id_valid;

  logic rx_st_ok;
  // Signal indicating if we should process the current RX TLP stream
  assign rx_st_ok = is_ready & rx_st_valid;

  //
  // Incoming TLP field accessors
  //
  logic [7:0] [31:0] rx_st_dword;
  tlp_t              rx_st_type;
  logic [2:0]        rx_st_fmt;
  logic [4:0]        rx_st_raw_type;
  logic [9:0]        rx_st_len;
  logic              rx_st_is_4dw;

  assign rx_st_dword    = rx_st_data;
  assign rx_st_fmt      = rx_st_dword[0][31:29];
  assign rx_st_raw_type = rx_st_dword[0][28:24];
  assign rx_st_len      = rx_st_dword[0][9:0];
  assign rx_st_is_4dw   = rx_st_fmt[0];

  always @(*) begin
    case ({rx_st_fmt[1], rx_st_raw_type})
      6'b000000: rx_st_type = TLP_MRD;
      6'b000001: rx_st_type = TLP_MRDLK;
      6'b100000: rx_st_type = TLP_MWR;
      6'b001010: rx_st_type = TLP_CPL;
      6'b101010: rx_st_type = TLP_CPLD;
      default: rx_st_type = TLP_UNKNOWN;
    endcase
  end

  //
  // Incoming TLP processing
  //

  // TLP being processed, valid for whole packet duration
  tlp_t        rx_frm_type = TLP_UNKNOWN;
  logic [7:0]  rx_frm_tag = 0;
  logic [15:0] rx_frm_requester_id = 0;
  logic        rx_frm_is_start = 0;
  logic        rx_frm_is_end = 0;
  logic [63:0] rx_frm_addr = 0;
  logic [3:0]  rx_frm_1st_be = 0;
  logic        rx_frm_is_npr = 0;               // Non-Posted Request
  logic        rx_frm_is_pr = 0;                // Posted Request
  logic        rx_frm_unsupported = 0;
  logic [9:0]  rx_frm_len = 0;
  logic [11:0] rx_frm_total_byte_count = 0;

  // Process incoming TLP
  // This process converts from the Avalon-ST (rx_st_*) to the internal
  // registers for the current frame (rx_frm_*)
  always @(posedge clk) begin
    rx_frm_is_start <= 1'b0;
    if (rx_st_valid && rx_st_startofpacket) begin
      rx_frm_is_start <= 1'b1;
      rx_frm_type <= rx_st_type;
      rx_frm_len <= rx_st_len;
      if (rx_st_type == TLP_CPL || rx_st_type == TLP_CPLD) begin
        rx_frm_tag <= rx_st_dword[2][15:8];
        rx_frm_requester_id <= rx_st_dword[2][31:16];
      end else if (rx_st_type == TLP_MRD || rx_st_type == TLP_MWR) begin
        rx_frm_1st_be <= rx_st_dword[1][3:0];
        rx_frm_tag <= rx_st_dword[1][15:8];
        rx_frm_requester_id <= rx_st_dword[1][31:16];
        if (rx_st_is_4dw) begin
          rx_frm_addr <= {rx_st_dword[2], rx_st_dword[3][31:2], 2'b0};
        end else begin
          rx_frm_addr <= {32'b0, rx_st_dword[2][31:2], 2'b0};
        end
      end
    end
    rx_frm_is_end <= rx_st_valid && rx_st_endofpacket;
  end

  // Posted/Non-posted Request classification
  always @(posedge clk) begin
    // A NPR requires a completion to be sent, a PR does not.
    // We want to figure out what we are handling to make sure we send
    // a completion if we need to, and to account the request correctly.
    if (rx_st_valid && rx_st_startofpacket) begin
      rx_frm_is_npr <= 1'b0;
      rx_frm_is_pr <= 1'b0;
      casez ({rx_st_fmt[1], rx_st_raw_type})
        6'b00000?: rx_frm_is_npr <= 1'b1;  // MRd / MRdLk
        6'b?00010: rx_frm_is_npr <= 1'b1;  // IORd / IOWr
        6'b1011??: rx_frm_is_npr <= 1'b1;  // AtomicOp
        6'b100000: rx_frm_is_pr <= 1'b1;   // MWr
        6'b?10???: rx_frm_is_pr <= 1'b1;   // Msg / MsgD
        default: ;
      endcase
    end
  end

  // Total byte count calculation
  always @(posedge clk) begin
    if (rx_st_valid && rx_st_startofpacket &&
      (rx_st_type == TLP_MRD || rx_st_type == TLP_MWR)) begin
      casez ({rx_st_dword[1][3:0], rx_st_dword[1][7:4]})
        // Source:
        // "Table 2-32:  Calculating Byte Count from Length and Byte Enables"
        8'b1??10000: rx_frm_total_byte_count <= 4;
        8'b01?10000: rx_frm_total_byte_count <= 3;
        8'b1?100000: rx_frm_total_byte_count <= 3;
        8'b00110000: rx_frm_total_byte_count <= 2;
        8'b01100000: rx_frm_total_byte_count <= 2;
        8'b11000000: rx_frm_total_byte_count <= 2;
        8'b00010000: rx_frm_total_byte_count <= 1;
        8'b00100000: rx_frm_total_byte_count <= 1;
        8'b01000000: rx_frm_total_byte_count <= 1;
        8'b10000000: rx_frm_total_byte_count <= 1;
        8'b00000000: rx_frm_total_byte_count <= 1;
        8'b???11???: rx_frm_total_byte_count <= {rx_st_len, 2'b0};
        8'b???101??: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 1;
        8'b???1001?: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 2;
        8'b???10001: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 3;
        8'b??101???: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 1;
        8'b??1001??: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 2;
        8'b??10001?: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 3;
        8'b??100001: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 4;
        8'b?1001???: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 2;
        8'b?10001??: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 3;
        8'b?100001?: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 4;
        8'b?1000001: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 5;
        8'b10001???: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 3;
        8'b100001??: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 4;
        8'b1000001?: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 5;
        8'b10000001: rx_frm_total_byte_count <= {rx_st_len, 2'b0} - 6;
        default: rx_frm_total_byte_count <= 0; // Invalid
      endcase
    end
  end

  // A NPR requires a completion to be sent, a PR does not.
  // Signal unsupported requests
  always @(*) begin
    rx_frm_unsupported = 1'b0;
    if (rx_frm_type == TLP_UNKNOWN)
      rx_frm_unsupported = 1'b1; // Unknwon TLP type
    else if (rx_frm_type == TLP_CPL || rx_frm_type == TLP_MRDLK)
      rx_frm_unsupported = 1'b1; // Unsupported TLP type
    else if (rx_st_is_4dw)
      rx_frm_unsupported = 1'b1; // Unsupported 64 bit addressing
    else if (rx_frm_type == TLP_MRD || rx_frm_type == TLP_MWR) begin
      if (rx_st_len != 10'h1)
        rx_frm_unsupported = 1'b1; // Only 1DW read/writes are allowed
      else if (rx_frm_total_byte_count != 12'h0 && rx_frm_total_byte_count != 12'h4)
        rx_frm_unsupported = 1'b1; // Only allow 32 bit reads, or zero-length
    end
  end

  //
  // Outgoing TLP construction
  //
  logic              tx_frm_valid = 0;
  logic              tx_frm_startofpacket = 0;
  logic              tx_frm_endofpacket = 0;
  logic        [1:0] tx_frm_empty = 0;
  logic [7:0] [31:0] tx_frm_dword = 0;

  // TODO(bluecmd): Abort any TLP if we get !rx_st_valid - from example code

  // TODO(bluecmd): Put the values needed (requester_id, tag, addr, size, ..?)
  // in a 64 element deep FIFO - it seems the hard IP core supports only 64
  // incoming non-posted requests so we should be good.
  // Then, create a sub-module that reads from the FIFO and produces Avalon-MM
  // transactions and writes the response into another 64 FIFO with the same
  // data and the read response. Using the same queues for MRD and MWR should
  // be fine, and we should only support 4 byte read/writes so the FIFO
  // size should be fine.
  // HMM. Thinking about this, I feel we should just export a pair of
  // Avalon-ST source/sinks with this information, and let the FIFO stuff
  // happen in Qsys. Then we create a dedicated Avalon-MM core and use the
  // Intel BFMs for that verification, keeping this core as clean as possible.
  always @(posedge clk) begin
    tx_frm_valid <= 1'b0;
    tx_frm_startofpacket <= 1'b0;
    tx_frm_endofpacket <= 1'b0;
    tx_frm_empty <= 2'h0;
    if (rx_st_ready && rx_frm_is_end && rx_frm_is_npr) begin
      tx_frm_dword <= 256'b0;
      if (rx_frm_unsupported) begin
        // Unsupported Request Completion
        tx_frm_dword[0][31:29] <= 3'b000;   // Cpl Fmt
        tx_frm_dword[0][28:24] <= 5'b01010; // Cpl Type
        tx_frm_dword[0][9:0] <= 10'h0;      // Length
        tx_frm_dword[1][31:16] <= my_id;    // Completer ID
        tx_frm_dword[1][15:13] <= 3'h1;     // Status Unsupported Request (UR)
        tx_frm_dword[1][11:0] <= rx_frm_total_byte_count;
        tx_frm_dword[2][31:16] <= rx_frm_requester_id;
        tx_frm_dword[2][15:8] <= rx_frm_tag;
        tx_frm_dword[2][6:0] <= rx_frm_addr[6:0]; // Lower address
        tx_frm_empty <= 2'h2;
      end else if (rx_frm_type == TLP_MRD) begin
        tx_frm_dword[0][31:29] <= 3'b010;   // CplD Fmt
        tx_frm_dword[0][28:24] <= 5'b01010; // CplD Type
        tx_frm_dword[0][9:0] <= 10'h1;      // Length
        tx_frm_dword[1][31:16] <= my_id;    // Completer ID
        tx_frm_dword[1][15:13] <= 0;        // Status OK
        tx_frm_dword[1][11:0] <= 4;         // Byte Count
        tx_frm_dword[2][31:16] <= rx_frm_requester_id;
        tx_frm_dword[2][15:8] <= rx_frm_tag;
        tx_frm_dword[2][6:0] <= rx_frm_addr[6:0]; // Lower address
        // Note: This is really poorly documented, but for some reason, if the
        // offset of the lower address *is* 8-aligned, we have to pad the
        // header with one dword - essentially shifting everything 4 bytes.
        if (rx_frm_addr[2] == 0) begin
          // Align header to 8-bytes, start data at 5th DW
          tx_frm_empty <= 2'h1;
          tx_frm_dword[4] <= {rx_frm_tag, rx_frm_requester_id, rx_frm_addr[7:0]};
        end else begin
          tx_frm_empty <= 2'h2;
          tx_frm_dword[3] <= {rx_frm_tag, rx_frm_requester_id, rx_frm_addr[7:0]};
        end
      end
      tx_frm_valid <= 1'b1;
      tx_frm_startofpacket <= 1'b1;
      tx_frm_endofpacket <= 1'b1;
    end
  end

  // Outgoing errors signals
  logic cpl_err_ur_np;
  logic cpl_err_ur_p;
  assign cpl_err_ur_np = rx_frm_unsupported & rx_frm_is_npr & rx_frm_is_start;
  assign cpl_err_ur_p = rx_frm_unsupported & rx_frm_is_pr & rx_frm_is_start;

  //
  // Internal ontrol status
  //

  int csr_rx_tlp_counter = 0;
  int csr_tx_tlp_counter = 0;

  logic [7:0] [31:0] csr_rx_tlp = 256'b0;
  logic [7:0] [31:0] csr_tx_tlp = 256'b0;

  // Process internal statistics bookkeeping
  always @(posedge clk) begin
    if (reset) begin
      csr_rx_tlp_counter <= 0;
      csr_tx_tlp_counter <= 0;
      csr_rx_tlp <= 256'b0;
      csr_tx_tlp <= 256'b0;
    end else begin
      if (rx_st_ok & rx_st_startofpacket) begin
        csr_rx_tlp_counter <= csr_rx_tlp_counter + 1;
        csr_rx_tlp <= rx_st_dword;
        // Mask out the parts we're supposed to only care about
        if (rx_st_endofpacket) begin
          case (rx_st_empty)
            2'h1: csr_rx_tlp[7:6] <= ~0;
            2'h2: csr_rx_tlp[7:4] <= ~0;
            2'h3: csr_rx_tlp[7:2] <= ~0;
            default: ;
          endcase
        end
      end
      if (tx_frm_valid & tx_frm_startofpacket) begin
        csr_tx_tlp_counter <= csr_tx_tlp_counter + 1;
        csr_tx_tlp <= tx_frm_dword;
        // Mask out the parts we're supposed to only care about
        if (tx_frm_endofpacket) begin
          case (tx_frm_empty)
            2'h1: csr_tx_tlp[7:6] <= ~0;
            2'h2: csr_tx_tlp[7:4] <= ~0;
            2'h3: csr_tx_tlp[7:2] <= ~0;
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
        6'h0: csr_readdata_reg <= {16'b0, my_id};
        6'h1: csr_readdata_reg <= csr_rx_tlp_counter;
        6'h2: csr_readdata_reg <= csr_tx_tlp_counter;
        6'b001???: csr_readdata_reg <= csr_rx_tlp[csr_address[2:0]];
        6'b010???: csr_readdata_reg <= csr_tx_tlp[csr_address[2:0]];
        default: csr_readdata_reg <= 32'hffffffff;
      endcase
    end
  end

  //
  // Assignment of outputs
  //

  assign csr_readdata = csr_readdata_reg;
  assign rx_st_ready = is_ready;
  assign tx_st_data = tx_frm_dword;
  assign tx_st_valid = tx_frm_valid;
  assign tx_st_startofpacket = tx_frm_startofpacket;
  assign tx_st_endofpacket = tx_frm_endofpacket;
  assign tx_st_empty = tx_frm_empty;
  assign tx_st_error = 1'b0;
  // Used to stall the sending of non-posted TLPs from the PCIe IP.
  // Since we have to deal with posted TLPs anyway it seems not so useful to
  // implement it.
  assign rx_st_mask = 1'b0;
  assign data_tx_ready = is_ready;

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

  // TODO
  assign mem_access_req_valid = 1'b0;
  assign mem_access_req_data = 128'b0;
  assign mem_access_resp_ready = 1'b0;

endmodule
