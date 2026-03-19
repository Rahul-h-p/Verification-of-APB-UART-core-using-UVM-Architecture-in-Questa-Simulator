class apb_seq extends uvm_sequence #(write_xtn);
`uvm_object_utils(apb_seq)

bit [7:0] LCR;
function new(string name="apb_seq");
super.new();
endfunction
task body();
	if(!uvm_config_db#(bit [7:0])::get(null,get_full_name(),"lcr",LCR))
	begin
		`uvm_fatal(get_full_name(),"Cannot get LCR in seq")
	end

endtask
endclass

//-------------------------HALF DUPLEX SEQ---------------------------
class apb_halfduplex_seq extends apb_seq;
`uvm_object_utils(apb_halfduplex_seq)

write_xtn req;
function new(string name="apb_halfduplex_seq");
	super.new(name);
endfunction

task body();
	super.body();

req=write_xtn::type_id::create("req");
//Divisor MSB
start_item(req);
assert(req.randomize() with {Paddr==32'h20;Pwrite==1;Pwdata==0;});
finish_item(req);
//Divisor LSB
start_item(req);
assert(req.randomize() with {Paddr==32'h1c;Pwrite==1;Pwdata==54;});
finish_item(req);
//LCR configuration
start_item(req);
assert(req.randomize() with {Paddr==32'h0c;Pwrite==1;Pwdata==LCR;});
finish_item(req);
//FIFO enable
start_item(req);
assert(req.randomize() with {Paddr==32'h08;Pwrite==1;Pwdata==32'h6;});
finish_item(req);
//Interupt enable
start_item(req);
assert(req.randomize() with {Paddr==32'h04;Pwrite==1;Pwdata==32'h01;});
finish_item(req);
endtask
endclass


//-------------------------FULL DUPLEX SEQ---------------------------
class apb_fullduplex_seq extends apb_seq;
`uvm_object_utils(apb_fullduplex_seq)
write_xtn req;
function new(string name="apb_fullduplex_seq");
	super.new(name);
endfunction

task body();
	super.body();
req=write_xtn::type_id::create("req");
//Divisor MSB
start_item(req);
assert(req.randomize() with {Paddr==32'h20;Pwrite==1;Pwdata==0;});
finish_item(req);
//Divisor LSB
start_item(req);
assert(req.randomize() with {Paddr==32'h1c;Pwrite==1;Pwdata==54;});
finish_item(req);
//LCR configuration
start_item(req);
assert(req.randomize() with {Paddr==32'h0c;Pwrite==1;Pwdata==LCR;});
finish_item(req);
//FIFO enable
start_item(req);
assert(req.randomize() with {Paddr==32'h08;Pwrite==1;Pwdata==32'h6;});
finish_item(req);
//Interupt enable
start_item(req);
assert(req.randomize() with {Paddr==32'h04;Pwrite==1;Pwdata==32'h01;});
finish_item(req);
endtask
endclass

//-------------------------LOOPBACK MODE---------------------------
class apb_loopback_seq extends apb_seq;
`uvm_object_utils(apb_loopback_seq)
write_xtn req;
function new(string name="apb_loopback_seq");
	super.new(name);
endfunction

task body();
	super.body();
req=write_xtn::type_id::create("req");
//Divisor MSB
start_item(req);
assert(req.randomize() with {Paddr==32'h20;Pwrite==1;Pwdata==0;});
finish_item(req);
//Divisor LSB
start_item(req);
assert(req.randomize() with {Paddr==32'h1c;Pwrite==1;Pwdata==54;});
finish_item(req);
//LCR configuration
start_item(req);
assert(req.randomize() with {Paddr==32'h0c;Pwrite==1;Pwdata==LCR;});
finish_item(req);
//FIFO enable FCR
start_item(req);
assert(req.randomize() with {Paddr==32'h08;Pwrite==1;Pwdata==32'h6;});
finish_item(req);
//Interupt enable IER
start_item(req);
assert(req.randomize() with {Paddr==32'h04;Pwrite==1;Pwdata==32'h01;});
finish_item(req);
//MCR configuration- ENABLE LOOPBACK
start_item(req);
assert(req.randomize() with {Paddr==32'h04;Pwrite==1;Pwdata==32'b00010000;});
finish_item(req);
//THR
start_item(req);
assert(req.randomize() with {Paddr==32'h00; Pwrite==1;Pwdata inside {[1:255]};});
finish_item(req);

endtask
endclass
//-----------------------Read seq--------------------
class apb_rd_seq extends apb_seq;
`uvm_object_utils(apb_rd_seq)
write_xtn req;
function new (string name="apb_rd_seq");
	super.new(name);
endfunction

task body();
	super.body();

req=write_xtn::type_id::create("req");
//IIR
start_item(req);
assert(req.randomize() with {Paddr==32'h08; Pwrite==0;});
finish_item(req);
get_response(req);

if(req.iir[3:0]==4'h4) begin
start_item(req);
assert(req.randomize() with {Paddr==32'h00; Pwrite==0;});
finish_item(req);
end

if(req.iir[3:0]==4'h6) begin
start_item(req);
assert(req.randomize() with {Paddr==32'h14; Pwrite==0;});
finish_item(req);
end

if(req.iir[3:0]==4'h8) begin
start_item(req);
assert(req.randomize() with {Paddr==32'h00; Pwrite==0;});
finish_item(req);
end
endtask
endclass
