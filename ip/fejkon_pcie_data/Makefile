.DELETE_ON_ERROR:

.PHONY: lint test

lint:
	verilator --lint-only fejkon_pcie_data.sv
	vlog -work .linttmp -lint -sv testbench/tb_tb/simulation/submodules/verbosity_pkg.sv \
		fejkon_pcie_data.sv top_tb.sv
	rm -fr .linttmp

test:
	echo TODO
	exit 1
