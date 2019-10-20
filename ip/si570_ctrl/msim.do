# * vim: syntax=tcl

vsim -voptargs="+acc=rn+top_tb +acc=rn+top_tb/dut +acc=rn+top_tb/dut/i2c" top_tb -L work

do ./wave.do

run 3ms
