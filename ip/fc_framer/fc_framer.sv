`timescale 1 ps / 1 ps
module fc_framer (
    output wire [35:0]  avtx_data,                //                   avtx.data
    output wire         avtx_valid,               //                       .valid
    input  wire         avtx_ready,               //                       .ready
    input  wire [35:0]  avrx_data,                //                   avrx.data
    input  wire         avrx_valid,               //                       .valid
    input  wire [31:0]  usertx_data,              //                 usertx.data
    output wire         usertx_ready,             //                       .ready
    input  wire         usertx_valid,             //                       .valid
    input  wire         usertx_startofpacket,     //                       .startofpacket
    input  wire         usertx_endofpacket,       //                       .endofpacket
    output wire [31:0]  userrx_data,              //                 userrx.data
    output wire         userrx_valid,             //                       .valid
    input  wire         userrx_ready,             //                       .ready
    output wire         userrx_startofpacket,     //                       .startofpacket
    output wire         userrx_endofpacket,       //                       .endofpacket
    input  wire         reset,                    //                  reset.reset
    input  wire [2:0]   tx_mm_address,            //             tx_mgmt_mm.address
    input  wire         tx_mm_read,               //                       .read
    output wire [31:0]  tx_mm_readdata,           //                       .readdata
    input  wire [2:0]   rx_mm_address,            //             rx_mgmt_mm.address
    input  wire         rx_mm_read,               //                       .read
    output wire [31:0]  rx_mm_readdata,           //                       .readdata
    input  wire         tx_clk,                   //                 tx_clk.clk
    input  wire         rx_clk,                   //                 rx_clk.clk
    output wire         active                    //                 active.active_led
  );

  // Driven by fc_state_rx
  fc::state_t state;

  fc::state_t state_tx_cdc1 = fc::STATE_LF2;
  fc::state_t state_tx_cdc2 = fc::STATE_LF2;
  fc::state_t state_tx_xfered = fc::STATE_LF2;

  logic [31:0] tx_reg_readdata;
  logic [31:0] rx_reg_readdata;
  assign tx_mm_readdata = tx_reg_readdata;
  assign rx_mm_readdata = rx_reg_readdata;

  always @(posedge tx_clk) begin
    if (reset) begin
      tx_reg_readdata <= 0;
    end else if (tx_mm_read) begin
      case (tx_mm_address)
        3'h0: tx_reg_readdata <= state;
        // TODO: Add counter for STATE_AC transitions
        default: tx_reg_readdata <= 32'hffffffff;
      endcase
    end
  end

  always @(posedge rx_clk) begin
    if (reset) begin
      rx_reg_readdata <= 0;
    end else if (rx_mm_read) begin
      case (rx_mm_address)
        default: rx_reg_readdata <= 32'hffffffff;
      endcase
    end
  end

  //logic [31:0] user_tx_data;
  //logic [3:0]  user_tx_datak;

  //assign user_tx_data = avtx_valid ? avtx_data : fc::IDLE;
  // The start and end primitive of a frame is a K28.5, that's the only time
  // the avtx stream has a control character
  //assign user_tx_datak = (avtx_valid | avtx_startofpacket | avtx_endofpacket) ? 4'b0000 : 4'b0001;

  // This type of CDC is probably OK since both RX and TX will have very
  // similar clocks.
  always @(posedge tx_clk) begin
    state_tx_cdc1 <= state;
    state_tx_cdc2 <= state_tx_cdc1;
    state_tx_xfered <= state_tx_cdc2;
  end

  logic is_active;

  fc_state_rx state_rx (
    .clk(rx_clk),
    .reset(reset | ~avrx_valid),
    .data(avrx_data[31:0]),
    .datak(avrx_data[35:32]),
    .state(state),
    .is_active(is_active)
  );

  logic [31:0] tx_data;
  logic [3:0]  tx_datak;

  logic [31:0] statetx_data;
  logic [3:0]  statetx_datak;

  fc_state_tx state_tx (
    .clk(tx_clk),
    .data(statetx_data),
    .datak(statetx_datak),
    .state(state_tx_xfered)
  );

  assign active = is_active;

  assign userrx_valid = is_active;
  assign userrx_data = avtx_data[31:0];
  assign usertx_ready = is_active;

  logic [3:0] usertx_datak;
  assign usertx_datak = (usertx_startofpacket | usertx_endofpacket) ? 4'b1000 : 4'b0000;

  always @(posedge tx_clk) begin
    tx_data <= (is_active & usertx_valid) ? usertx_data : statetx_data;
    tx_datak <= (is_active & usertx_valid) ? usertx_datak : statetx_datak;
  end

  assign avtx_data = {tx_datak, tx_data};
  assign avtx_valid = 1'b1;

endmodule
