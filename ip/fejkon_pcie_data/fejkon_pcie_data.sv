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
    input  wire [3:0]   tl_cfg_add,            //    config_tl.tl_cfg_add
    input  wire [31:0]  tl_cfg_ctl,            //             .tl_cfg_ctl
    input  wire [52:0]  tl_cfg_sts,            //             .tl_cfg_sts
    input  wire [4:0]   hpg_ctrler,            //             .hpg_ctrler
    output wire [6:0]   cpl_err,               //             .cpl_err
    output wire         cpl_pending            //             .cpl_pending
  );

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

  // TODO(bluecmd): This should be read from the bus/dev from config_tl.
  // That interface requires some non-trivial decoding - probably just make
  // it its own module based on altpcierd_tl_cfg_sample.v.
  // Bus Number[7:0] Device Number[4:0] Function Number[2:0]
  // We're using what is called "non-ARI" mode
  logic [15:0] my_id = {8'h0, 5'h0, 3'h0};

  logic [31:0] bar0_addr = 0;

  logic [7:0] [31:0] rx_st_dword;
  logic [7:0] [31:0] tx_st_dword;
  logic [1:0]        rx_st_fmt;
  logic [9:0]        rx_st_len;
  logic              rx_st_is_4dw;

  assign rx_st_fmt    = rx_st_dword[0][30:29];
  assign rx_st_len    = rx_st_dword[0][9:0];
  assign rx_st_is_4dw = rx_st_fmt[0];

  typedef enum integer {
    TLP_MRD,
    TLP_MWR,
    TLP_CPL,
    TLP_CPLD,
    TLP_UNKNOWN
  } tlp_t;

  tlp_t rx_st_type;

  // TLP being processed, valid for whole packet
  tlp_t        rx_frm_type = TLP_UNKNOWN;
  logic [7:0]  rx_frm_tag = 0;
  logic [15:0] rx_frm_requester_id = 0;
  logic        rx_frm_is_start = 0;
  logic [63:0] rx_frm_addr = 0;

  always @(*) begin
    case ({rx_st_fmt[1], rx_st_dword[0][28:24]})
      6'b000000: rx_st_type = TLP_MRD;
      6'b100000: rx_st_type = TLP_MWR;
      6'b001010: rx_st_type = TLP_CPL;
      6'b101010: rx_st_type = TLP_CPLD;
      default: rx_st_type = TLP_UNKNOWN;
    endcase
  end

  always @(posedge clk) begin
    rx_frm_is_start <= 1'b0;
    if (rx_st_valid & rx_st_startofpacket) begin
      rx_frm_is_start <= 1'b1;
      rx_frm_type <= rx_st_type;
      if (rx_st_type == TLP_CPL || rx_st_type == TLP_CPLD) begin
        rx_frm_tag <= rx_st_dword[2][15:8];
        rx_frm_requester_id <= rx_st_dword[2][31:16];
      end else begin
        rx_frm_tag <= rx_st_dword[1][15:8];
        rx_frm_requester_id <= rx_st_dword[1][31:16];
        if (rx_st_is_4dw) begin
          rx_frm_addr <= {rx_st_dword[2], rx_st_dword[3][31:2], 2'b0};
        end else begin
          rx_frm_addr <= {32'b0, rx_st_dword[2][31:2], 2'b0};
        end
      end
    end
  end

  assign rx_st_dword = rx_st_data;
  assign tx_st_data = tx_st_dword;

  assign bar0_mm_address = bar0_addr;

  assign bar0_mm_read = 1'b0;
  assign bar0_mm_write = 1'b0;
  assign bar0_mm_writedata = 32'hdeadbeef;

  // Used to stall the sending of non-posted TLPs from the PCIe IP.
  // Since we have to deal with posted TLPs anyway it seems not so useful to
  // implement it.
  assign rx_st_mask = 1'b0;

  assign rx_st_ready = ~reset;

  assign data_tx_ready = 1'b1;

  logic              tx_frm_valid;
  logic              tx_frm_startofpacket;
  logic              tx_frm_endofpacket;
  logic        [1:0] tx_frm_empty;
  logic [7:0] [31:0] tx_frm_dword;

  assign tx_st_valid = tx_frm_valid;
  assign tx_st_startofpacket = tx_frm_startofpacket;
  assign tx_st_endofpacket = tx_frm_endofpacket;
  assign tx_st_empty = tx_frm_empty;
  assign tx_st_dword = tx_frm_dword;
  assign tx_st_error = 1'b0;

  // TODO(bluecmd): Abort any TLP if we get !rx_st_valid - from example code
  // TODO(bluecmd): Abort if we get 64 bit addresses? I don't think we should
  // expect that, and the code is not tested.

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
    if (rx_frm_is_start && rx_frm_type == TLP_MRD) begin
      tx_frm_dword <= 256'b0;
      tx_frm_dword[0][30:29] <= 2'b10;   // CplD Fmt
      tx_frm_dword[0][28:24] <= 5'b1010; // CplD Type
      tx_frm_dword[0][9:0] <= 2'h1;      // Length
      tx_frm_dword[1][31:16] <= my_id;   // Completer ID
      tx_frm_dword[1][15:13] <= 0;       // Status OK
      tx_frm_dword[1][11:0] <= 4;        // Byte Count
      tx_frm_dword[2][31:16] <= rx_frm_requester_id;
      tx_frm_dword[2][15:8] <= rx_frm_tag;
      tx_frm_dword[2][6:0] <= rx_frm_addr[6:0]; // Lower address
      tx_frm_dword[3] <= 32'hdeadbeef;
      tx_frm_valid <= 1'b1;
      tx_frm_empty <= 2'h3;
      tx_frm_startofpacket <= 1'b1;
      tx_frm_endofpacket <= 1'b1;
    end
  end

  assign mem_access_req_valid = 1'b0;
  assign mem_access_req_data = 128'b0;
  assign mem_access_resp_ready = 1'b0;

  // TODO: PCie completion errors
  assign cpl_pending = 1'b0;
  // cpl_err[0]: Completion timeout error with recovery.
  // cpl_err[1]: Completion timeout error without recovery.
  // cpl_err[2]: Completer abort error.
  // cpl_err[3]: Unexpected completion error.
  // cpl_err[4]: Unsupported Request (UR) error for posted TLP.
  // cpl_err[5]: Unsupported Request error for non-posted TLP.
  // cpl_err[6]: Log header.
  assign cpl_err = 7'b0;

endmodule
