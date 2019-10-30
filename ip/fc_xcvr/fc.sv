package fc;

  function bit [7:0] D(input int X, input int Y);
    return {Y[2:0], X[4:0]};
  endfunction

  const logic [31:0] IDLE =  {D(28,5), D(21,4), D(21,5), D(21,5)};
  const logic [31:0] SOFI3 = {D(28,5), D(21,5), D(21,2), D(21,2)};
  const logic [31:0] EOFT  = {D(28,5), D(21,4), D(21,3), D(21,3)};
  const logic [31:0] NOS =   {D(28,5), D(21,2), D(31,5), D(5,2)};
  const logic [31:0] OLS =   {D(28,5), D(21,1), D(10,4), D(21,2)};
  const logic [31:0] LR  =   {D(28,5), D(9,2),  D(31,5), D(9,2)};
  const logic [31:0] LRR =   {D(28,5), D(21,1), D(31,5), D(9,2)};

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
    PRIM_UNKNOWN,
    PRIM_MAX
  } primitives_t;

  typedef enum integer {
    STATE_AC = 0,
    STATE_LR1,
    STATE_LR2,
    STATE_LR3,
    STATE_LF1,
    STATE_LF2,
    STATE_OL1,
    STATE_OL2,
    STATE_OL3
  } state_t;

  function primitives_t map_primitive(input logic [31:0] data);
    case(data)
      fc::SOFI3: return fc::PRIM_SOFI3;
      fc::EOFT:  return fc::PRIM_EOFT;
      fc::OLS:   return fc::PRIM_OLS;
      fc::LRR:   return fc::PRIM_LRR;
      fc::LR:    return fc::PRIM_LR;
      fc::NOS:   return fc::PRIM_NOS;
      fc::IDLE:  return fc::PRIM_IDLE;
      default:   return fc::PRIM_UNKNOWN;
    endcase
    return fc::PRIM_UNKNOWN;
  endfunction

endpackage
