.DELETE_ON_ERROR:

.PHONY: lint

lint:
	verilator --lint-only ../fc.sv *.sv
	vlog -work .linttmp -lint -sv ../fc.sv *.sv
	rm -fr .linttmp
