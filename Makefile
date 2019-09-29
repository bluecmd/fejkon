QPATH ?= /home/bluecmd/intelFPGA/18.1/quartus

fejkon.qsys: fejkon.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=fejkon.tcl

