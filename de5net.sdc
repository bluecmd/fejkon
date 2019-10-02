create_clock -period "50.00 MHz" [get_ports clk_clk]

derive_pll_clocks
derive_clock_uncertainty
