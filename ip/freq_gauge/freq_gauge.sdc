set_false_path -from {freq_gauge:phy_clk_gauge|counter[*} -to {freq_gauge:phy_clk_gauge|counter_cdc1[*}
set_false_path -from {freq_gauge:phy_clk_gauge|measure} -to {freq_gauge:phy_clk_gauge|measure_cdc1}
set_false_path -to {freq_gauge:phy_clk_gauge|reset_probe_r0}
