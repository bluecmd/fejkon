`timescale 1ns / 1ps
module test;

  logic clk;
  logic reset;

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
  logic [127:0] mem_access_req_data;
  logic         mem_access_req_ready;
  logic         mem_access_req_valid;
  logic [127:0] mem_access_resp_data;
  logic         mem_access_resp_ready;
  logic         mem_access_resp_valid;
  logic [3:0]   tl_cfg_add;
  logic [31:0]  tl_cfg_ctl;
  logic [52:0]  tl_cfg_sts;

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

  logic [31:0] scratch_reg = ~32'h0;

  logic [31:0] mem_access_req_address;
  assign mem_access_req_address = {mem_access_req_data[62:33], 2'b0};

  always @(posedge clk) begin
    mem_access_req_ready <= 1'b1;
    mem_access_resp_data <= 128'b0;
    mem_access_resp_valid <= 1'b0;
    if (mem_access_req_valid) begin
      if (mem_access_req_data[0]) begin
        // Only support writing to scratch register
        if (mem_access_req_address == 32'h80) begin
          scratch_reg <= mem_access_req_data[32:1];
        end
      end else begin
        // Read
        mem_access_resp_valid <= 1'b1;
        mem_access_resp_data[23:0] <= mem_access_req_data[24:1];    // Requester & Tag ID
        mem_access_resp_data[28:24] <= mem_access_req_address[6:2]; // Lower address
        case (mem_access_req_address)
          32'h0: mem_access_resp_data[63:32] <= 32'h02010de5;
          32'h4: mem_access_resp_data[63:32] <= 32'hdeadbeef;
          32'h80: mem_access_resp_data[63:32] <= scratch_reg;
          default: mem_access_resp_data[63:32] <= ~32'h0;
        endcase
      end
    end
  end

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, test);
  end
endmodule
