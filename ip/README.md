# IP parts

These are the Qsys IP components that are Fejkon specific or cannot be realized
with normal cores.

## Simulation

Qsys seems to have issues with marking the top level entity for simulation
causing ModelSim to complain about missing modules.

To set the top level module, add the following in the \_hw.tcl file:
```
set_fileset_property SIM_VERILOG TOP_LEVEL fc_remove_idle
```
