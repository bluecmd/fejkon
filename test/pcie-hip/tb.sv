`timescale 1ns / 1ps

`define DRVR tb.svpcie.root.g_bfm_top_rp.altpcietb_bfm_top_rp.g_bfm.genblk1.rp.inst.apps.g_root_port.genblk1.drvr
`define SETUP_DONE `DRVR.ebfm_log_stop_sim.success
`define PCIE_DATA tb.svpcie.fejkon_pcie_data


module tb;
  wire clk;

  svpcie_sim_tb svpcie();

  `include "./gen/simulation/submodules/altpcietb_g3bfm_constants.v"
  // Copied from altpcietb_bfm_rp_gen3_x8.v
  localparam SHMEM_SIZE = 2 ** SHMEM_ADDR_WIDTH;
  localparam BAR_TABLE_SIZE = 64;
  localparam BAR_TABLE_POINTER = SHMEM_SIZE - BAR_TABLE_SIZE;

  import verbosity_pkg::*;

  task barwrite32 (
    input integer bar_addr,
    input logic [31:0] data
    );
    begin
      `DRVR.shmem_write(0, data, 4);
      `DRVR.ebfm_barwr(
        BAR_TABLE_POINTER,
        0 /* bar num */,
        bar_addr,
        0 /* shmem_addr */,
        4 /* length */,
        0 /* tclass */);
    end
  endtask

  task barread32 (
    input integer bar_addr,
    output logic [31:0] data
    );
    begin
      `DRVR.ebfm_barrd_wait(
        BAR_TABLE_POINTER,
        0 /* bar num */,
        bar_addr,
        4 /* shmem_addr */,
        4 /* length */,
        0 /* tclass */);
      data = `DRVR.shmem_read(4, 4)[31:0];
    end
  endtask

  initial begin
    logic [31:0] res;

    wait(`SETUP_DONE == 1);
    $sformat(message, "%m: svpcie simulation starting");
    print(VERBOSITY_INFO, message);

    // Test that unaligned operations are marked as unsupported requests (UR).
    barwrite32(14, 32'h1337);
    wait(`PCIE_DATA.cpl_err_ur_p == 1);
    assert(`PCIE_DATA.cpl_err_ur_np == 0);
    `DRVR.ebfm_barrd_nowt(
      BAR_TABLE_POINTER, 0 /* bar num */, 14 /* bar addr */,
      4 /* shmem addr */, 4 /* length */, 0 /* tclass */);
    wait(`PCIE_DATA.cpl_err_ur_np == 1);
    assert(`PCIE_DATA.cpl_err_ur_p == 0);
    $sformat(message, "%m: Invalid BAR read/write marked as UR (success!)");
    print(VERBOSITY_INFO, message);

    // Test that read/write still works in the end
    barwrite32(512, 32'hdeadbeef);
    barread32(512, res);
    assert(res == 32'hdeadbeef);
    $sformat(message, "%m: BAR0 read test passed");
    print(VERBOSITY_INFO, message);

    $sformat(message, "%m: Test passed");
    print(VERBOSITY_INFO, message);

    // Keep at least one assert in here for the simulation script
    assert(1==1);
    $stop();

  end

endmodule
