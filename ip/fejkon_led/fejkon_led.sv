`timescale 1 ps / 1 ps
module fejkon_led #(
    parameter ReferenceClock = 50000000
  ) (
    input  wire       clk,             //           clk.clk
    input  wire       fcport0_aligned, //       fcport0.aligned
    input  wire       fcport0_active,  //              .active
    input  wire       fcport1_aligned, //              .aligned
    input  wire       fcport1_active,  //       fcport1.active
    input  wire       fcport2_aligned, //       fcport2.aligned
    input  wire       fcport2_active,  //              .active
    input  wire       fcport3_aligned, //              .aligned
    input  wire       fcport3_active,  //       fcport3.active
    input  wire       reconfig_busy,   // xcvr_reconfig.reconfig_busy
    output wire [3:0] led_bracket,     //          leds.led_bracket
    output wire [1:0] led_rj45,        //              .led_rj45
    output wire [3:0] led_board        //              .led_board
  );

  logic [7:0] in_cdc1 = 8'b0;
  logic [7:0] in = 8'b0;

  always_ff @(posedge clk) begin
    in_cdc1[0] <= fcport0_aligned;
    in_cdc1[1] <= fcport1_aligned;
    in_cdc1[2] <= fcport2_aligned;
    in_cdc1[3] <= fcport3_aligned;
    in_cdc1[4] <= fcport0_active;
    in_cdc1[5] <= fcport1_active;
    in_cdc1[6] <= fcport2_active;
    in_cdc1[7] <= fcport3_active;
    in <= in_cdc1;
  end

  logic [7:0] flap;
  logic [7:0] led = 8'b0;

  // Require the signal to be stable for 500 ms
  localparam Cooloff = ReferenceClock / 2;

  // Blink in 100 Hz
  localparam BlinkHz = ReferenceClock / 10;
  logic blink = 1;

  flap_detect #(
    .Cooloff(Cooloff)
  ) flap_detect [7:0] (
    .clk(clk),
    .in(in),
    .flap(flap)
  );

  always_ff @(posedge clk) begin
    led[0] <= flap[0] ? blink : in[0];
    led[1] <= flap[1] ? blink : in[1];
    led[2] <= flap[2] ? blink : in[2];
    led[3] <= flap[3] ? blink : in[3];
    led[4] <= flap[4] ? blink : in[4];
    led[5] <= flap[5] ? blink : in[5];
    led[6] <= flap[6] ? blink : in[6];
    led[7] <= flap[7] ? blink : in[7];
  end

  int blinker = BlinkHz;

  always_ff @(posedge clk) begin
    if (blinker == 0) begin
      blink <= ~blink;
      blinker <= BlinkHz;
    end else
      blinker <= blinker - 1;
  end

  assign led_board[0]   = ~led[0];
  assign led_board[1]   = ~led[1];
  assign led_board[2]   = ~led[2];
  assign led_board[3]   = ~led[3];
  assign led_bracket[0] = ~led[4];
  assign led_bracket[1] = ~led[5];
  assign led_bracket[2] = ~led[6];
  assign led_bracket[3] = ~led[7];

  assign led_rj45[0] = ~reconfig_busy;
  assign led_rj45[1] = 1'b1;

endmodule
