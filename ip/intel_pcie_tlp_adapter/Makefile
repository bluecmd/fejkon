.DELETE_ON_ERROR:

.PHONY: lint

lint:
	verilator --lint-only *.sv
	iverilog -g2012 -t null *.sv

