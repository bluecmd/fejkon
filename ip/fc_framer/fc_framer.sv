`timescale 1 us / 1 us
module fc_framer #(
    parameter int MTU = 3072,
    // Remain in OL1 state until the peer port is in the same state
    parameter int WAIT_FOR_PEER = 0,
    parameter int OL1_DELAY_US = 5000 // 5ms
  ) (
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
    output wire         userrx_startofpacket,     //                       .startofpacket
    output wire         userrx_endofpacket,       //                       .endofpacket
    output wire [1:0]   userrx_empty,             //                       .empty
    input  wire         reset,                    //                  reset.reset
    input  wire [2:0]   tx_mm_address,            //             tx_mgmt_mm.address
    input  wire         tx_mm_read,               //                       .read
    output wire [31:0]  tx_mm_readdata,           //                       .readdata
    input  wire [2:0]   rx_mm_address,            //             rx_mgmt_mm.address
    input  wire         rx_mm_read,               //                       .read
    output wire [31:0]  rx_mm_readdata,           //                       .readdata
    input  wire         tx_clk,                   //                 tx_clk.clk
    input  wire         rx_clk,                   //                 rx_clk.clk
    output wire         active,                   //                 active.active_led
    input  wire         peer_ready,               //             peer_ready.ready
    output wire         port_ready                //             port_ready.ready
  );

  logic rx_reset_cdc1;
  logic rx_reset_r;

  always @(posedge rx_clk) begin
    rx_reset_cdc1 <= reset;
    rx_reset_r <= rx_reset_cdc1;
  end

  logic tx_reset_cdc1;
  logic tx_reset_r;

  always @(posedge tx_clk) begin
    tx_reset_cdc1 <= reset;
    tx_reset_r <= tx_reset_cdc1;
  end

  // Driven by fc_state_rx
  (* keep *) fc::state_t state;
  fc::state_t state_r;

  fc::state_t state_tx_cdc1 = fc::STATE_OL1;
  fc::state_t state_tx_cdc2 = fc::STATE_OL1;
  fc::state_t state_tx_xfered = fc::STATE_OL1;

  logic [31:0] tx_reg_readdata;
  logic [31:0] rx_reg_readdata;
  assign tx_mm_readdata = tx_reg_readdata;
  assign rx_mm_readdata = rx_reg_readdata;

  always @(posedge tx_clk) begin
    if (tx_reset_r) begin
      tx_reg_readdata <= 0;
    end else if (tx_mm_read) begin
      case (tx_mm_address)
        // TODO: Add counter for STATE_AC transitions
        default: tx_reg_readdata <= 32'hffffffff;
      endcase
    end
  end

  int ac_transition_counter = 0;
  int urx_packet_counter = 0;

  always @(posedge rx_clk) begin
    if (rx_reset_r) begin
      rx_reg_readdata <= 0;
    end else if (rx_mm_read) begin
      case (rx_mm_address)
        3'h0: rx_reg_readdata <= state;
        3'h1: rx_reg_readdata <= ac_transition_counter;
        3'h2: rx_reg_readdata <= urx_packet_counter;
        default: rx_reg_readdata <= 32'hffffffff;
      endcase
    end
  end

  always @(posedge rx_clk) begin
    state_r <= state;
    if (rx_reset_r) begin
      ac_transition_counter <= 0;
    end else if (state_r != fc::STATE_AC && state == fc::STATE_AC) begin
      ac_transition_counter <= ac_transition_counter + 1;
    end
  end

  // This type of CDC is probably OK since both RX and TX will have very
  // similar clocks.
  always @(posedge tx_clk) begin
    state_tx_cdc1 <= state;
    state_tx_cdc2 <= state_tx_cdc1;
    state_tx_xfered <= state_tx_cdc2;
  end

  logic port_online = 0;

  logic peer_ready_cdc1 = 0;

  always @(posedge rx_clk) begin: peer_ready_cdc
    peer_ready_cdc1 <= peer_ready;
    if (WAIT_FOR_PEER == 1) begin
      port_online <= peer_ready_cdc1;
    end else begin
      port_online <= 1'b1;
    end
  end

  logic rx_active;
  logic tx_active;

  fc_state_rx #((OL1_DELAY_US * 10625) / 100) state_rx (
    .clk(rx_clk),
    .reset(rx_reset_r | ~avrx_valid),
    .data(avrx_data[31:0]),
    .datak(avrx_data[35:32]),
    .state(state),
    .tx_active(tx_active),
    .rx_active(rx_active),
    .online(port_online)
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

  assign port_ready = ~rx_reset_r & avrx_valid & (state == fc::STATE_OL1);

  assign active = tx_active & rx_active;

  // User TX -> Av-TX
  assign usertx_ready = tx_active;

  logic [3:0] usertx_datak;
  assign usertx_datak = (usertx_startofpacket | usertx_endofpacket) ? 4'b1000 : 4'b0000;

  always @(posedge tx_clk) begin
    tx_data <= (tx_active & usertx_valid) ? usertx_data : statetx_data;
    tx_datak <= (tx_active & usertx_valid) ? usertx_datak : statetx_datak;
  end

  assign avtx_data = {tx_datak, tx_data};
  assign avtx_valid = 1'b1;

  // Av RX -> User RX
  logic [31:0] rx_data;
  logic [3:0]  rx_datak;

  (* keep *) assign rx_data = avrx_data[31:0];
  (* keep *) assign rx_datak = avrx_data[35:32];

  logic [31:0] urx_data = 0;
  logic        urx_valid = 0;
  logic        urx_startofpacket = 0;
  logic        urx_endofpacket = 0;
  logic        urx_packet_detect = 0;
  int          urx_packet_length = 0;

  always @(posedge rx_clk) begin
    if (rx_reset_r) begin
      urx_data <= 0;
      urx_startofpacket <= 0;
      urx_endofpacket <= 0;
      urx_valid <= 0;
      urx_packet_counter <= 0;
      urx_packet_detect <= 0;
      urx_packet_length <= 0;
    end else if (avrx_valid) begin
      urx_data <= rx_data;
      urx_valid <= avrx_valid & rx_active & urx_packet_detect;
      urx_startofpacket <= 0;
      urx_endofpacket <= 0;
      if (urx_packet_detect) begin
        if (urx_packet_length >= MTU) begin
          // Run away packet, force it to end
          urx_endofpacket <= 1;
          urx_packet_detect <= 0;
        end else begin
          urx_packet_length <= urx_packet_length + 4;
        end
      end
      if (rx_datak == 4'b1000 && rx_active) begin
        // Any control character will end the packet
        urx_endofpacket <= urx_packet_detect;
        urx_packet_detect <= 0;
        case (fc::map_primitive(rx_data))
          fc::PRIM_SOFI2, fc::PRIM_SOFN2, fc::PRIM_SOFI3, fc::PRIM_SOFN3, fc::PRIM_SOFF: begin
            urx_startofpacket <= 1;
            urx_packet_detect <= 1;
            urx_packet_length <= 8; // Include SOF and last word
            // Ignore if we are already in a packet, this shouldn't happen
            urx_valid <= ~urx_packet_detect;
          end
          fc::PRIM_EOFT, fc::PRIM_EOFA, fc::PRIM_EOFN, fc::PRIM_EOFNI: begin
            urx_packet_counter <= urx_packet_counter + 1;
          end
          fc::PRIM_IDLE, fc::PRIM_ARBFF: begin
            urx_valid <= 0;
          end
          default: begin
            // If we are in a packet, treat this as an EOF
            urx_startofpacket <= ~urx_packet_detect;
            urx_endofpacket <= 1;
            urx_packet_counter <= urx_packet_counter + 1;
            urx_valid <= 1;
          end
        endcase
      end
    end
  end

  assign userrx_data = urx_data;
  assign userrx_valid = urx_valid;
  assign userrx_startofpacket = urx_startofpacket;
  assign userrx_endofpacket = urx_endofpacket;
  assign userrx_empty = 2'b0;

endmodule
