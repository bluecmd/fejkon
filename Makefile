QPATH ?= "$(HOME)/intelFPGA/19.1/quartus"

.DELETE_ON_ERROR:

.PHONY: all syscon

all: fejkon.sof

clean:
	rm -f fejkon.sof
	rm -fr gen

fejkon.sof: ip/altera_fc_phy/fc_phy.qip fejkon.qsys de5net.sdc de5net.tcl $(wildcard ip/*/*.sv)
	(mkdir -p gen; cd gen; $(QPATH)/bin/quartus_sh -t ../quartus.tcl)
	cp gen/output_files/fejkon.sof $@

ip/altera_fc_phy/fc_phy.qip: ip/altera_fc_phy/fc_phy.v
	(cd ip/altera_fc_phy; $(QPATH)/bin/qmegawiz  -silent $(PWD)/$<)
	touch $@

fejkon.qsys: fejkon.tcl fejkon_fcport.qsys fejkon_sfp.qsys fejkon_pcie.qsys

%.qsys: %.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=$< --search-path='$(wildcard ip/**/*_hw.tcl),$$'

syscon:
	$(QPATH)/sopc_builder/bin/system-console --desktop_script=syscon.tcl -debug
