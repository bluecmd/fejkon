QPATH ?= "$(HOME)/intelFPGA/19.1/quartus"

.DELETE_ON_ERROR:

.PHONY: all syscon program flash editor sim

all: fejkon.sof

clean:
	rm -f fejkon.sof
	rm -fr gen

fejkon.sof: ip/altera_fc_phy/fc_phy.qip fejkon.qsys de5net.sdc de5net.tcl $(wildcard ip/*/*.sv)
	echo "\`define FEJKON_GIT_HASH 32'h$(shell git describe --long --always --abbrev=8)" > ip/fejkon_identity/version.sv
	(mkdir -p gen; cd gen; rm -f *.txt *.html; $(QPATH)/bin/quartus_sh -t ../quartus.tcl)
	cp gen/output_files/fejkon.sof $@
	cat gen/fmax.txt | grep -v Thi
	cat gen/violated_paths.txt

# Temporarily program over JTAG
program: fejkon.sof
	${QPATH}/bin/quartus_pgm -m jtag -c 1 -o "p;fejkon.sof"

# Permanently upload to DE5-Net flash
flash: fejkon.sof
	QPATH=$(QPATH) utils/flash.sh fejkon.sof

ip/altera_fc_phy/fc_phy.qip: ip/altera_fc_phy/fc_phy.v
	(cd ip/altera_fc_phy; $(QPATH)/bin/qmegawiz  -silent $(PWD)/$<)
	touch $@

fejkon.qsys: fejkon.tcl fejkon_fcport.qsys fejkon_sfp.qsys fejkon_pcie.qsys

%.qsys: %.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=$< --search-path='$(wildcard ip/**/*_hw.tcl),$$'

syscon:
	$(QPATH)/sopc_builder/bin/system-console --desktop_script=syscon.tcl -debug

editor: fejkon.qsys
	$(QPATH)/sopc_builder/bin/qsys-edit fejkon.qsys

testbench: fejkon.qsys
	$(QPATH)/sopc_builder/bin/qsys-generate \
		--testbench=STANDARD \
		--testbench-simulation=VERILOG \
		--output-directory=$(PWD) \
		fejkon.qsys

sim: testbench
	vsim -do msim.do
