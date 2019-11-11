QPATH ?= "$(HOME)/intelFPGA/19.1/quartus"

.DELETE_ON_ERROR:

.PHONY: editor sim lint test

lint: testbench/tb_tb.qsys
	verilator --lint-only fejkon_pcie_data.sv
	vlog -work .linttmp -lint -sv testbench/tb_tb/simulation/submodules/verbosity_pkg.sv \
		fejkon_pcie_data.sv top_tb.sv
	rm -fr .linttmp

%.qsys: %.tcl ip
	$(QPATH)/sopc_builder/bin/qsys-script --script=$<

editor: tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-edit $<

ip:
	ln -sf ../ ip

testbench/tb_tb.qsys: tb.qsys fejkon_pcie_data_hw.tcl
	# Force re-compilation in the simulator
	rm -fr libraries
	$(QPATH)/sopc_builder/bin/qsys-generate \
		--testbench=STANDARD \
		--testbench-simulation=VERILOG \
		--output-directory=$(PWD) \
		$<
	# Avoid having a long re-compilation, symlink our files instead
	# These will be re-compiled specifically by msim.do
	ln -sf $(PWD)/fejkon_pcie_data.sv \
		testbench/tb_tb/simulation/submodules/fejkon_pcie_data.sv
	ln -sf $(PWD)/../pcie_msi_intr/pcie_msi_intr.sv \
		testbench/tb_tb/simulation/submodules/pcie_msi_intr.sv

sim: testbench/tb_tb.qsys
	vsim -msgmode both -displaymsgmode both -do msim.do

test: testbench/tb_tb.qsys
	vsim -c -do msim.do
