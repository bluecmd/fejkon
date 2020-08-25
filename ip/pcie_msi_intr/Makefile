.PHONY: lint test wave clean

lint:
	verilator --lint-only pcie_msi_intr.sv
	iverilog -g2012 -t null tb.sv pcie_msi_intr.sv

test.vvp: pcie_msi_intr.sv tb.sv
	iverilog -g2012 -o $@ $^

test: test.vvp
	python3 test.py -v

wave: $(TEST)/wave.fst test.gtkw
	gtkwave --save test.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' test.gtkw
	sed -i '/^\[savefile/d' test.gtkw
	sed -i '/^\[\*]/d' test.gtkw

clean:
	\rm -f test.vvp
	\rm -fr test_*/
