.PHONY: sim lint test

lint:
	verilator --lint-only freq_gauge.sv

work: $(wildcard *.sv)
	mkdir -p libraries
	(cd libraries; vlib work)
	vlog -sv *.sv

sim: work
	vsim -msgmode both -displaymsgmode both -do msim.do

test: work
	vsim -c -do msim.do
