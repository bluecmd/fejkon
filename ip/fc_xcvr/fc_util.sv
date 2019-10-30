package fc_util;

  function bit [7:0] D(input int X, input int Y);
    return {Y[2:0], X[4:0]};
  endfunction

  // NOTE: Reverse bit order
  const logic [31:0] IDLE =  {D(28,5), D(21,4), D(21,5), D(21,5)};
  const logic [31:0] SOFI3 = {D(28,5), D(21,5), D(21,2), D(21,2)};
  const logic [31:0] EOFT  = {D(28,5), D(21,4), D(21,3), D(21,3)};

  typedef enum integer {
    PRIM_IDLE = 0,
    PRIM_R_RDY,
    PRIM_BB_SCS,
    PRIM_BB_SCR,
    PRIM_SOFC1,
    PRIM_SOFI1,
    PRIM_SOFN1,
    PRIM_SOFI2,
    PRIM_SOFN2,
    PRIM_SOFI3,
    PRIM_SOFN3,
    PRIM_SOFC4,
    PRIM_SOFI4,
    PRIM_SOFN4,
    PRIM_SOFF,
    PRIM_EOFT,
    PRIM_EOFDT,
    PRIM_EOFA,
    PRIM_EOFN,
    PRIM_EOFNI,
    PRIM_EOFDTI,
    PRIM_EOFRT,
    PRIM_EOFRTI,
    PRIM_NOS,
    PRIM_OLS,
    PRIM_LR,
    PRIM_LRR,
    PRIM_MAX
  } primitives_t;

  typedef enum integer {
    STATE_ACTIVE,
    STATE_LR1,
    STATE_LR2,
    STATE_LR3,
    STATE_LF1,
    STATE_LF2,
    STATE_OL1,
    STATE_OL2,
    STATE_OL3
  } state_t;

endpackage
