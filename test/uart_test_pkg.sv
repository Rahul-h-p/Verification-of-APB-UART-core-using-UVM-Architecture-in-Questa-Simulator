package  uart_test_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "apb_agent_config.sv"
`include "uart_agent_config.sv"
`include "uart_env_config.sv"
`include "write_xtn.sv"
`include "apb_seq.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_agent.sv"
`include "apb_agent_top.sv"

`include "read_xtn.sv"
`include "uart_seq.sv"
`include "uart_sequencer.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"
`include "uart_agent.sv"
`include "uart_agent_top.sv"

`include "uart_scoreboard.sv"
`include "uart_tb.sv"
`include "uart_test.sv"
endpackage
