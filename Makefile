QPATH ?= "$(HOME)/intelFPGA/20.1/quartus"

#.DELETE_ON_ERROR:

.PHONY: all syscon program flash editor defconfig menuconfig test report

all: fejkon.sof report

clean:
	rm -f fejkon.sof
	rm -fr gen

fejkon.sof: ip/altera_fc_phy/fc_phy.qip fejkon.qsys de5net.sdc de5net.tcl $(wildcard ip/*/*.sv)
	echo "\`define FEJKON_GIT_HASH 32'h$(shell git describe --long --always --abbrev=8)" > ip/fejkon_identity/version.sv
	(mkdir -p gen; cd gen; rm -f *.txt *.html; $(QPATH)/bin/quartus_sh -t ../quartus.tcl)
	cp gen/output_files/fejkon.sof $@
	touch $@

report:
	@echo
	@echo '  ==> Generation report <=='
	@echo
	@[ -f gen/violated_paths.txt ] && cat gen/violated_paths.txt \
		|| echo 'No timing constraints violated! Yeey!'
	@echo
	@grep -B1 '; I/O Assignment Warnings' gen/output_files/fejkon.fit.rpt \
		| grep -- '---' || echo 'No I/O assignment warnings! Awesome!\n'
	@awk '/; I\/O Assignment Warnings/,/^$$/' gen/output_files/fejkon.fit.rpt
	@cat gen/fmax.txt | grep -v Thi
	@echo

# Temporarily program over JTAG
program: fejkon.sof
	$(QPATH)/bin/quartus_pgm -m jtag -c 1 -o "p;fejkon.sof"

# Permanently upload to DE5-Net flash
flash: fejkon.sof
	QPATH=$(QPATH) utils/flash.sh fejkon.sof

syscon:
	$(QPATH)/sopc_builder/bin/system-console --desktop_script=syscon.tcl -debug

ip/altera_fc_phy/fc_phy.qip: ip/altera_fc_phy/fc_phy.v
	(cd ip/altera_fc_phy; $(QPATH)/bin/qmegawiz  -silent $(PWD)/$<)
	touch $@

ip/fejkon_identity/version.sv:
	touch ip/fejkon_identity/version.sv

config.tcl: .config config.py
	python3 config.py > config.tcl

fejkon.qsys: .qsys-configured

.qsys-clean: ip/fejkon_identity/version.sv
	# Generate clean platform files
	rm -f .qsys-configured \
		fejkon_pcie.qsys fejkon_fc.qsys fejkon_sfp.qsys fejkon.qsys
	$(QPATH)/sopc_builder/bin/qsys-script --script=fejkon_pcie.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=fejkon_fc.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=fejkon_sfp.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=fejkon.tcl
	touch $@

.qsys-configured: fejkon.tcl $(wildcard fejkon_*.tcl) config.tcl
	make -C $(PWD) .qsys-clean
	$(QPATH)/sopc_builder/bin/qsys-script --script=fejkon_apply_config.tcl
	rm .qsys-clean
	touch $@

edit-clean: .qsys-clean
	$(QPATH)/sopc_builder/bin/qsys-edit fejkon.qsys

edit: fejkon.qsys
	$(QPATH)/sopc_builder/bin/qsys-edit fejkon.qsys

menuconfig: .config
	menuconfig

defconfig:
	cp defconfig .config

.config:
	cp defconfig .config

test: test-fc_xcvr test-fejkon_led test-fejkon_pcie_avalon test-fejkon_pcie_data test-freq_gauge test-si570_ctrl test-pcie-hip

test-%: ip/%
	make QPATH=${QPATH} -C "$<" test

test-pcie-hip:
	make QPATH=${QPATH} -C test/pcie-hip test
