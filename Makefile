QPATH ?= "$(HOME)/intelFPGA/19.1/quartus"

.DELETE_ON_ERROR:

.PHONY: all

all: fejkon.sof

clean:
	rm -f fejkon.sof
	rm -fr gen

fejkon.sof: ip/altera_fc_phy/fc_phy.qip fejkon.qsys
	(mkdir -p gen; cd gen; $(QPATH)/bin/quartus_sh -t ../quartus.tcl)

ip/altera_fc_phy/fc_phy.qip: ip/altera_fc_phy/fc_phy.v
	(cd ip/altera_fc_phy; $(QPATH)/bin/qmegawiz  -silent $(PWD)/$<)
	touch $@

fejkon.qsys: fejkon.tcl fejkon_fcport.qsys

%.qsys: %.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=$< --search-path='$(wildcard ip/**/*_hw.tcl),$$'

