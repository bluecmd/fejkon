`timescale 1 us / 1 us
module fc_state_rx (
    input logic        clk,
    input logic        reset,
    input logic [31:0] data,
    input logic [3:0]  datak,
    output fc::state_t state,
    output is_active
  );

  fc::state_t state_r = fc::STATE_LF2, state_next;

  assign state = state_r;

  // This is Table 22 "FC_Port states" from FC-FS-5 INCITS 545-2019
  always_comb begin
    state_next = state_r;
    case (fc::map_primitive(data))
      fc::PRIM_OLS: state_next = fc::STATE_OL2;
      fc::PRIM_NOS: state_next = fc::STATE_LF1;
      fc::PRIM_LR: begin
        if (state == fc::STATE_OL3 || state == fc::STATE_LF2)
          state_next = fc::STATE_LF2;
        else
          state_next = fc::STATE_LR2;
      end
      fc::PRIM_LRR: begin
        case (state)
          fc::STATE_LF1: state_next = fc::STATE_LF1;
          fc::STATE_LF2: state_next = fc::STATE_LF2;
          fc::STATE_OL1: state_next = fc::STATE_OL1;
          fc::STATE_OL3: state_next = fc::STATE_LF2;
          default: state_next = fc::STATE_LR3;
        endcase
      end
      fc::PRIM_IDLE, fc::PRIM_ARBFF: begin
        case (state)
          fc::STATE_AC: state_next = fc::STATE_AC;
          fc::STATE_LR1: state_next = fc::STATE_LR1;
          fc::STATE_LR2: state_next = fc::STATE_AC;
          fc::STATE_LR3: state_next = fc::STATE_AC;
          fc::STATE_LF1: state_next = fc::STATE_LF1;
          fc::STATE_LF2: state_next = fc::STATE_LF2;
          fc::STATE_OL1: state_next = fc::STATE_OL1;
          fc::STATE_OL2: state_next = fc::STATE_OL2;
          fc::STATE_OL3: state_next = fc::STATE_OL2;
          default: ;
        endcase
      end
      default: ;
    endcase
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      state_r <= fc::STATE_LF2;
    end else if (datak == 4'b1000) begin
      state_r <= state_next;
    end
  end

  // On entry to the Active State, an FC_Port shall
  // transmit a minimum of 6 IDLES before transmitting other Transmission Words
  int idle_hold_off = 6;

  always_ff @(posedge clk) begin
    if (reset) begin
      idle_hold_off <= 6;
    end else if (state_r != fc::STATE_AC) begin
      idle_hold_off <= 6;
    end else if (idle_hold_off > 0) begin
      idle_hold_off <= idle_hold_off - 1;
    end
  end

  assign is_active = idle_hold_off == 0;
endmodule
