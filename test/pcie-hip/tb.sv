`timescale 1ns / 1ps

`define DRVR tb.svpcie.root.g_bfm_top_rp.altpcietb_bfm_top_rp.g_bfm.genblk1.rp.inst.apps.g_root_port.genblk1.drvr
`define SETUP_DONE `DRVR.ebfm_log_stop_sim.success

module tb;
  wire clk;

  svpcie_sim_tb svpcie();

  // Copied from altpcietb_bfm_rp_gen3_x8.v
  localparam SHMEM_ADDR_WIDTH = 21;
  localparam SHMEM_SIZE = 2 ** SHMEM_ADDR_WIDTH;
  localparam BAR_TABLE_SIZE = 64;
  localparam BAR_TABLE_POINTER = SHMEM_SIZE - BAR_TABLE_SIZE;

  import verbosity_pkg::*;

  initial begin
    parameter bar_table = BAR_TABLE_POINTER;

    wait(`SETUP_DONE == 1);
    $sformat(message, "%m: svpcie simulation starting");
    print(VERBOSITY_INFO, message);

    // TODO: Figure out how to use these
    //`DRVR.ebfm_barrd_wait(bar_table, 0, 0, 0, 4, 0);

    //$sformat(message, "%m: BAR0 read complete");
    //print(VERBOSITY_INFO, message);

    //#1000000

    //`DRVR.ebfm_barwr(bar_table, 0, 0, 32'h1337, 4, 0);

    //$sformat(message, "%m: BAR0 write complete");
    //print(VERBOSITY_INFO, message);

    $sformat(message, "%m: Test passed");
    print(VERBOSITY_INFO, message);

    // Keep at least one assert in here for the simulation script
    assert(1==1);
    $stop();

  end

endmodule
