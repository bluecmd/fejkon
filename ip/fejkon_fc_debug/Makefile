.PHONY: lint test wave clean

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/fejkon_fc_debug.sv
TOPLEVEL = fejkon_fc_debug
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim

lint:
	verilator --lint-only fejkon_fc_debug.sv
	iverilog -g2012 -t null fejkon_fc_debug.sv

wave: fejkon_fc_debug.vcd test.gtkw
	gtkwave --save test.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' test.gtkw
	sed -i '/^\[savefile/d' test.gtkw
	sed -i '/^\[\*]/d' test.gtkw
