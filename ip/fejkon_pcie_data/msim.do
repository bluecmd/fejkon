# * vim: syntax=tcl

set QSYS_SIMDIR testbench/
set USER_DEFINED_ELAB_OPTIONS ""
set TOP_LEVEL_NAME top_tb

# Keep signals in the testbench
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+top_tb"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+top_tb/tb/tb_inst"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+fejkon_pcie_data"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+pcie_msi_intr"

set compile_all ![file isdirectory "libraries"]

source $QSYS_SIMDIR/mentor/msim_setup.tcl

# Compile libraries if starting from scratch, assume they will not change
if $compile_all {
  dev_com
  com
}

vlog -sv testbench/tb_tb/simulation/submodules/fejkon_pcie_data.sv
vlog -sv testbench/tb_tb/simulation/submodules/pcie_msi_intr.sv
vlog -sv top_tb.sv -L altera_common_sv_packages
vlog -sv altpcied_sv_hwtcl.sv
vlog altpcierd_tl_cfg_sample.v
vlog altpcierd_hip_rs.v

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
