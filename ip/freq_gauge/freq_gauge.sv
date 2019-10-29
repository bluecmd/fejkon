module freq_gauge #(
    parameter ReferenceClock = 50000000
  ) (
    input wire         reset,
    input wire         ref_clk,
    input wire         probe_clk,
    output wire [31:0] mm_readdata
  );

  // The measurement is a tick/tock process where every 10 ms
  // a new measurement is done, and then 1 ms is spent on processing
  // the result.
  // The reason why a full 1 ms (eternity!) is spent on this is making the
  // clock-domain crossing super-simple.

  localparam MeasurementTime = ReferenceClock / 100;
  localparam ProcessingTime = ReferenceClock / 1000;

  int countdown = MeasurementTime;

  logic measure = 1;
  logic measure_cdc1 = 0;
  logic measure_cdc2 = 0;
  logic probe_measure = 0;

  logic process;
  assign process = ~measure;

  logic [31:0] counter = 0;
  logic [31:0] counter_cdc1;
  logic [31:0] counter_cdc2;
  logic [31:0] xfered_counter;
  logic [31:0] last_count = -1;

  // Reset synchronizer
  logic reset_probe_r0 = 0;
  logic reset_probe = 0;

  logic reset_ref_r0 = 0;
  logic reset_ref = 0;

  always @(posedge ref_clk) begin
    reset_ref_r0 <= reset;
    reset_ref <= reset_ref_r0;
  end

  always @(posedge probe_clk) begin
    reset_probe_r0 <= reset;
    reset_probe <= reset_probe_r0;
  end

  always @(posedge ref_clk) begin
    if (reset_ref) begin
      countdown <= MeasurementTime;
      measure <= 1;
      last_count <= -1;
    end else begin
      if (countdown == 0) begin
        measure <= ~measure;
        countdown <= measure ? ProcessingTime : MeasurementTime;
        if (process)
          last_count <= xfered_counter * 100;
      end else begin
        countdown <= countdown - 1;
      end
    end
  end

  // Measure signal CDC transfer (ref_clk -> probe_clk)
  always @(posedge probe_clk) begin
    measure_cdc1 <= measure;
    measure_cdc2 <= measure_cdc1;
    probe_measure <= measure_cdc2;
  end

  // Counter CDC transfer (probe_clk -> ref_clk)
  // During processing stage the counter will be mostly stable
  always @(posedge ref_clk) begin
    if (process) begin
      counter_cdc1 <= counter;
      counter_cdc2 <= counter_cdc1;
      xfered_counter <= counter_cdc2;
    end
  end

  logic probe_measure_r = 0;

  always @(posedge probe_clk) begin
    if (reset_probe) begin
      counter <= 0;
      probe_measure_r <= 0;
    end else begin
      if (probe_measure & ~probe_measure_r) begin
        counter <= 0;
      end else if (probe_measure) begin
        counter <= counter + 1;
      end
      probe_measure_r <= probe_measure;
    end
  end

  assign mm_readdata = last_count;

 endmodule
