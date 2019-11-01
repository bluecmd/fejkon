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
    input  wire         mgmt_clk,                 //               mgmt_clk.clk
    input  wire [2:0]   mm_address,               //                mgmt_mm.address
    output wire         mm_waitrequest,           //                       .waitrequest
    input  wire         mm_read,                  //                       .read
    input  wire         mm_write,                 //                       .write
    output wire [31:0]  mm_readdata,              //                       .readdata
    input  wire [31:0]  mm_writedata,             //                       .writedata
    input  wire         tx_clk,                   //                 tx_clk.clk
    input  wire         rx_clk,                   //                 rx_clk.clk
    output wire         active                    //                 active.active_led
  );

  // Driven by fc_state_rx
  fc::state_t state;
  fc::state_t state_mgmt_cdc1;
  fc::state_t state_mgmt_cdc2;
  fc::state_t state_mgmt_xfered;

  fc::state_t state_tx_cdc1 = fc::STATE_LF2;
  fc::state_t state_tx_cdc2 = fc::STATE_LF2;
  fc::state_t state_tx_xfered = fc::STATE_LF2;

  logic [31:0] reg_readdata;
  assign mm_readdata = reg_readdata;

  always @* begin
    case (mm_address)
      3'h0: reg_readdata = state_mgmt_xfered;
      // TODO: Add counter for STATE_AC transitions
      default: reg_readdata = 32'hffffffff;
    endcase
  end

  //logic [31:0] user_tx_data;
  //logic [3:0]  user_tx_datak;

  //assign user_tx_data = avtx_valid ? avtx_data : fc::IDLE;
  // The start and end primitive of a frame is a K28.5, that's the only time
  // the avtx stream has a control character
  //assign user_tx_datak = (avtx_valid | avtx_startofpacket | avtx_endofpacket) ? 4'b0000 : 4'b0001;

  always @(posedge mgmt_clk) begin
    state_mgmt_cdc1 <= state;
    state_mgmt_cdc2 <= state_mgmt_cdc1;
    state_mgmt_xfered <= state_mgmt_cdc2;
  end

  always @(posedge tx_clk) begin
    state_tx_cdc1 <= state;
    state_tx_cdc2 <= state_tx_cdc1;
    state_tx_xfered <= state_tx_cdc2;
  end

  fc_state_rx state_rx (
    .clk(rx_clk),
    .reset(reset | ~avrx_valid),
    .data(avrx_data[31:0]),
    .datak(avrx_data[35:32]),
    .state(state)
  );

  fc_state_tx state_tx (
    .clk(tx_clk),
    .data(avtx_data[31:0]),
    .datak(avtx_data[35:32]),
    .state(state_tx_xfered)
  );
  assign avtx_valid = 1'b1;

  // TODO(bluecmd): Note: On entry to the Active State, an FC_Port shall
  // transmit a minimum of 6 IDLES before transmitting other Transmission Words

  assign userrx_valid = state == fc::STATE_AC;
  assign userrx_data = avtx_data[31:0];

  assign active = userrx_valid;

endmodule
