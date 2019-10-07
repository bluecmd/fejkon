create_timing_netlist
read_sdc
update_timing_netlist

report_clock_fmax_summary -file "fmax.txt" -panel_name "Fmax"

foreach_in_collection op [get_available_operating_conditions] {
  set_operating_conditions $op
  report_timing -setup -npaths 10 -detail full_path -multi_corner \
    -file "critical_paths_$op.html" -panel_name "Critical paths for $op"
  report_timing -setup -npaths 10 -detail full_path -multi_corner \
    -less_than_slack 0 \
    -append -file "violated_paths.txt" -panel_name "Violated paths for $op"
}
