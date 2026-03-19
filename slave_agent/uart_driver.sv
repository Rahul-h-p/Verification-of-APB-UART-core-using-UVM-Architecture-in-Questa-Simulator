class uart_driver extends uvm_driver#(read_xtn);
`uvm_component_utils(uart_driver)

uart_agent_config m_cfg;
bit[7:0] LCR;
virtual uart_if  vif;
function new(string name="uart_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(uart_agent_config)::get(this,"","uart_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get agent config in driver")

if(!uvm_config_db #(bit [7:0])::get(this,"","lcr",LCR))
	`uvm_fatal("CONFIG","cannot get LCR in driver")

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
vif.tx=1'b1;
forever begin
seq_item_port.get_next_item(req);
`uvm_info("UART_DRIVER","PRINTING FROM UART DRIVER",UVM_LOW)
req.print();
send_to_dut(req);
seq_item_port.item_done();
end
endtask

task send_tx(bit b);
vif.tx<=b;
repeat(16) @(posedge vif.baud_o);
endtask

task send_to_dut(read_xtn xtn);
int bits;

bits=LCR[1:0]+5;

repeat(16) @(posedge vif.baud_o);
vif.tx<=0;

repeat(16) @(posedge vif.baud_o);
for(int i=0;i<bits; i++) begin
	send_tx(xtn.tx[i]);
end

if(LCR[3]) begin
	send_tx(xtn.parity);
end

send_tx(xtn.stop_bit);

//additional wait for specific configuration
if(LCR[2]==1)begin
	if(LCR[1:0]==2'b00) begin
		repeat(8) @(posedge vif.baud_o);
	end
end
endtask




endclass
