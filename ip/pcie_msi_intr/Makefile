.PHONY: lint test wave clean

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/pcie_msi_intr.sv
TOPLEVEL = pcie_msi_intr
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim

lint:
	verilator --lint-only pcie_msi_intr.sv
	iverilog -g2012 -t null pcie_msi_intr.sv

wave: pcie_msi_intr.vcd test.gtkw
	gtkwave --save test.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' test.gtkw
	sed -i '/^\[savefile/d' test.gtkw
	sed -i '/^\[\*]/d' test.gtkw
