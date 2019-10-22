# * vim: syntax=tcl

vsim -voptargs="+acc=rn+top_tb +acc=rn+top_tb/dut" top_tb -L work

do ./wave.do

run 14ms
