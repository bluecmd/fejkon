source ../config.tcl

create_clock -period "50.00 MHz" [get_ports clk_clk]
create_clock -period "100.00 MHz" [get_ports pcie_refclk_clk]
create_clock -period "106.25 MHz" [get_ports phy_clk_clk]

derive_pll_clocks
derive_clock_uncertainty
