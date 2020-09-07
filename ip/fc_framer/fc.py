"""FC library for encoding/decoding FC frames."""

def D(x, y):
    return x & 31 | (y & 7) << 5


SOFI2   = bytes([D(28,5), D(21,5), D(21,2), D(21,2)]);
SOFN2   = bytes([D(28,5), D(21,5), D(21,1), D(21,1)]);
SOFI3   = bytes([D(28,5), D(21,5), D(22,2), D(22,2)]);
SOFN3   = bytes([D(28,5), D(21,5), D(22,1), D(22,1)]);
SOFF    = bytes([D(28,5), D(21,5), D(24,2), D(24,2)]);
EOFT_N  = bytes([D(28,5), D(21,5), D(21,3), D(21,3)]);
EOFT_P  = bytes([D(28,5), D(21,4), D(21,3), D(21,3)]);
EOFA_N  = bytes([D(28,5), D(21,5), D(21,7), D(21,7)]);
EOFA_P  = bytes([D(28,5), D(21,4), D(21,7), D(21,7)]);
EOFN_N  = bytes([D(28,5), D(21,5), D(21,6), D(21,6)]);
EOFN_P  = bytes([D(28,5), D(21,4), D(21,6), D(21,6)]);
EOFNI_N = bytes([D(28,5), D(10,5), D(21,6), D(21,6)]);
EOFNI_P = bytes([D(28,5), D(10,4), D(21,6), D(21,6)]);
IDLE    = bytes([D(28,5), D(21,4), D(21,5), D(21,5)]);
R_RDY   = bytes([D(28,5), D(21,4), D(10,2), D(10,2)]);
BB_SCS  = bytes([D(28,5), D(21,4), D(22,4), D(22,4)]);
BB_SCR  = bytes([D(28,5), D(21,4), D(22,6), D(22,6)]);
ARBFF   = bytes([D(28,5), D(20,4), D(31,7), D(31,7)]);
NOS     = bytes([D(28,5), D(21,2), D(31,5), D(5,2)]);
OLS     = bytes([D(28,5), D(21,1), D(10,4), D(21,2)]);
LR      = bytes([D(28,5), D(9,2),  D(31,5), D(9,2)]);
LRR     = bytes([D(28,5), D(21,1), D(31,5), D(9,2)]);


def decode(b):
    if b == SOFI3:
        return 'SOFi3'
    if b == SOFI2:
       return 'SOFI2'
    if b == SOFN2:
       return 'SOFN2'
    if b == SOFI3:
       return 'SOFI3'
    if b == SOFN3:
       return 'SOFN3'
    if b == SOFF:
       return 'SOFF'
    if b == EOFT_N:
       return 'EOFT_N'
    if b == EOFT_P:
       return 'EOFT_P'
    if b == EOFA_N:
       return 'EOFA_N'
    if b == EOFA_P:
       return 'EOFA_P'
    if b == EOFN_N:
       return 'EOFN_N'
    if b == EOFN_P:
       return 'EOFN_P'
    if b == EOFNI_N:
       return 'EOFNI_N'
    if b == EOFNI_P:
       return 'EOFNI_P'
    if b == IDLE:
       return 'IDLE'
    if b == R_RDY:
       return 'R_RDY'
    if b == BB_SCS:
       return 'BB_SCS'
    if b == BB_SCR:
       return 'BB_SCR'
    if b == ARBFF:
       return 'ARBFF'
    if b == NOS:
       return 'NOS'
    if b == OLS:
       return 'OLS'
    if b == LR:
       return 'LR'
    if b == LRR:
        return 'LRR'
    raise Exception('Unsupported sumbol ' + b)
