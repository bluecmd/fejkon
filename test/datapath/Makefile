QPATH ?= "$(HOME)/intelFPGA/20.1/quartus"

ABS_ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/

.DELETE_ON_ERROR:

.PHONY: clean

gen/simulation/fejkon_datapath.v: $(ABS_ROOT_DIR)/../../fejkon_datapath.qsys
	# Force re-compilation in the simulator
	rm -fr libraries
	$(QPATH)/sopc_builder/bin/qsys-generate \
		--simulation=VERILOG \
		--output-directory=$(CURDIR)/gen \
		$<

clean:
	\rm -fr gen/
