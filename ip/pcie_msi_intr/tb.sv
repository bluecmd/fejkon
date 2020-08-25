module tb;

  logic [4:0]  app_msi_num;
  logic        app_msi_req;
  logic        app_msi_ack;
  logic        clk;
  logic        reset;
  logic [7:0]  irq;

  initial begin
    $from_myhdl(clk, reset, irq, app_msi_ack);
    $to_myhdl(app_msi_num, app_msi_req);
  end

  pcie_msi_intr dut(
    .app_int_sts(),
    .app_msi_num(app_msi_num),
    .app_msi_req(app_msi_req),
    .app_msi_tc(),
    .app_int_ack(1'b0),
    .app_msi_ack(app_msi_ack),
    .clk(clk),
    .reset(reset),
    .irq(irq));

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, tb);
  end
endmodule
