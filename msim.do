set QSYS_SIMDIR testbench/
source $QSYS_SIMDIR/mentor/msim_setup.tcl

dev_com
com

set TOP_LEVEL_NAME fejkon_tb

elab

run 10 ms
