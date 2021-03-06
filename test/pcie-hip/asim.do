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
append USER_DEFINED_ELAB_OPTIONS " +access +r +m+tb"
# *) the qsys interconnect
append USER_DEFINED_ELAB_OPTIONS " +access +r +p+/tb/svpcie"
# *) the fejkon pcie ip cores
append USER_DEFINED_ELAB_OPTIONS " +access +r +m+fejkon_pcie_data"
append USER_DEFINED_ELAB_OPTIONS " +access +r +m+fejkon_pcie_avalon"
append USER_DEFINED_ELAB_OPTIONS " +access +r +m+intel_pcie_tlp_adapter"
# *) any altpcie monitor
append USER_DEFINED_ELAB_OPTIONS " +access +r +m+altpcie_monitor_sv_dlhip_sim"
# *) altpcied_sv_hwtcl
append USER_DEFINED_ELAB_OPTIONS " +access +r +p+/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps"
# *) to read success of pcie setup
append USER_DEFINED_ELAB_OPTIONS " +access +r +p+/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps/g_root_port/genblk1/drvr/*"

set compile_all ![file isdirectory "libraries"]

source $QSYS_SIMDIR/aldec/rivierapro_setup.tcl

if $compile_all {
  dev_com
  com
} else {
  # Only re-compile our internal IPs
  vlog -sv gen/simulation/submodules/fejkon_pcie_data.sv -work fejkon_pcie_data
  vlog -sv gen/simulation/submodules/fejkon_pcie_avalon.sv -work fejkon_pcie_avalon
  vlog -sv gen/simulation/submodules/intel_pcie_tlp_adapter.sv -work intel_pcie_tlp_adapter
}

# The EDA space is not really know to make bugless software, it seems these
# files are left out from the example designs.
vlog gen/altpcierd_tl_cfg_sample.v
vlog -sv gen/altpcied_sv_hwtcl.sv
vlog gen/altpcierd_hip_rs.v
vlog -sv tb.sv -l altera_common_sv_packages

elab

log -recursive /*

if [expr {![batch_mode]}] {
  do wave.do
}

# TODO: This does not seem to trigger:
# # KERNEL:            114016601: INFO: tb.3unnblk: Test passed
# # RUNTIME: Info: RUNTIME_0070 tb.sv (135): $stop called.
# # KERNEL: Time: 114016601 ps,  Iteration: 0,  Instance: /tb,  Process: @INITIAL#66_5@.
# # KERNEL: Stopped at time 114016601 ps + 0.
# if [batch_mode] {
#   if [expr {!$broken}] {
#     puts "Failed: test reached deadline"
#     exit -code 1
#   }
#   exit -code [expr [assertion count -fails -r /] > 0]
# }
# # Failed: test reached deadline
set broken 0
onbreak {
 set broken 1
 resume
}

run 150 us
# TODO: This is ? in Riviera-PRO
#if {[examine -expr {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps/g_root_port/genblk1/drvr/ebfm_log_stop_sim/success == 1}] != "true"} {
#  echo "PCIe self-test failed"
#  if [batch_mode] {
#    exit -code 1
#  }
#} else {
  echo "PCIe self-test complete"
  # Run custom testing in tb.sv
  run 100 us
#}

if [batch_mode] {
  if [expr {!$broken}] {
    puts "Failed: test reached deadline"
    exit -code 1
  }
  exit -code [expr [assertion count -fails -r /] > 0]
}
