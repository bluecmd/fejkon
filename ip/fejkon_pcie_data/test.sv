`timescale 1ns / 1ps
module test;

  logic clk;
  logic reset;

  logic [31:0] bar2_mm_address;

  initial begin
    $from_myhdl(
      clk,
      reset
    );
    $to_myhdl(
      bar2_mm_address
    );
  end

  fejkon_pcie_data dut (
    .bar2_mm_address(bar2_mm_address),
    .bar2_mm_readdatavalid(),
    .bar2_mm_readdata(),
    .bar2_mm_read(),
    .bar2_mm_write(),
    .bar2_mm_writedata(),
    .bar2_mm_waitrequest(),
    .clk(clk),
    .reset(reset),
    .rx_st_data(),
    .rx_st_empty(),
    .rx_st_error(),
    .rx_st_startofpacket(),
    .rx_st_endofpacket(),
    .rx_st_ready(),
    .rx_st_valid(),
    .tx_st_data(),
    .tx_st_startofpacket(),
    .tx_st_endofpacket(),
    .tx_st_error(),
    .tx_st_empty(),
    .tx_st_valid(),
    .rx_st_bar(),
    .rx_st_mask(),
    .data_tx_data(),
    .data_tx_valid(),
    .data_tx_ready(),
    .data_tx_channel(),
    .data_tx_endofpacket(),
    .data_tx_startofpacket(),
    .data_tx_empty()
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

endmodule
