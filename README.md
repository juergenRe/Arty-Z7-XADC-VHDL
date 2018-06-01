# Arty-Z7-XADC-VHDL
sample project using xadc IP, rewritten in VHDL from 
https://reference.digilentinc.com/learn/programmable-logic/tutorials/arty-z7-xadc-demo/start

- added simulation test bench
- extended create_project.tcl to import simulation sources
There is one important point to take care about:
- the xadc analog input lines need to be input in the top level as defined in the IP.
  Otherwise Vivado will throw errors during synthesis and implementation.
