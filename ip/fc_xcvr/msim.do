# * vim: syntax=tcl

set QSYS_SIMDIR testbench/
set USER_DEFINED_ELAB_OPTIONS ""
set TOP_LEVEL_NAME top_tb

# Keep signals in the testbench
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+top_tb/tb/tb_inst"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+top_tb/tb/tb_inst/fc_8g_xcvr_0"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+top_tb/tb/tb_inst/fc_8g_xcvr_0/phy"

set compile_all ![file isdirectory "libraries"]

source $QSYS_SIMDIR/mentor/msim_setup.tcl

# Compile libraries if starting from scratch, assume they will not change
if $compile_all {
  dev_com
  com
}

vlog -sv fc_8g_xcvr.sv
vlog -sv top_tb.sv -L altera_common_sv_packages

elab

do ./wave.do

run -all
