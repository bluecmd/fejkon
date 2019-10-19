create_clock -period "50.00 MHz" [get_ports clk_clk]
create_clock -period "100.00 MHz" [get_ports pcie_refclk_clk]
create_clock -period "106.25 MHz" [get_ports phy_clk_clk]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_clocks {clk_clk}] -to [get_clocks {pcie|phy|altera_s5_a2p|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}]
