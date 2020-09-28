#!/bin/bash

set -o pipefail

failure=0

for ip in fejkon_pcie_avalon fejkon_pcie_data pcie_msi_intr fejkon_fc_debug
do
  if ! make -C "ip/${ip}"; then
    failure=1
  fi
done

exit $failure
