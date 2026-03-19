class uart_seq extends uvm_sequence #(read_xtn);
`uvm_object_utils(uart_seq)
bit [7:0] LCR;
function new(string name="uart_seq");
super.new(name);
endfunction
task body();
if(!uvm_config_db#(bit [7:0])::get(null,get_full_name(),"lcr",LCR))
 `uvm_fatal("CONFIG","cannot get the LCR in sequence")
endtask
endclass

class uart_halfduplex_seq extends uart_seq;
`uvm_object_utils(uart_halfduplex_seq)
read_xtn req;
function new(string name="uart_halfduplex_seq");
super.new();
endfunction
task body();
super.body();
req=read_xtn::type_id::create("req");
req.LCR=LCR;
start_item(req);
assert(req.randomize with {stop_bit==1;});
finish_item(req);
endtask
endclass

class uart_fullduplex_seq extends uart_seq;
`uvm_object_utils(uart_fullduplex_seq)
read_xtn req;
function new(string name="uart_fullduplex_seq");
super.new();
endfunction
task body();
super.body();
req=read_xtn::type_id::create("req");
req.LCR=LCR;
start_item(req);
assert(req.randomize with {stop_bit==1;});
finish_item(req);
endtask
endclass

class uart_loopback_seq extends uart_seq;
`uvm_object_utils(uart_loopback_seq)
function new(string name="uart_loopback_seq");
super.new();
endfunction
task body();
super.body();
req=read_xtn::type_id::create("req");
req.LCR=LCR;
start_item(req);
assert(req.randomize with {stop_bit==1;});
finish_item(req);
endtask
endclass
