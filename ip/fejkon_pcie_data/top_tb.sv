`timescale 1 ps / 1 ps
module top_tb;

  tb_tb tb();

  import verbosity_pkg::*;

  initial begin
    set_verbosity(VERBOSITY_INFO);
    #100000000
    $sformat(message, "%m: Test passed");
    print(VERBOSITY_INFO, message);
    // Run one 1 us more for more wave data
    #1000000
    // Keep at least one assert in here for the simulation script
    assert(1==1);
    $stop();
  end

endmodule
