`timescale 1 ps / 1 ps
module tl_cfg_module (
    input  wire         clk,
    input  wire         reset,
    input  wire [3:0]   tl_cfg_add,
    input  wire [31:0]  tl_cfg_ctl,
    input  wire [52:0]  tl_cfg_sts,
    output wire [15:0]  my_id,
    output wire         my_id_valid
  );

  logic [7:0] cfg_bus = 0;
  logic [4:0] cfg_dev = 0;
  logic       cfg_bus_valid = 0;
  logic       cfg_dev_valid = 0;

  // Bus Number[7:0] Device Number[4:0] Function Number[2:0]
  // E.g. in linux this may look like b3:00.0
  assign my_id = {cfg_bus, cfg_dev, 3'h0};
  assign my_id_valid = cfg_bus_valid & cfg_dev_valid;

  logic [31:0] curr_data = 0;
  logic [3:0]  curr_address = 0;

  // Note from datasheet:
  // "To ensure correct values are captured, your Application RTL must
  // include code to force sampling to the middle of this window".
  // This is why we have a bit complicated strobe logic.
  logic tl_cfg_add_reg = 0;
  logic tl_cfg_add_reg2 = 0;

  always_ff @(posedge clk) begin
    tl_cfg_add_reg <= tl_cfg_add[0];
    tl_cfg_add_reg2 <= tl_cfg_add_reg;
  end

  logic cfgctl_addr_change;
  logic cfgctl_addr_change2;
  logic capture_config_strobe;

  always_ff @(posedge clk) begin
    cfgctl_addr_change <= tl_cfg_add_reg2 != tl_cfg_add_reg;
    cfgctl_addr_change2 <= cfgctl_addr_change;
    capture_config_strobe <= cfgctl_addr_change2;
  end

  always_ff @(posedge clk) begin
    // This should happen every 8 clock cycles according to the datasheet.
    // tl_cfg_* cycles through all addresses, so this is basically a game
    // of capturing the values we want.
    if (capture_config_strobe) begin
      curr_data <= tl_cfg_ctl;
      curr_address <= tl_cfg_add;
    end
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      cfg_bus <= 0;
      cfg_dev <= 0;
      {cfg_bus_valid, cfg_dev_valid} <= 2'b00;
    end else begin
      if (curr_address == 4'hF) begin
        {cfg_bus, cfg_dev} <= curr_data[12:0];
        {cfg_bus_valid, cfg_dev_valid} <= 2'b11;
      end
    end
  end
endmodule
