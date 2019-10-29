set_false_path -from {*freq_gauge:*|counter[*} -to {*freq_gauge:*|counter_cdc1[*}
set_false_path -from {*freq_gauge:*|measure} -to {*freq_gauge:*|measure_cdc1}
set_false_path -to {*freq_gauge:*|reset_probe_r0}
