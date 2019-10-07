#!/bin/bash

set -eux

test -f ${1}

# Under WSL Quartus detects this incorrectly so we have to help it a bit
export PATH="${QPATH}/../nios2eds/bin/gnu/H-x86_64-pc-linux-gnu/bin/:${PATH}"

"${QPATH}/../nios2eds/nios2_command_shell.sh" sof2flash --input="$(realpath "${1}")" --output=flash_hw.flash --offset=0x20C0000 --pfl --optionbit=0x00030000 --programmingmode=PS

# Load the flash loader onto the board
"${QPATH}/bin/quartus_pgm" -m jtag -c 1 -o "p;$(dirname $0)/flash_loader.sof"
"${QPATH}/../nios2eds/nios2_command_shell.sh" nios2-flash-programmer --base=0x0 flash_hw.flash
rm -f flash_hw.flash flash_hw.map.flash
