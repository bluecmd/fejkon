`timescale 1ns / 1ps
module test;

  logic clk;
  logic reset;

  logic [31:0]  bar0_mm_address;
  logic         bar0_mm_readdatavalid;
  logic [31:0]  bar0_mm_readdata;
  logic         bar0_mm_read;
  logic         bar0_mm_write;
  logic [31:0]  bar0_mm_writedata;
  logic         bar0_mm_waitrequest;
  logic [255:0] rx_st_data;
  logic [1:0]   rx_st_empty;
  logic         rx_st_error;
  logic         rx_st_startofpacket;
  logic         rx_st_endofpacket;
  logic         rx_st_ready;
  logic         rx_st_valid;
  logic [255:0] tx_st_data;
  logic         tx_st_startofpacket;
  logic         tx_st_endofpacket;
  logic         tx_st_error;
  logic [1:0]   tx_st_empty;
  logic         tx_st_ready;
  logic         tx_st_valid;
  logic [7:0]   rx_st_bar;
  logic         rx_st_mask;
  logic [255:0] data_tx_data;
  logic         data_tx_valid;
  logic         data_tx_ready;
  logic [1:0]   data_tx_channel;
  logic         data_tx_endofpacket;
  logic         data_tx_startofpacket;
  logic [4:0]   data_tx_empty;

  initial begin
    $from_myhdl(
      clk,
      reset,
      bar0_mm_readdatavalid,
      bar0_mm_readdata,
      bar0_mm_waitrequest,
      rx_st_data,
      rx_st_empty,
      rx_st_error,
      rx_st_startofpacket,
      rx_st_endofpacket,
      rx_st_valid,
      tx_st_ready,
      rx_st_bar
    );
    $to_myhdl(
      bar0_mm_address,
      bar0_mm_read,
      bar0_mm_write,
      bar0_mm_writedata,
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
    .bar0_mm_address(bar0_mm_address),
    .bar0_mm_readdatavalid(bar0_mm_readdatavalid),
    .bar0_mm_readdata(bar0_mm_readdata),
    .bar0_mm_read(bar0_mm_read),
    .bar0_mm_write(bar0_mm_write),
    .bar0_mm_writedata(bar0_mm_writedata),
    .bar0_mm_waitrequest(bar0_mm_waitrequest),
    .rx_st_data(rx_st_data),
    .rx_st_empty(rx_st_empty),
    .rx_st_error(rx_st_error),
    .rx_st_startofpacket(rx_st_startofpacket),
    .rx_st_endofpacket(rx_st_endofpacket),
    .rx_st_ready(rx_st_ready),
    .rx_st_valid(rx_st_valid),
    .tx_st_data(tx_st_data),
    .tx_st_startofpacket(tx_st_startofpacket),
    .tx_st_endofpacket(tx_st_endofpacket),
    .tx_st_error(tx_st_error),
    .tx_st_empty(tx_st_empty),
    .tx_st_ready(tx_st_ready),
    .tx_st_valid(tx_st_valid),
    .rx_st_bar(rx_st_bar),
    .rx_st_mask(rx_st_mask),
    .data_tx_data(data_tx_data),
    .data_tx_valid(data_tx_valid),
    .data_tx_ready(data_tx_ready),
    .data_tx_channel(data_tx_channel),
    .data_tx_endofpacket(data_tx_endofpacket),
    .data_tx_startofpacket(data_tx_startofpacket),
    .data_tx_empty(data_tx_empty)
  );

  pcie_msi_intr msi (
    .app_int_sts(),
    .app_msi_num(),
    .app_msi_req(),
    .app_msi_tc(),
    .app_int_ack(),
    .app_msi_ack(),
    .clk(clk),
    .reset(reset),
    .irq()
  );

  initial begin
    $dumpfile("test.fst");
    $dumpvars(0, test);
  end
endmodule
