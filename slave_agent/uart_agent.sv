class uart_agent extends uvm_agent;
`uvm_component_utils(uart_agent)
uart_sequencer seqrh;
uart_driver drvh;
uart_monitor monh;

function new(string name="uart_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
seqrh=uart_sequencer::type_id::create("seqrh",this);
monh=uart_monitor::type_id::create("monh",this);
drvh=uart_driver::type_id::create("drvh",this);

endfunction
function void connect_phase(uvm_phase phase);
drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
endclass
