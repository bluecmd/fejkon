QPATH ?= "$(HOME)/intelFPGA/20.1/quartus"

.PHONY: test clean lint

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

svpcie_sim_tb.qsys: svpcie_sim_tb.tcl
	$(QPATH)/sopc_builder/bin/qsys-script --script=svpcie_sim_tb.tcl
	touch $@

gen: svpcie_sim_tb.qsys
	$(QPATH)/sopc_builder/bin/qsys-generate svpcie_sim_tb.qsys \
		--simulation=VERILOG \
		--allow-mixed-language-simulation \
		--output-directory=gen \
		--family="Stratix V" \
		--part=5SGXEA7N2F45C2
	patch -p0 < patches/01-pcie-monitor.patch
	rm -fr libraries/

clean:
	\rm -fr libraries/
	\rm -fr gen/
	\rm -f svpcie_sim_tb.qsys transcript vsim.wlf \
		altpcie_monitor_sv_dlhip_tlp_file_log.log svpcie_sim_tb.sopcinfo
