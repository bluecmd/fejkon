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
    input  wire [4:0]   data_tx_empty          //             .empty
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
  // rx_h4 ||                          Address [31: 2]                        | R ||
  //
  // Downstream Completer TLP Format Header
  //       ||31                                                                  0||
  //       ||7|6|5|4|3|2|1|0|7|6|5|4|3|2|1|0 | 7|6 |5|4 |3|2|1|0 | 7|6|5|4|3|2|1|0||
  // rx_h0 ||R|Fmt| type    |R|TC   |  R     |TD|EP|Attr|R  |  Length             ||
  // rx_h1 ||    Completer ID                |Cplst| |  Byte Count                ||
  // rx_h2 ||     Requester ID               |     Tag           |LastBE  |FirstBE||
  //

  logic [31:0] bar0_addr = 0;

  logic [31:0] [7:0] rx_st_dword;
  logic [31:0] [7:0] tx_st_dword;
  logic [1:0] rx_st_fmt;
  logic [4:0] rx_st_type;
  logic [9:0] rx_st_len;

  assign rx_st_fmt  = rx_st_dword[0][30:29];
  assign rx_st_type = rx_st_dword[0][28:24];
  assign rx_st_len  = rx_st_dword[0][9:0];

  assign rx_st_dword = rx_st_data;
  assign tx_st_data = tx_st_dword;

  assign bar0_mm_address = bar0_addr;

  assign bar0_mm_read = 1'b0;
  assign bar0_mm_write = 1'b0;
  assign bar0_mm_writedata = 32'hdeadbeef;

  assign tx_st_valid = 1'b0;
  assign tx_st_startofpacket = 1'b0;
  assign tx_st_endofpacket = 1'b0;
  assign tx_st_error = 1'b0;
  assign tx_st_empty = 2'b00;

  // Used to stall the sending of non-posted TLPs from the PCIe IP.
  // Since we have to deal with posted TLPs anyway it seems not so useful to
  // implement it.
  assign rx_st_mask = 1'b0;

  assign rx_st_ready = ~reset;

  assign data_tx_ready = 1'b1;

  // TODO(bluecmd): Abort any TLP if we get !rx_st_valid - from example code

  always @(posedge clk) begin
    if (rx_st_valid) begin
      bar0_addr <= rx_st_dword[0];
      tx_st_dword <= rx_st_dword;
    end
  end

endmodule
