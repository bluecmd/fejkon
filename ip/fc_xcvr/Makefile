QPATH ?= "$(HOME)/intelFPGA/19.1/quartus"

.DELETE_ON_ERROR:

.PHONY: editor sim lint

lint: testbench/tb_tb.qsys
	verilator --lint-only fc_util.sv fc_8g_xcvr.sv fc_phy_bbox.sv
	vlog -lint -sv testbench/tb_tb/simulation/submodules/verbosity_pkg.sv \
		fc_util.sv fc_8g_xcvr.sv fc_phy_bbox.sv top_tb.sv

%.qsys: %.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=$<

editor: tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-edit $<

testbench/tb_tb.qsys: tb.qsys fc_8g_xcvr_hw.tcl
	# Force re-compilation in the simulator
	rm -fr libraries
	mkdir -p libraries
	(cd libraries; vlib work)
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
	vsim -msgmode both -displaymsgmode both -do msim.do
