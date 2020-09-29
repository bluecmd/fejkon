module pcie_reset (
    input  logic reset,     // reset.reset
    output logic pin_perst, //  npor.pin_perst
    output logic npor,      //      .npor
    input  logic perst_n,   //   pin.perst_n
    input  logic clk        //   clk.clk
  );

  timeunit      1us;
  timeprecision 1us;

  logic rst;
  logic rst_r;
  logic rst_rr;

  assign rst = perst_n & ~reset;

  // Logic from Terasic reference design
  always_ff @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      rst_r <= 0;
      rst_rr <= 0;
    end else begin
      rst_r <= 1;
      rst_rr <= rst_r;
    end
  end

  assign npor = rst_rr;
  assign pin_perst = perst_n;

endmodule
