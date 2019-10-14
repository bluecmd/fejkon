`timescale 1 ps / 1 ps
module intel_temp (
    output wire [15:0] temp_mm_readdata, // temp_mm.readdata
    input  wire        clk,              //     clk.clk
    input  wire        reset,            //   reset.reset
    input  wire [7:0]  tsdcalo,          //    temp.tsdcalo
    input  wire        tsdcaldone        //        .tsdcaldone
  );

  reg [8:0] readdata_r;

  always @(posedge clk)
    begin
      if (reset)
        readdata_r <= 0;
      else if (tsdcaldone)
        readdata_r <= {tsdcaldone, tsdcalo};
    end

  assign temp_mm_readdata = {7'b0000000, readdata_r};

endmodule
