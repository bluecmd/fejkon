QPATH ?= "$(HOME)/intelFPGA/20.1/quartus"

ABS_ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/

.PHONY: test clean lint defconfig menuconfig edit edit-clean

test: gen gen/altpcied_sv_hwtcl.sv gen/altpcierd_tl_cfg_sample.v gen/altpcierd_hip_rs.v
	vsim -c -do msim.do

sim: gen gen/altpcied_sv_hwtcl.sv gen/altpcierd_tl_cfg_sample.v gen/altpcierd_hip_rs.v
	vsim -msgmode both -displaymsgmode both -do msim.do

gen/altpcied_sv_hwtcl.sv: gen
	cp ${QPATH}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/altpcied_sv_hwtcl.sv $@

gen/altpcierd_tl_cfg_sample.v: gen
	cp ${QPATH}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_tl_cfg_sample.v $@

gen/altpcierd_hip_rs.v: gen
	cp ${QPATH}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v $@

lint: libraries
	vlog -sv tb.sv -L altera_common_sv_packages

libraries:
	# Need to compile everything before make lint works
	@echo "Run 'make test' before 'make lint'"
	@exit 1

config.tcl: .config ../../config.py
	python3 ../../config.py > config.tcl

svpcie_sim_tb.qsys: .qsys-configured

.qsys-clean:
	rm -f .qsys-configured svpcie_sim_tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-script --script=svpcie_sim_tb.tcl
	touch $@

.qsys-configured: svpcie_sim_tb.tcl config.tcl
	make -C $(ABS_ROOT_DIR) .qsys-clean
	$(QPATH)/sopc_builder/bin/qsys-script --script=svpcie_apply_config.tcl
	rm .qsys-clean
	touch $@

edit-clean: .qsys-clean
	$(QPATH)/sopc_builder/bin/qsys-edit svpcie_sim_tb.qsys

edit: svpcie_sim_tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-edit svpcie_sim_tb.qsys

defconfig:
	cp defconfig .config

.config:
	cp defconfig .config

menuconfig: .config
	menuconfig

gen: svpcie_sim_tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-generate svpcie_sim_tb.qsys \
		--simulation=VERILOG \
		--allow-mixed-language-simulation \
		--output-directory=gen \
		--family="Stratix V" \
		--part=5SGXEA7N2F45C2
	# Avoid having a long re-compilation, symlink our files instead
	# These will be re-compiled specifically by msim.do
	ln -sf $(CURDIR)/../../ip/fejkon_pcie_data/fejkon_pcie_data.sv gen/simulation/submodules/
	ln -sf $(CURDIR)/../../ip/fejkon_pcie_avalon/fejkon_pcie_avalon.sv gen/simulation/submodules/
	ln -sf $(CURDIR)/../../ip/intel_pcie_tlp_adapter/intel_pcie_tlp_adapter.sv gen/simulation/submodules/
	patch -p0 < patches/01-pcie-monitor.patch
	rm -fr libraries/

clean:
	\rm -fr libraries/
	\rm -fr gen/
	\rm -fr .qsys_edit/
	\rm -fr svpcie_sim_tb/
	\rm -f svpcie_sim_tb.qsys transcript vsim.wlf \
		altpcie_monitor_sv_dlhip_tlp_file_log.log svpcie_sim_tb.sopcinfo \
		.qsys-clean .qsys-configured .config.old config.tcl


