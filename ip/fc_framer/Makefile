PYLINT ?= pylint3

.PHONY: lint test wave

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = \
	$(shell pwd)/../fc.sv \
	$(shell pwd)/fc_state_rx.sv \
	$(shell pwd)/fc_state_tx.sv \
	$(shell pwd)/fc_framer.sv
TOPLEVEL = fc_framer
MODULE = test

# Using features like "const logic" that are not supported by Icarus right now
# TODO: See https://github.com/cocotb/cocotb/issues/2051 for Verilator freeze bug
SIM ?= modelsim
ifeq (verilator,$(SIM))
COMPILE_ARGS += -GMTU=32
EXTRA_ARGS += --trace --trace-structs
endif
ifeq (modelsim,$(SIM))
SIM_ARGS += -gMTU=32
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

lint: ../fc.sv fc_framer.sv fc_state_rx.sv fc_state_tx.sv
	$(PYLINT) --rcfile=pylintrc test.py --exit-zero
	verilator --lint-only $^
ifneq (,$(shell which vsim))
	vlog -work .linttmp -lint -sv $^
	rm -fr .linttmp
endif

test:
	$(MAKE) sim

dump.vcd:
	$(MAKE) sim

wave: dump.vcd test.gtkw
	gtkwave --save test.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' test.gtkw
	sed -i '/^\[savefile/d' test.gtkw
	sed -i '/^\[\*]/d' test.gtkw
