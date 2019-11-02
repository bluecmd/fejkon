.DELETE_ON_ERROR:

.PHONY: lint

lint:
	verilator --lint-only fejkon_led.sv flap_detect.sv
	vlog -work .linttmp -lint -sv *.sv
	rm -fr .linttmp

work: $(wildcard *.sv)
	mkdir -p libraries
	(cd libraries; vlib work)
	vlog -sv *.sv

sim: work
	vsim -msgmode both -displaymsgmode both -do msim.do

test: work
	vsim -c -do msim.do
