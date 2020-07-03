# * vim: syntax=tcl

set QSYS_SIMDIR gen/simulation/
# The qsys test bench generates multiple altpcie_monitor_sv_dlhip_sim cores
# all trying to write to the same log file, so output their data to the prompt
# as well to make it usable.
set USER_DEFINED_COMPILE_OPTIONS "+define+ALTPCIE_MONITOR_SV_HIP_DLTL_PROMPT"
set USER_DEFINED_ELAB_OPTIONS ""
set TOP_LEVEL_NAME tb

# Keep signals in the testbench
# *) the testbench
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=n+tb"
# *) the qsys interconnect
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=n+tb/svpcie"
# *) the fejkon pcie ip cores
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+fejkon_pcie_data"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+fejkon_pcie_avalon"
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+intel_pcie_tlp_adapter"
# *) any altpcie monitor
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rn+altpcie_monitor_sv_dlhip_sim"
# *) altpcied_sv_hwtcl
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=p+tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps"
# *) to read success of pcie setup
append USER_DEFINED_ELAB_OPTIONS " -voptargs=+acc=rt+tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps/g_root_port/genblk1/drvr/ebfm_log_stop_sim"

set compile_all ![file isdirectory "libraries"]

source $QSYS_SIMDIR/mentor/msim_setup.tcl

if $compile_all {
  dev_com
  com
}

# The EDA space is not really know to make bugless software, it seems these
# files are left out from the example designs.
vlog gen/altpcierd_tl_cfg_sample.v
vlog -sv gen/altpcied_sv_hwtcl.sv
vlog gen/altpcierd_hip_rs.v
vlog -sv tb.sv -L altera_common_sv_packages

elab

log -r /*

if [expr {![batch_mode]}] {
  do wave.do
}

set broken 0
onbreak {
 set broken 1
 resume
}

run 150 us
if {[examine -expr {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps/g_root_port/genblk1/drvr/ebfm_log_stop_sim/success == 1}] != "true"} {
  echo "PCIe self-test failed"
  if [batch_mode] {
    exit -code 1
  }
} else {
  echo "PCIe self-test complete"
  # Run custom testing in tb.sv
  run 100 us
}

if [batch_mode] {
  if [expr {!$broken}] {
    puts "Failed: test reached deadline"
    exit -code 1
  }
  exit -code [expr [assertion count -fails -r /] > 0]
}
