QPATH ?= $(HOME)/intelFPGA/20.1/quartus
PYLINT ?= pylint3

.PHONY: lint test wave

SRCS := fejkon_pcie_data.sv tl_cfg_module.sv test.sv \
	../pcie_data_fifo/pcie_data_fifo.v \
	$(QPATH)/eda/sim_lib/altera_mf.v

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(SRCS) $(wildcard test/*.v test/*.sv)
TOPLEVEL = test
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim

lint: $(SRCS)
	$(PYLINT) --rcfile=pylintrc test.py --exit-zero
	verilator --lint-only \
		../pcie_data_fifo/pcie_data_fifo_bb.v \
		fejkon_pcie_data.sv tl_cfg_module.sv
	iverilog -g2012 -t null $(VERILOG_SOURCES) \
		2>&1 | grep -v 'sim_lib/altera_mf.v:' || true

test:
	$(MAKE) sim

wave: fejkon_pcie_data.vcd test.gtkw
	gtkwave --save test.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' test.gtkw
	sed -i '/^\[savefile/d' test.gtkw
	sed -i '/^\[\*]/d' test.gtkw
