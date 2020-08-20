create_timing_netlist
read_sdc
update_timing_netlist

report_clock_fmax_summary -file "fmax.txt" -panel_name "Fmax"

foreach_in_collection op [get_available_operating_conditions] {
  set_operating_conditions $op
  foreach x {setup hold recovery removal} {
    report_timing -npaths 10 -detail full_path -multi_corner \
      -file "critical_${x}_paths_$op.html" \
      -panel_name "Critical $x paths for $op" \
      -$x
    if {[report_timing -npaths 1 -multi_corner -less_than_slack 0 -$x] \
      ne "0 0.000"} {
      report_timing -npaths 10 -detail full_path -multi_corner \
        -less_than_slack 0 \
        -append -file "violated_paths.txt" -panel_name "Violated paths for $op" \
        -$x
    }
  }
}
