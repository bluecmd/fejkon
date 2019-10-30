set_false_path -to {*fc_8g_xcvr:*|*_cdc1*}
# Treat counters as best effort, if we can read them that's great but do not
# do any complicated efforts to synchronize them
set_false_path -from {*fc_8g_xcvr:*|*_cntr*}
