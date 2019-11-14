.PHONY: lint test

.DELETE_ON_ERROR:

SRCS := ../pcie_msi_intr/pcie_msi_intr.sv fejkon_pcie_data.sv test.sv

lint: $(SRCS)
	pylint3 --rcfile=pylintrc test.py --exit-zero
	iverilog -g2012 -t null $^

test.vvp: $(SRCS)
	iverilog -g2012 -o $@ $^

test: test.vvp
	python3 test.py
	gtkwave test.gtkw
