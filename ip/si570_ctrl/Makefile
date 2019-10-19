.PHONY: sim lint

lint:
	verilator --lint-only si570_ctrl.sv i2c_master.v --top-module si570_ctrl

work: $(wildcard *.sv) $(wildcard *.v)
	mkdir -p libraries
	(cd libraries; vlib work)
	vlog *.v
	vlog -sv *.sv

sim: work
	vsim -msgmode both -displaymsgmode both -do msim.do
