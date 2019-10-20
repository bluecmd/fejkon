`timescale 1ns / 1ps
module top_tb;
  logic clk;
  logic reset;
  logic sda_oe = 1'b0;
  wire sda;
  wire scl;

  si570_ctrl #(
    .InputClock(10000000),
    .TargetFrequency(161132812),
    .RecallFrequency(156250000),
    .I2CAddress('h7f)
  ) dut (
    .clk(clk),
    .reset(reset),
    .reset_out(),
    .sda(sda),
    .scl(scl)
  );

  // 10 MHz clock
  initial begin
    clk = 1'b0;
    forever #50 clk = ~clk;
  end

  // Si570 internal register models
  logic [7:0] regs[integer];

  initial begin
    // Settings from an example in the datasheet
    regs[7] = {3'b000, 5'h1};
    regs[8] = {2'h3, 6'h2};
    regs[9] = 8'hbc;
    regs[10] = 8'h01;
    regs[11] = 8'h1e;
    regs[12] = 8'hb8;
    regs[135] = 8'bxxxxxxxx;
    regs[137] = 8'bxxxxxxxx;
  end

  initial begin
    // Values taken from example from datasheet
    wait(dut.fxtal_stable);
    assert(dut.orig_hs_div == 'd4);
    assert(dut.orig_n1 == 'd8);
    assert(dut.orig_rfreq == 'h2bc011eb8);
    wait(dut.config_valid);
    #20
    assert(dut.new_hs_div == 'd4);
    assert(dut.new_n1 == 'd8);
    assert(dut.new_rfreq == 'h2d1e12788);
    wait(dut.reset_out == 0);
    assert(regs[7] == 'h01);
    assert(regs[8] == 'hc2);
    assert(regs[9] == 'hd1);
    assert(regs[10] == 'he1);
    assert(regs[11] == 'h27);
    assert(regs[12] == 'h88);
    assert(regs[135] == 'h40);
    $display("If no asserts triggered, then eveything is good!");
    #2000
    $stop();
  end

  // The IP should work without reset as well
  // assign reset = 1'b0;
  initial begin
    reset = 1'b1;
    #2000
    reset = 1'b0;
  end

  assign sda = sda_oe ? 1'b0 : 1'bz;

  int cntr = -1;
  string section;
  logic detect;
  // These are the 1-bit counters that reset the bit counter.
  // If they are different we have passed by a STOP condition.
  logic detect_flip_flop = 1'b0;
  logic cntr_flip_flop = 1'b1;
  logic writing;
  logic [7:0] data;
  logic [7:0] data_stable;
  logic [7:0] data_out = 8'h55;

  // I2C frame counter
  always @(edge sda) begin
    if (scl && ~reset) begin
      // Detect start and stop condition
      detect <= ~sda;
      // Mark a new transaction when we see START
      if (~sda)
        detect_flip_flop = ~detect_flip_flop;
      if (~sda && ~reset)
        $info("I2C START");
      else
        $info("I2C STOP");
    end
  end

  always @(negedge dut.scl_o or reset) begin
    if (reset) begin
      cntr <= -1;
    end else if (~dut.scl_o) begin
      if (cntr_flip_flop != detect_flip_flop) begin
        cntr <= 0;
        cntr_flip_flop = detect_flip_flop;
      end else begin
        cntr <= cntr + 1;
      end
    end
  end

  // Drive on negative edge
  always @(negedge dut.scl_o) begin
    sda_oe <= 1'b0;
    if (cntr == 7) begin
      sda_oe <= 1'b1; // Ack device presence
    end else if (~writing && (cntr > 7 && cntr < 16)) begin
      sda_oe <= ~data_out[7 - (cntr - 8)];
    end else if (writing && cntr == 16) begin
      sda_oe <= 1'b1; // Ack register select byte
    end else if (~writing && cntr == 16) begin
      $display("Read: 0x%02x", data_out);
    end else if (writing && cntr == 25) begin
      sda_oe <= 1'b1; // Ack data byte
    end
  end

  // Read on positive edge (cntr is +1 from negedge)
  always @(posedge dut.scl_o) begin
    if (cntr == 7) begin
      writing <= ~dut.sda_o;
    end else if (writing && (cntr > 8 && cntr < 17)) begin
      data[7 - (cntr - 9)] <= sda;
    end else if (writing && cntr == 17) begin
      data_stable <= data;
      data_out <= regs[data];
      $display("Select register %d", data);
    end else if (writing && (cntr > 17 && cntr < 26)) begin
      data[7 - (cntr - 18)] <= sda;
    end else if (writing && cntr == 26) begin
      data_stable <= data;
      regs[data_stable] = data;
      $display("Wrote data 0x%02x", data);
    end
  end

  always @* begin
    case (cntr)
      -1: section <= "Reset      ";
      0: section  <= "Address    ";
      7: section  <= "Read/Write ";
      8: section  <= "ACK        ";
      9: section  <= "Register   ";
      17: section <= "ACK        ";
      18: section <= "Data       ";
      // We only expect two operations per I2C activity
      26: section <= "ACK        ";
      27: section <= "STOP       ";
      28: begin
        section <= "--INVALID--";
        $error("Reached unknown I2C section");
      end
      default: section <= section;
    endcase
  end
endmodule
