`timescale 1 us / 1 us
package fc;

  function bit [7:0] D(input int X, input int Y);
    return {Y[2:0], X[4:0]};
  endfunction

  // Table 7, FC-FS-5 INCITS 545-2019
  const logic [31:0] SOFI2   = {D(28,5), D(21,5), D(21,2), D(21,2)};
  const logic [31:0] SOFN2   = {D(28,5), D(21,5), D(21,1), D(21,1)};
  const logic [31:0] SOFI3   = {D(28,5), D(21,5), D(22,2), D(22,2)};
  const logic [31:0] SOFN3   = {D(28,5), D(21,5), D(22,1), D(22,1)};
  const logic [31:0] SOFF    = {D(28,5), D(21,5), D(24,2), D(24,2)};
  const logic [31:0] EOFT_N  = {D(28,5), D(21,5), D(21,3), D(21,3)};
  const logic [31:0] EOFT_P  = {D(28,5), D(21,4), D(21,3), D(21,3)};
  const logic [31:0] EOFA_N  = {D(28,5), D(21,5), D(21,7), D(21,7)};
  const logic [31:0] EOFA_P  = {D(28,5), D(21,4), D(21,7), D(21,7)};
  const logic [31:0] EOFN_N  = {D(28,5), D(21,5), D(21,6), D(21,6)};
  const logic [31:0] EOFN_P  = {D(28,5), D(21,4), D(21,6), D(21,6)};
  const logic [31:0] EOFNI_N = {D(28,5), D(10,5), D(21,6), D(21,6)};
  const logic [31:0] EOFNI_P = {D(28,5), D(10,4), D(21,6), D(21,6)};

  // Table 8, FC-FS-5 INCITS 545-2019
  const logic [31:0] IDLE   = {D(28,5), D(21,4), D(21,5), D(21,5)};
  const logic [31:0] R_RDY  = {D(28,5), D(21,4), D(10,2), D(10,2)};
  const logic [31:0] BB_SCS = {D(28,5), D(21,4), D(22,4), D(22,4)};
  const logic [31:0] BB_SCR = {D(28,5), D(21,4), D(22,6), D(22,6)};
  const logic [31:0] ARBFF  = {D(28,5), D(20,4), D(31,7), D(31,7)};

  // Table 9, FC-FS-5 INCITS 545-2019
  const logic [31:0] NOS = {D(28,5), D(21,2), D(31,5), D(5,2)};
  const logic [31:0] OLS = {D(28,5), D(21,1), D(10,4), D(21,2)};
  const logic [31:0] LR  = {D(28,5), D(9,2),  D(31,5), D(9,2)};
  const logic [31:0] LRR = {D(28,5), D(21,1), D(31,5), D(9,2)};

  typedef enum integer {
    PRIM_IDLE = 0,
    PRIM_R_RDY,
    PRIM_VC_RDY,
    PRIM_BB_SCS,
    PRIM_BB_SCR,
    PRIM_SOFI2,
    PRIM_SOFN2,
    PRIM_SOFI3,
    PRIM_SOFN3,
    PRIM_SOFF,
    PRIM_EOFT,
    PRIM_EOFA,
    PRIM_EOFN,
    PRIM_EOFNI,
    PRIM_NOS,
    PRIM_OLS,
    PRIM_LR,
    PRIM_LRR,
    PRIM_ARBFF,
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
    if (data[31:16] == {D(28,5), D(21,7)}) begin
      return PRIM_VC_RDY;
    end
    case(data)
      IDLE:    return PRIM_IDLE;
      R_RDY:   return PRIM_R_RDY;
      BB_SCS:  return PRIM_BB_SCS;
      BB_SCR:  return PRIM_BB_SCR;
      SOFI2:   return PRIM_SOFI2;
      SOFN2:   return PRIM_SOFN2;
      SOFI3:   return PRIM_SOFI3;
      SOFN3:   return PRIM_SOFN3;
      SOFF:    return PRIM_SOFF;
      EOFT_N:  return PRIM_EOFT;
      EOFT_P:  return PRIM_EOFT;
      EOFA_N:  return PRIM_EOFA;
      EOFA_P:  return PRIM_EOFA;
      EOFN_N:  return PRIM_EOFN;
      EOFN_P:  return PRIM_EOFN;
      EOFNI_N: return PRIM_EOFNI;
      EOFNI_P: return PRIM_EOFNI;
      NOS:     return PRIM_NOS;
      OLS:     return PRIM_OLS;
      LR:      return PRIM_LR;
      LRR:     return PRIM_LRR;
      ARBFF:   return PRIM_ARBFF;
      default: return PRIM_UNKNOWN;
    endcase
    return PRIM_UNKNOWN;
  endfunction

endpackage
