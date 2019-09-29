QPATH ?= /home/bluecmd/intelFPGA/18.1/quartus

.DELETE_ON_ERROR:

fejkon.qsys: fejkon.tcl fejkon_fcport.qsys

%.qsys: %.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=$< --search-path='$(wildcard ip/**/*_hw.tcl),$$'

