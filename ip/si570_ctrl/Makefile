.PHONY: sim lint

lint:
	verilator --lint-only i2c_* si570_ctrl.sv
	vlog -lint -sv *.sv *.v

work: $(wildcard *.sv) $(wildcard *.v)
	mkdir -p libraries
	(cd libraries; vlib work)
	vlog -sv *.sv *.v

sim: work
	vsim -msgmode both -displaymsgmode both -do msim.do
