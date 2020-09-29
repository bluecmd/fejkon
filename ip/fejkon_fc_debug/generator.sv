module generator (
    input  wire         clk,
    input  wire         reset,
    output wire [1:0]   st_out_channel,
    output wire [255:0] st_out_data,
    output wire         st_out_endofpacket,
    output wire         st_out_startofpacket,
    output wire         st_out_valid,
    input  wire         st_out_ready,
    output wire [4:0]   st_out_empty
  );

  logic [1:0]   gen_channel = 0;
  logic [255:0] gen_data = 0;
  logic         gen_endofpacket = 0;
  logic         gen_startofpacket = 0;
  logic         gen_valid = 0;
  logic [4:0]   gen_empty = 0;

  int gen_idx = 0;

  always_ff @(posedge clk) begin: gen_driver
    if (reset) begin
      gen_valid <= 0;
      gen_idx = 0;
    end else begin
      if (st_out_ready) begin
        gen_idx = gen_idx + 1;
        if (gen_idx == 2) begin
          gen_idx = 0;
        end
      end
      gen_valid <= 1'b1;
      gen_channel <= 2'h0;
      gen_empty <= 5'd0;
      gen_startofpacket <= 1'b0;
      gen_endofpacket <= 1'b0;
      if (gen_idx == 0) begin
        gen_data <= 256'hbcb5565605060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1fff;
        gen_startofpacket <= 1'b1;
      end else if (gen_idx == 1) begin
        gen_data <= 256'hbaadc0debaadc0debaadc0debaadc0debaadc0debaadc0debaadc0debc95d5d5;
        gen_endofpacket <= 1'b1;
      end
    end
  end

  assign st_out_valid = gen_valid;
  assign st_out_data = gen_data;
  assign st_out_channel = gen_channel;
  assign st_out_startofpacket = gen_startofpacket;
  assign st_out_endofpacket = gen_endofpacket;
  assign st_out_empty = gen_empty;

endmodule
