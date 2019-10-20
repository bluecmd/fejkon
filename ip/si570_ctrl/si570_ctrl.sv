`timescale 1 ps / 1 ps
module si570_ctrl #(
    parameter InputClock      = 50000000,
    parameter RecallFrequency = 100000000,
    parameter TargetFrequency = 125000000,
    parameter I2CAddress      = 0
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

  always @* begin
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
    orig_n1 = raw_n1[0] ? raw_n1 + 1 : raw_n1;
    // No conversion on this one
    orig_rfreq = raw_rfreq;
  end

  logic [61:0] fxtal;

  always @* begin
    orig_fdco = RecallFrequency * orig_hs_div * orig_n1;
    fxtal = {orig_fdco, 28'b0}  / {24'b0, orig_rfreq};
  end

  logic [3:0]  new_hs_div = 4;
  logic [6:0]  new_n1 = 0;
  logic [61:0] new_rfreq = 0;

  logic [2:0]  out_hs_div;
  logic [6:0]  out_n1;
  logic [37:0] out_rfreq;

  always @* begin
    // Map from datasheet
    case (new_hs_div)
      4:  out_hs_div = 0;
      5:  out_hs_div = 1;
      6:  out_hs_div = 2;
      7:  out_hs_div = 3;
      9:  out_hs_div = 5;
      11: out_hs_div = 7;
      default: out_hs_div = 0; // Invalid
    endcase
    out_n1 = new_n1 - 1;
    out_rfreq = new_rfreq[37:0];
  end

  assign reset_out = reset_out_r;

  logic fxtal_stable = 0;
  logic config_valid;
  logic fdco_too_low;
  logic fdco_too_high;
  logic [33:0] new_fdco;

  assign new_fdco = new_hs_div * new_n1 * TargetFrequency;
  assign fdco_too_low = new_fdco < 34'd4850000000;
  assign fdco_too_high = new_fdco > 34'd5670000000;
  assign config_valid = ~fdco_too_high && ~fdco_too_low;

  always @(posedge clk) begin
    if (reset) begin
      new_hs_div <= 4;
      new_n1 <= 0;
    end else if (fxtal_stable && ~config_valid) begin
      // Scan through possible configurations until a good one is found
      new_n1 <= new_n1 + 1;
      if (new_n1 == 7'd127 || fdco_too_high) begin
        new_n1 <= 0;
        case (new_hs_div)
          4: new_hs_div <= 5;
          5: new_hs_div <= 6;
          6: new_hs_div <= 7;
          7: new_hs_div <= 9;
          9: new_hs_div <= 11;
          default: ; // No config was valid, lock up
        endcase
      end
    end
  end

  always @* begin
    new_rfreq = {new_fdco, 28'b0} / fxtal;
  end

  int instr = 0, instr_next;

  always @* begin
    // Advance if I2C is marked as done and we are not computing configuration
    if (instr == 7)
      instr_next = config_valid ? instr + 1 : instr;
    else
      instr_next = bus.done ? instr + 1 : instr;
  end

  always @(posedge clk) begin
    if (reset || startup) begin
      instr <= 0;
      startup <= 0;
      fxtal_stable <= 0;
      reset_out_r <= 1'b1;
      si570_bus_reset(bus);
    end else begin
      case (instr_next)
        0: si570_bus_write(bus, 135, 8'h01); // Recall factory settings
        1: {raw_hs_div, raw_n1[6:2]} <= si570_bus_read(bus, 7);
        2: {raw_n1[1:0], raw_rfreq[37:32]} <= si570_bus_read(bus, 8);
        3: raw_rfreq[31:24] <= si570_bus_read(bus, 9);
        4: raw_rfreq[23:16] <= si570_bus_read(bus, 10);
        5: raw_rfreq[15:8]  <= si570_bus_read(bus, 11);
        6: raw_rfreq[7:0]   <= si570_bus_read(bus, 12);
        7: fxtal_stable <= 1;
        8: si570_bus_write(bus, 137, 8'h10); // Freeze DCO
        9: si570_bus_write(bus, 7, {out_hs_div, out_n1[6:2]});
        10: si570_bus_write(bus, 8, {out_n1[1:0], out_rfreq[37:32]});
        11: si570_bus_write(bus, 9, out_rfreq[31:24]);
        12: si570_bus_write(bus, 10, out_rfreq[23:16]);
        13: si570_bus_write(bus, 11, out_rfreq[15:8]);
        14: si570_bus_write(bus, 12, out_rfreq[7:0]);
        15: si570_bus_write(bus, 137, 8'h0); // Unfreeze DCO
        16: si570_bus_write(bus, 135, 8'h40); // Assert NewFreq
        default: begin
          reset_out_r <= 1'b0;
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
