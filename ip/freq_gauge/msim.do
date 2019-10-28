# * vim: syntax=tcl

vsim -voptargs="+acc=rn+top_tb +acc=rn+top_tb/dut" top_tb -L work

log top_tb/dut/*

set broken 0
onbreak {
 set broken 1
 resume
}

if [expr {![batch_mode]}] {
  do wave.do
}

run 14ms

if [batch_mode] {
  if [expr {!$broken}] {
    puts "Failed: test reached deadline"
    exit -code 1
  }
  exit -code [expr [assertion count -fails -r /] > 0]
}
