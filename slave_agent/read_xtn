class read_xtn extends uvm_sequence_item;
`uvm_object_utils(read_xtn)

rand bit [7:0] tx;
bit [7:0] rx;
bit parity;
rand bit stop_bit;
bit bad_parity;

bit [7:0] LCR;

int bits;

function new(string name="read_xtn");
super.new(name);
endfunction

function void do_print(uvm_printer printer);
super.do_print(printer);

printer.print_field("tx",this.tx,8,UVM_BIN);
printer.print_field("rx",this.rx,8,UVM_BIN);
endfunction

function void post_randomize();
bits =LCR[1:0]+5;

if(bad_parity==0) begin
	if(LCR[3]) begin
		parity=0;
		for(int i=0;i<bits;i++) begin
		parity^=tx[i];
		end
	end
end
else begin
parity=~parity;
end
endfunction

endclass
