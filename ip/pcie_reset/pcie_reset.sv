`timescale 1 ps / 1 ps
module pcie_reset (
    input  wire  reset,     // reset.reset
    output wire  pin_perst, //  npor.pin_perst
    output wire  npor,      //      .npor
    input  wire  perst_n,   //   pin.perst_n
    input  wire  clk        //   clk.clk
  );

  wire rst;
  reg  rst_r;
  reg  rst_rr;

  assign rst = perst_n & ~reset;

  // Logic from Terasic reference design
  always @(posedge clk or negedge rst)
    begin
      if (rst == 0)
        begin
          rst_r <= 0;
          rst_rr <= 0;
        end
      else
        begin
          rst_r <= 1;
          rst_rr <= rst_r;
        end
    end

  assign npor = rst_rr;
  assign pin_perst = perst_n;

endmodule
