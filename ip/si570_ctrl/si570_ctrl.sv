`timescale 1 ps / 1 ps
module si570_ctrl #(
    parameter int          InputClock      = 50000000,
    parameter int          RecallFrequency = 100000000,
    parameter int          TargetFrequency = 125000000,
    parameter logic [7:0]  I2CAddress      = '0
  ) (
    input  wire  clk,       //       clk.clk
    input  wire  reset,     //     reset.reset
    output wire  reset_out, // reset_out.reset
    inout  tri1  sda,       // si570_i2c.sda
    inout  tri1  scl        //          .scl
  );

  import i2c_util::*;

  wire scl_i;
  wire scl_o;
  wire scl_t;
  wire sda_i;
  wire sda_o;
  wire sda_t;

  i2c_bus_t bus;

  logic reset_out_r = 1'b1;
  logic startup = 1'b1;

  i2c_master i2c (
    .clk(clk),
    .rst(reset),
    .cmd_address(I2CAddress[6:0]),
    .cmd_start(bus.start),
    .cmd_read(bus.read),
    .cmd_write(bus.write),
    .cmd_write_multiple(bus.write_multiple),
    .cmd_stop(bus.stop),
    .cmd_valid(bus.valid & ~startup),
    .cmd_ready(bus.ready),
    .data_in(bus.data_in),
    .data_in_valid(bus.data_in_valid),
    .data_in_ready(bus.data_in_ready),
    .data_in_last(bus.data_in_last),
    .data_out(bus.data_out),
    .data_out_valid(bus.data_out_valid),
    .data_out_ready(1'b1),
    .data_out_last(),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_t(scl_t),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_t(sda_t),
    .busy(),
    .bus_control(),
    .bus_active(),
    .missed_ack(bus.missed_ack),
    .prescale(InputClock / (400000*4)),
    .stop_on_idle(1'b0)
  );

  logic [2:0]  raw_hs_div;
  logic [6:0]  raw_n1;
  logic [37:0] raw_rfreq;

  logic [3:0]  orig_hs_div;
  logic [6:0]  orig_n1;
  logic [37:0] orig_rfreq;
  logic [33:0] orig_fdco;

  always_comb begin
    // Map from datasheet
    case (raw_hs_div)
      0: orig_hs_div = 4;
      1: orig_hs_div = 5;
      2: orig_hs_div = 6;
      3: orig_hs_div = 7;
      5: orig_hs_div = 9;
      7: orig_hs_div = 11;
      default: orig_hs_div = 0; // Invalid
    endcase
    // According to datasheet, round upwards to nearest even number
    orig_n1 = raw_n1[0] ? raw_n1 + 7'd1 : raw_n1;
    // No conversion on this one
    orig_rfreq = raw_rfreq;
  end

  logic [61:0] fxtal;

  always_comb begin
    orig_fdco = RecallFrequency * orig_hs_div * orig_n1;
  end

  logic [3:0]  new_hs_div = 4;
  logic [6:0]  new_n1 = 0;
  logic [61:0] new_rfreq = 0;

  logic [2:0]  out_hs_div;
  logic [6:0]  out_n1;
  logic [37:0] out_rfreq;

  always_comb begin
    // Map from datasheet
    case (new_hs_div)
      4'd4:  out_hs_div = 3'd0;
      4'd5:  out_hs_div = 3'd1;
      4'd6:  out_hs_div = 3'd2;
      4'd7:  out_hs_div = 3'd3;
      4'd9:  out_hs_div = 3'd5;
      4'd11: out_hs_div = 3'd7;
      default: out_hs_div = '0; // Invalid (TODO: Add assert)
    endcase
    out_n1 = new_n1 - 7'd1;
    out_rfreq = new_rfreq[37:0];
  end

  assign reset_out = reset_out_r;

  logic calc_fxtal = '0;
  logic fxtal_valid = '0;
  logic calc_new_rfreq = '0;
  logic new_rfreq_valid = '0;
  logic config_valid;
  logic fdco_too_low;
  logic fdco_too_high;
  logic [33:0] new_fdco;

  assign new_fdco = new_hs_div * new_n1 * TargetFrequency;
  assign fdco_too_low = new_fdco < 34'd4850000000;
  assign fdco_too_high = new_fdco > 34'd5670000000;
  assign config_valid = fxtal_valid && ~fdco_too_high && ~fdco_too_low;

  always_ff @(posedge clk) begin
    if (reset) begin
      new_hs_div <= 4'd4;
      new_n1 <= '0;
    end else if (fxtal_valid && ~config_valid) begin
      // Scan through possible configurations until a good one is found
      new_n1 <= new_n1 + 7'd1;
      if (new_n1 == 7'd127 || fdco_too_high) begin
        new_n1 <= '0;
        case (new_hs_div)
          4'd4: new_hs_div <= 4'd5;
          4'd5: new_hs_div <= 4'd6;
          4'd6: new_hs_div <= 4'd7;
          4'd7: new_hs_div <= 4'd9;
          4'd9: new_hs_div <= 4'd11;
          default: ; // No config was valid, lock up
        endcase
      end
    end
  end

  logic [61:0] fxtal_div_q;

  divider fxtal_div (
    .clock(clk),
    .numer({orig_fdco, 28'b0}),
    .denom({24'b0, orig_rfreq}),
    .quotient(fxtal_div_q),
    .remain()
  );

  logic [61:0] new_rfreq_div_q;

  divider new_rfreq_div (
    .clock(clk),
    .numer({new_fdco, 28'b0}),
    .denom(fxtal),
    .quotient(new_rfreq_div_q),
    .remain()
  );

  logic [7:0] div_delay_cntr = '0;
  always_ff @(posedge clk) begin
    // Handle the division latency of 62 clock cycles
    if (reset || startup) begin
      fxtal_valid <= '0;
      new_rfreq_valid <= '0;
      div_delay_cntr <= '0;
    end else if (calc_new_rfreq) begin
      if (~new_rfreq_valid)
        div_delay_cntr <= div_delay_cntr + 8'd1;
      if (div_delay_cntr > 8'd61) begin
        new_rfreq <= new_rfreq_div_q;
        new_rfreq_valid <= '1;
        div_delay_cntr <= '0;
      end
    end else if (calc_fxtal) begin
      if (~fxtal_valid)
        div_delay_cntr <= div_delay_cntr + 8'd1;
      if (div_delay_cntr > 8'd61) begin
        fxtal <= fxtal_div_q;
        fxtal_valid <= '1;
        div_delay_cntr <= '0;
      end
    end
  end

  // The Si570 datasheets says it can take 10 ms to power up the unit
  localparam logic [31:0] PowerUpCycles = InputClock / 100;
  logic [31:0] power_up_cntr = PowerUpCycles;

  always_ff @(posedge clk) begin
    if (reset) begin
      power_up_cntr <= PowerUpCycles;
    end else begin
      power_up_cntr <= power_up_cntr - 32'd1;
    end
  end

  logic powered_up;
  assign powered_up = power_up_cntr == '0;

  logic [4:0] instr = '0, instr_next;

  always_comb begin
    // Advance if I2C is marked as done and we are not computing configuration
    if (instr == '0)
      instr_next = powered_up ? instr + 5'd1 : instr;
    else if (instr == 5'd8)
      instr_next = config_valid ? instr + 5'd1 : instr;
    else if (instr == 5'd9)
      instr_next = new_rfreq_valid ? instr + 5'd1 : instr;
    else
      instr_next = bus.done ? instr + 5'd1 : instr;
  end

  always_ff @(posedge clk) begin
    if (reset || startup) begin
      instr <= '0;
      startup <= '0;
      calc_fxtal <= '0;
      calc_new_rfreq <= '0;
      reset_out_r <= 1'b1;
      si570_bus_reset(bus);
    end else begin
      calc_fxtal <= '0;
      calc_new_rfreq <= '0;
      case (instr_next)
        5'd0: ; // Wait for bootup
        5'd1: si570_bus_write(bus, 8'd135, 8'h01); // Recall factory settings
        5'd2: {raw_hs_div, raw_n1[6:2]} <= si570_bus_read(bus, 8'd7);
        5'd3: {raw_n1[1:0], raw_rfreq[37:32]} <= si570_bus_read(bus, 8'd8);
        5'd4: raw_rfreq[31:24] <= si570_bus_read(bus, 8'd9);
        5'd5: raw_rfreq[23:16] <= si570_bus_read(bus, 8'd10);
        5'd6: raw_rfreq[15:8]  <= si570_bus_read(bus, 8'd11);
        5'd7: raw_rfreq[7:0]   <= si570_bus_read(bus, 8'd12);
        5'd8: calc_fxtal <= '1;
        5'd9: calc_new_rfreq <= '1;
        5'd10: si570_bus_write(bus, 8'd137, 8'h10); // Freeze DCO
        5'd11: si570_bus_write(bus, 8'd7, {out_hs_div, out_n1[6:2]});
        5'd12: si570_bus_write(bus, 8'd8, {out_n1[1:0], out_rfreq[37:32]});
        5'd13: si570_bus_write(bus, 8'd9, out_rfreq[31:24]);
        5'd14: si570_bus_write(bus, 8'd10, out_rfreq[23:16]);
        5'd15: si570_bus_write(bus, 8'd11, out_rfreq[15:8]);
        5'd16: si570_bus_write(bus, 8'd12, out_rfreq[7:0]);
        5'd17: si570_bus_write(bus, 8'd137, 8'h0); // Unfreeze DCO
        5'd18: si570_bus_write(bus, 8'd135, 8'h40); // Assert NewFreq
        default: begin
          reset_out_r <= '0;
          si570_bus_reset(bus);
        end
      endcase
      instr <= instr_next;
    end
  end

  // I2C tri-state bus driver
  assign scl_i = scl;
  assign sda_i = sda;
  assign scl = scl_t ? 1'bz : scl_o;
  assign sda = sda_t ? 1'bz : sda_o;

endmodule
