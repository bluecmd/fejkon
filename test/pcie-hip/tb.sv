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

  task flush;
    begin
      logic [31:0] res;
      // Normally these things are what a zero-length read is for, but it
      // seems the BFM is behaving pretty strangely when using barrd_wait
      // without using the value for something - possibly being optimized
      // away?
      barwrite32(512, 32'hdeadbeef);
      barread32(512, res);
      assert(res == 32'hdeadbeef);
    end
  endtask

  initial begin
    logic [31:0] res;

    wait(`SETUP_DONE == 1);
    $sformat(message, "%m: svpcie simulation starting");
    print(VERBOSITY_INFO, message);

    // NOTE: It seems the Intel/Altera PCIe BFM does not do zero-length reads,
    // or we would have tried them here.

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

    // Stress test 31 pending reads to test all tags.
    // It seems the PCIe BFM does not handle sending more than 32 out at the
    // same time, which is understandable. We should not hit this in real
    // usage anyway = but if we do we might have to do fancier signaling back
    // to the PCIe core, as right now we are likely to just drop things at the
    // floor if the memory request FIFO runs full. See TODOs in
    // fejkon_pcie_data for more info.
    for (int i = 0; i < 31; i++)
    begin
      barwrite32(i * 4, i * 4);
    end

    // Flush
    flush();

    for (int i = 0; i < 31; i++)
    begin
      `DRVR.ebfm_barrd_nowt(
        BAR_TABLE_POINTER, 0 /* bar num */, i * 4 /* bar addr */,
        1024 + i * 4 /* shmem addr */, 4 /* length */, 0 /* tclass */);
    end

    // Do a blocking read to wait for all completions.
    // (This is the 32rd tag)
    flush();

    for (int i = 0; i < 31; i++)
    begin
      res = `DRVR.shmem_read(1024 + i * 4 /* addr */, 4 /* length */)[31:0];
      if (res != (i * 4)) begin
        $sformat(message, "%m: BAR0 read stress test failed @ %x: %d != %d",
          i * 4, i * 4, res);
        print(VERBOSITY_INFO, message);
      end
      assert(res == (i * 4));
    end

    // Test that read/write still works in the end
    flush();
    $sformat(message, "%m: BAR0 read stress test passed");
    print(VERBOSITY_INFO, message);

    $sformat(message, "%m: Test passed");
    print(VERBOSITY_INFO, message);

    // Keep at least one assert in here for the simulation script
    assert(1==1);
    $stop();

  end

endmodule
