QPATH ?= "$(HOME)/intelFPGA/20.1/quartus"

.DELETE_ON_ERROR:

.PHONY: editor sim lint test

lint: testbench/tb_tb.qsys
	verilator --lint-only ../fc.sv fc_8g_xcvr.sv fc_phy_bbox.sv
	vlog -work .linttmp -lint -sv testbench/tb_tb/simulation/submodules/verbosity_pkg.sv \
		../fc.sv fc_8g_xcvr.sv fc_phy_bbox.sv top_tb.sv
	rm -fr .linttmp

%.qsys: %.tcl ip
	$(QPATH)/sopc_builder/bin/qsys-script --script=$<

editor: tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-edit $<

ip:
	ln -sf ../ ip

testbench/tb_tb.qsys: tb.qsys fc_8g_xcvr_hw.tcl
	# Force re-compilation in the simulator
	rm -fr libraries
	$(QPATH)/sopc_builder/bin/qsys-generate \
		--testbench=STANDARD \
		--testbench-simulation=VERILOG \
		--output-directory=$(CURDIR) \
		$<
	# Avoid having a long re-compilation, symlink our files instead
	# These will be re-compiled specifically by msim.do
	ln -sf $(CURDIR)/fc_8g_xcvr.sv \
		testbench/tb_tb/simulation/submodules/fc_8g_xcvr.sv
	ln -sf $(CURDIR)/../fc.sv \
		testbench/tb_tb/simulation/submodules/fc.sv
	ln -sf $(CURDIR)/../fc_framer/fc_framer.sv \
		testbench/tb_tb/simulation/submodules/fc_framer.sv
	ln -sf $(CURDIR)/../fc_framer/fc_state_tx.sv \
		testbench/tb_tb/simulation/submodules/fc_state_tx.sv
	ln -sf $(CURDIR)/../fc_framer/fc_state_rx.sv \
		testbench/tb_tb/simulation/submodules/fc_state_rx.sv

sim: testbench/tb_tb.qsys
	vsim -msgmode both -displaymsgmode both -do msim.do

test: testbench/tb_tb.qsys
	vsim -c -do msim.do
	@echo "NOTE: A few 8B/10B errors are to be expected"
