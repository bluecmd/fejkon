`timescale 1 ps / 1 ps
module fejkon_pcie_data (
    output wire [31:0]  bar0_mm_address,       //      bar0_mm.address
    input  wire         bar0_mm_readdatavalid, //             .readdatavalid
    input  wire [31:0]  bar0_mm_readdata,      //             .readdata
    output wire         bar0_mm_read,          //             .read
    output wire         bar0_mm_write,         //             .write
    output wire [31:0]  bar0_mm_writedata,     //             .writedata
    input  wire         bar0_mm_waitrequest,   //             .waitrequest
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
  tlp_t        rx_tx_type = TLP_UNKNOWN;
  logic [7:0]  rx_tx_tag = 0;
  logic [15:0] rx_tx_requester_id = 0;
  logic        rx_tx_strobe = 0;

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
    rx_tx_strobe <= 1'b0;
    if (rx_st_valid & rx_st_startofpacket) begin
      rx_tx_strobe <= 1'b1;
      rx_tx_type <= rx_st_type;
      if (rx_st_type == TLP_CPL || rx_st_type == TLP_CPLD) begin
        rx_tx_tag <= rx_st_dword[2][15:8];
        rx_tx_requester_id <= rx_st_dword[2][31:16];
      end else begin
        rx_tx_tag <= rx_st_dword[1][15:8];
        rx_tx_requester_id <= rx_st_dword[1][31:16];
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

  logic              tx_tx_valid;
  logic              tx_tx_startofpacket;
  logic              tx_tx_endofpacket;
  logic        [1:0] tx_tx_empty;
  logic [7:0] [31:0] tx_tx_dword;

  assign tx_st_valid = tx_tx_valid;
  assign tx_st_startofpacket = tx_tx_startofpacket;
  assign tx_st_endofpacket = tx_tx_endofpacket;
  assign tx_st_empty = tx_tx_empty;
  assign tx_st_dword = tx_tx_dword;
  assign tx_st_error = 1'b0;

  // TODO(bluecmd): Abort any TLP if we get !rx_st_valid - from example code
  always @(posedge clk) begin
    tx_tx_valid <= 1'b0;
    tx_tx_startofpacket <= 1'b0;
    tx_tx_endofpacket <= 1'b0;
    tx_tx_empty <= 2'h0;
    if (rx_tx_strobe && rx_tx_type == TLP_MRD) begin
      tx_tx_dword <= 256'b0;
      tx_tx_dword[0][30:29] <= 2'b10;   // CplD Fmt
      tx_tx_dword[0][28:24] <= 5'b1010; // CplD Type
      tx_tx_dword[0][9:0] <= 2'h1;      // Length
      tx_tx_dword[1][31:16] <= my_id;   // Completer ID
      tx_tx_dword[1][15:13] <= 0;       // Status OK
      tx_tx_dword[1][11:0] <= 4;        // Byte Count
      tx_tx_dword[2][31:16] <= rx_tx_requester_id;
      tx_tx_dword[2][15:8] <= rx_tx_tag;
      tx_tx_dword[2][6:0] <= 0;         // Lower address
      tx_tx_dword[3] <= 32'hdeadbeef;
      tx_tx_valid <= 1'b1;
      tx_tx_empty <= 2'h3;
      tx_tx_startofpacket <= 1'b1;
      tx_tx_endofpacket <= 1'b1;
    end
  end

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
