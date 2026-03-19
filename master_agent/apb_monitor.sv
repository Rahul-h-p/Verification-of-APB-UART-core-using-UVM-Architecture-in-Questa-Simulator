class apb_monitor extends uvm_monitor;
`uvm_component_utils(apb_monitor)
apb_agent_config m_cfg;
virtual apb_if.MON_MP vif;

write_xtn xtn;
uvm_analysis_port#(write_xtn) monitor_port;

function new(string name="apb_monitor", uvm_component parent);
super.new(name,parent);
monitor_port=new("monitor_port",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",m_cfg))
`uvm_fatal("CONFIG","cannot get apb_config")

xtn=write_xtn::type_id::create("xtn");
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=m_cfg.vif;
endfunction

task  run_phase(uvm_phase phase);
forever
begin
collect_data();
end
endtask

task collect_data();
@(vif.mon_cb);
while(vif.mon_cb.Penable!==1)
@(vif.mon_cb);

begin: transfer_capture

while(vif.mon_cb.Pready!==1)
@(vif.mon_cb);

xtn.Presetn=vif.mon_cb.Presetn;
xtn.Paddr=vif.mon_cb.Paddr;
xtn.Pwrite=vif.mon_cb.Pwrite;
xtn.Pslverr=vif.mon_cb.Pslverr;
xtn.Psel=vif.mon_cb.Psel;
xtn.Penable=vif.mon_cb.Penable;
xtn.IRQ=vif.mon_cb.IRQ;

if(xtn.Pwrite)
	xtn.Pwdata=vif.mon_cb.Pwdata;
else
	xtn.Prdata=vif.mon_cb.Prdata;
//LCR update
if(xtn.Paddr==32'hc && xtn.Pwrite==1'b1)
	xtn.lcr=xtn.Pwdata;
//IER  update
if(xtn.Paddr==32'h4 && xtn.Pwrite==1'b1)
	xtn.ier=xtn.Pwdata;
//FCR update
if(xtn.Paddr==32'h8 && xtn.Pwrite==1'b1)
	xtn.fcr=xtn.Pwdata;
//IIR update
if(xtn.Paddr==32'h8 && xtn.Pwrite==1'b0) begin : iir_block
	while(vif.mon_cb.IRQ!==1)
	@(vif.mon_cb);

	xtn.iir=vif.mon_cb.Prdata;
end: iir_block

//MCR update
if(xtn.Paddr==32'h10 && xtn.Pwrite==1'b1)
	xtn.mcr=xtn.Pwdata;

//LSR update
if(xtn.Paddr==32'h14 && xtn.Pwrite==1'b0)
	xtn.lsr=xtn.Prdata;

//DIVISOR update
if(xtn.Paddr==32'h1c && xtn.Pwrite==1'b1) begin: divisor_lsb
	xtn.divisor[7:0]=xtn.Pwdata;
	xtn.dl_access=1'b1;
end: divisor_lsb

//DIVISOR update
if(xtn.Paddr==32'h1c && xtn.Pwrite==1'b1) begin: divisor_msb
	xtn.divisor[15:8]=xtn.Pwdata;
	xtn.dl_access=1'b1;
end: divisor_msb

//THR write
if(xtn.Paddr==32'h0 && xtn.Pwrite==1'b1) begin: thr_block
	xtn.data_in_thr=1'b1;
	xtn.thr.push_back(xtn.Prdata);
end:thr_block
//RBR write
if(xtn.Paddr==32'h0 && xtn.Pwrite==1'b0) begin: rbr_block
	xtn.data_in_rbr=1'b1;
	xtn.rbr.push_back(xtn.Prdata);
end:rbr_block

end: transfer_capture

monitor_port.write(xtn);
endtask: collect_data
endclass
