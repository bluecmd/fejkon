# * vim: syntax=tcl

set QSYS_SIMDIR testbench/
set USER_DEFINED_ELAB_OPTIONS ""
set TOP_LEVEL_NAME top_tb

# Keep signals in the testbench
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+top_tb"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+top_tb/tb/tb_inst"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+fc_framer"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+fc_8g_xcvr"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+fc_phy"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+sv_xcvr_custom_native"

set compile_all ![file isdirectory "libraries"]

source $QSYS_SIMDIR/mentor/msim_setup.tcl

# Compile libraries if starting from scratch, assume they will not change
if $compile_all {
  dev_com
  com
}

vlog -sv testbench/tb_tb/simulation/submodules/fc*.sv
vlog -sv top_tb.sv -L altera_common_sv_packages

elab

set broken 0
onbreak {
 set broken 1
 resume
}

if [expr {![batch_mode]}] {
  do wave.do
}

run 1ms

if [batch_mode] {
  if [expr {!$broken}] {
    puts "Failed: test reached deadline"
    exit -code 1
  }
  exit -code [expr [assertion count -fails -r /] > 0]
}
