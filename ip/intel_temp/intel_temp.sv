`timescale 1 ps / 1 ps
module intel_temp (
    output wire [15:0] temp_mm_readdata, // temp_mm.readdata
    output wire        clr,              //     clr.clr
    input  wire        clk,              //     clk.clk
    input  wire        reset,            //   reset.reset
    input  wire [7:0]  tsdcalo,          //    temp.tsdcalo
    input  wire        tsdcaldone        //        .tsdcaldone
  );

  reg [8:0] readdata_r;
  reg       clr_r;

  always @(posedge clk)
    begin
      if (reset)
        begin
          readdata_r <= 0;
          clr_r <= 1;
        end
      else if (tsdcaldone)
        begin
          readdata_r <= {tsdcaldone, tsdcalo};
          clr_r <= 1;
        end
      else
        clr_r <= 0;
    end

  assign temp_mm_readdata = {7'b0000000, readdata_r};
  assign clr = clr_r;

endmodule
