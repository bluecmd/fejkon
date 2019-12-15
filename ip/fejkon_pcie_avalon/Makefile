.PHONY: lint test

.DELETE_ON_ERROR:

SRCS := fejkon_pcie_avalon.sv

lint: $(SRCS)
	verilator --lint-only $^
