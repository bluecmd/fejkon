QPATH ?= "$(HOME)/intelFPGA/19.1/quartus"

.DELETE_ON_ERROR:

.PHONY: editor sim

%.qsys: %.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=$<

editor: tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-edit $<

testbench/tb_tb.qsys: tb.qsys fc_8g_xcvr_hw.tcl
	# Force re-compilation in the simulator
	rm -fr libraries
	$(QPATH)/sopc_builder/bin/qsys-generate \
		--testbench=STANDARD \
		--testbench-simulation=VERILOG \
		--output-directory=$(PWD) \
		$<
	# Avoid having a long re-compilation, symlink our files instead
	# These will be re-compiled specifically by msim.do
	ln -sf $(PWD)/fc_8g_xcvr.sv \
		testbench/tb_tb/simulation/submodules/fc_8g_xcvr.sv

sim: testbench/tb_tb.qsys
	vsim -do msim.do
