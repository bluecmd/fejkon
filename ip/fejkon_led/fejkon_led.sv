`timescale 1 ps / 1 ps
module fejkon_led #(
    parameter ReferenceClock = 50000000
  ) (
    input  wire       clk,             //           clk.clk
    input  wire       fcport0_aligned, //       fcport0.aligned
    input  wire       fcport0_active,  //              .active
    input  wire       fcport1_active,  //       fcport1.active
    input  wire       fcport1_aligned, //              .aligned
    input  wire       fcport2_aligned, //       fcport2.aligned
    input  wire       fcport2_active,  //              .active
    input  wire       fcport3_active,  //       fcport3.active
    input  wire       fcport3_aligned, //              .aligned
    input  wire       reconfig_busy,   // xcvr_reconfig.reconfig_busy
    output wire [3:0] led_bracket,     //          leds.led_bracket
    output wire [1:0] led_rj45,        //              .led_rj45
    output wire [3:0] led_board        //              .led_board
  );

  assign led_bracket[0] = ~fcport0_active;
  assign led_board[0] = ~fcport0_aligned;
  assign led_bracket[1] = ~fcport1_active;
  assign led_board[1] = ~fcport1_aligned;
  assign led_bracket[2] = ~fcport2_active;
  assign led_board[2] = ~fcport2_aligned;
  assign led_bracket[3] = ~fcport3_active;
  assign led_board[3] = ~fcport3_aligned;

  assign led_rj45[0] = ~reconfig_busy;
  assign led_rj45[1] = 1'b1;

endmodule
