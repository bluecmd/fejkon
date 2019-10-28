QPATH ?= "$(HOME)/intelFPGA/19.1/quartus"

.PHONY: sim lint

lint:
	vlog -lint -sv *.sv *.v

work: $(wildcard *.sv) $(wildcard *.v)
	mkdir -p libraries
	(cd libraries; vlib work)
	# Need 220model for lpm_divide
	vlog -sv *.sv *.v "$(QPATH)/eda/sim_lib/220model.v"

sim: work
	vsim -msgmode both -displaymsgmode both -do msim.do

test: work
	vsim -c -do msim.do
