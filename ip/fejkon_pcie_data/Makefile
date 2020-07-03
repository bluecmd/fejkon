.PHONY: lint test

.DELETE_ON_ERROR:

SRCS := fejkon_pcie_data.sv tl_cfg_module.sv test.sv \
	../intel_pcie_tlp_adapter/intel_pcie_tlp_adapter.sv \

lint: $(SRCS)
	pylint3 --rcfile=pylintrc test.py test_ep.py --exit-zero
	verilator --lint-only fejkon_pcie_data.sv tl_cfg_module.sv
	iverilog -g2012 -t null $^ $(wildcard test/*)

test.vvp: $(SRCS)
	iverilog -g2012 -o $@ $^ $(wildcard test/*)

test: test.vvp
ifneq ($(TEST),)
	python3 test.py Test.$(TEST)
else
	python3 test.py
endif

wave: $(TEST)/wave.fst test.gtkw
	gtkwave --save test.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' test.gtkw
	sed -i '/^\[savefile/d' test.gtkw
	sed -i '/^\[\*]/d' test.gtkw
