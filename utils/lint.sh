#!/bin/bash

set -eo pipefail

git ls-files '*.sv' | \
  grep -v 'ip/fejkon_pcie_data/test/fejkon_pcie_tlp_tx_multiplexer.sv' | \
  grep -v 'ip/fc_xcvr/fc_phy_bbox.sv' | \
  xargs verible-verilog-lint --rules_config=rules.verible
