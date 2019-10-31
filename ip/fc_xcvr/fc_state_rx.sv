`timescale 1 ps / 1 ps
module fc_state_rx (
    input logic        clk,
    input logic        reset,
    input logic [31:0] data,
    input logic [3:0]  datak,
    output fc::state_t state
  );

  fc::state_t state_r = fc::STATE_LF2, state_next;

  assign state = state_r;

  // This is Table 22 "FC_Port states" from FC-FS-5 INCITS 545-2019
  always @* begin
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
      fc::PRIM_IDLE: begin
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
        endcase
      end
    endcase
  end

  logic reset_cdc1;
  logic reset_r;

  always @(posedge clk) begin
    reset_cdc1 <= reset;
    reset_r <= reset_cdc1;
  end

  always @(posedge clk) begin
    if (reset_r) begin
      state_r <= fc::STATE_LF2;
    end else begin
      state_r <= state_next;
    end
  end

endmodule
