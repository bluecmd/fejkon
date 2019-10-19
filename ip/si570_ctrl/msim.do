# * vim: syntax=tcl

vsim -voptargs="+acc=rn+top_tb" top_tb -L work

do ./wave.do

run -all
