`timescale 1 us / 1 us
module fc_state_tx (
    input  logic        clk,
    output logic [31:0] data,
    output logic [3:0]  datak,
    input  fc::state_t  state
  );

  always @* begin
    case (state)
      fc::STATE_AC:  data = fc::ARBFF;
      fc::STATE_LR1: data = fc::LR;
      fc::STATE_LR2: data = fc::LRR;
      fc::STATE_LR3: data = fc::IDLE;
      fc::STATE_LF1: data = fc::OLS;
      fc::STATE_LF2: data = fc::NOS;
      fc::STATE_OL1: data = fc::OLS;
      fc::STATE_OL2: data = fc::LR;
      fc::STATE_OL3: data = fc::NOS;
    endcase
  end

  assign datak = 4'b1000;
endmodule
