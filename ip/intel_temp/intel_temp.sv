`timescale 1 ps / 1 ps
module intel_temp #(
    parameter FanTemp = 70
  ) (
    output wire [15:0] temp_mm_readdata, // temp_mm.readdata
    output wire        clr,              //     clr.clr
    output wire        fan,              //     fan.fan
    output wire        fan_n,            //     fan_n.fan_n
    input  wire        clk,              //     clk.clk
    input  wire        reset,            //   reset.reset
    input  wire [7:0]  tsdcalo,          //    temp.tsdcalo
    input  wire        tsdcaldone        //        .tsdcaldone
  );

  reg [8:0] readdata_r = 0;
  reg       clr_r = 1;

  // The fan control is sticky. If it ever turns on it stays on until a board
  // reset. It is meant to be a protection in our case, not an every-day thing.
  reg fan_r = 0;

  always @(posedge clk)
    begin
      if (reset) begin
        readdata_r <= 0;
        clr_r <= 1;
        fan_r <= 0;
      end else if (tsdcaldone) begin
        readdata_r <= {tsdcaldone, tsdcalo};
        clr_r <= 1;
        if (tsdcalo >= FanTemp + 128) begin
          fan_r <= 1;
        end
      end else begin
        clr_r <= 0;
      end
    end

  assign temp_mm_readdata = {7'b0000000, readdata_r};
  assign clr = clr_r;

  assign fan = fan_r;
  assign fan_n = ~fan_r;

endmodule
