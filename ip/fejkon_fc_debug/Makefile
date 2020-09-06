.PHONY: lint test wave
PYLINT ?= pylint3

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/fejkon_fc_debug.sv $(shell pwd)/generator.sv
TOPLEVEL = fejkon_fc_debug
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim

lint:
	$(PYLINT) --rcfile=pylintrc test.py --exit-zero
	verilator --lint-only fejkon_fc_debug.sv generator.sv
	iverilog -g2012 -t null fejkon_fc_debug.sv generator.sv

test:
	$(MAKE) sim

wave: fejkon_fc_debug.vcd test.gtkw
	gtkwave --save test.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' test.gtkw
	sed -i '/^\[savefile/d' test.gtkw
	sed -i '/^\[\*]/d' test.gtkw
