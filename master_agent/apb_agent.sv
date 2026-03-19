class apb_agent extends uvm_agent;
`uvm_component_utils(apb_agent)
apb_sequencer seqrh;
apb_driver drvh;
apb_monitor monh;

function new(string name="apb_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
seqrh=apb_sequencer::type_id::create("seqrh",this);
monh=apb_monitor::type_id::create("monh",this);
drvh=apb_driver::type_id::create("drvh",this);

endfunction

function void connect_phase(uvm_phase phase);
drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
endclass
