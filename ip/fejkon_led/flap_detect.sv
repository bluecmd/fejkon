module flap_detect #(
    parameter logic [31:0] Cooloff,
    parameter logic [3:0] MaxStrikes = 4'd3
  ) (
    input  wire clk,
    input  wire in,
    output wire flap
  );

  logic in_r = 0;

  logic flapped = 0;
  logic [31:0] flap_reset = 0;
  logic [31:0] flap_strikes_left = MaxStrikes;

  assign flap = flapped && (flap_strikes_left == 0);

  always_ff @(posedge clk) begin
    in_r <= in;
    if (flapped) begin
      if (in != in_r && (flap_strikes_left != 0)) begin
        flap_strikes_left <= flap_strikes_left - 1;
      end
      if (flap_reset == 0) begin
        flapped <= 0;
      end else if (flapped) begin
        flap_reset <= flap_reset - 1;
      end
    end else if (in != in_r) begin
      flapped <= 1;
      flap_reset <= Cooloff;
      flap_strikes_left <= MaxStrikes;
    end
  end
endmodule
