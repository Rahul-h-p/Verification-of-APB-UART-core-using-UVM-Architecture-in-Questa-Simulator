class uart_test extends uvm_test;
	`uvm_component_utils(uart_test)
	bit[7:0] lcr;
	
	uart_tb envh;
	uart_env_config e_cfg;
	apb_agent_config m_agt_cfg[];
	uart_agent_config s_agt_cfg[];
	
	bit has_agent=1;
	int has_no_of_agent =1;
	bit has_virtual_seqr=1;
	bit has_scoreboard=1;
	
function new (string name="base_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void config_test();
	if(has_agent)
		begin
			m_agt_cfg=new[has_no_of_agent];
			s_agt_cfg=new[has_no_of_agent];
			
			foreach(m_agt_cfg[i])
			begin
			m_agt_cfg[i]=apb_agent_config::type_id::create($sformatf("m_agt_cfg[%0d]",i));
			if(!uvm_config_db #(virtual apb_if)::get(this,"","avif",m_agt_cfg[i].vif))
				begin
				`uvm_fatal("CONFIG","Not able to get the apb vif")
				end
				m_agt_cfg[i].is_active=UVM_ACTIVE;
				e_cfg.m_cfg[i]=m_agt_cfg[i];
			end 
			
			foreach(s_agt_cfg[i])
			begin
			s_agt_cfg[i]=uart_agent_config::type_id::create($sformatf("s_agt_cfg[%0d]",i));
			if(!uvm_config_db #(virtual uart_if)::get(this,"","uvif",s_agt_cfg[i].vif))
				begin
				`uvm_fatal("CONFIG","Not able to get the uart vif")
				end
				s_agt_cfg[i].is_active=UVM_ACTIVE;
				e_cfg.s_cfg[i]=s_agt_cfg[i];
			end 
		end
		
	e_cfg.has_agent=has_agent;
	e_cfg.has_no_of_agent=has_no_of_agent;
	e_cfg.has_virtual_seqr=has_virtual_seqr;
	e_cfg.has_scoreboard=has_scoreboard;
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	e_cfg=uart_env_config::type_id::create("e_cfg");
	if(has_agent)
			begin
				e_cfg.m_cfg=new[has_no_of_agent];
				e_cfg.s_cfg=new[has_no_of_agent];
			end
	config_test();
	uvm_config_db #(uart_env_config)::set(this,"*","uart_env_config",e_cfg);
	uvm_config_db #(bit [7:0])::set(this,"*","lcr",lcr);
	envh=uart_tb::type_id::create("uart_tb",this);
endfunction
endclass

class test_halfduplex extends uart_test;
`uvm_component_utils(test_halfduplex)

apb_halfduplex_seq aphdseq;
uart_halfduplex_seq uahdseq;
apb_rd_seq read1;
function new(string name="test_halfduplex",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	lcr=32'h03;
	super.build_phase(phase);
	aphdseq=apb_halfduplex_seq::type_id::create("aphdseq");
	uahdseq=uart_halfduplex_seq::type_id::create("uahdseq");
	read1=apb_rd_seq::type_id::create("read1");

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);

	phase.raise_objection(this);

	aphdseq.start(envh.wragt_toph.wragnth[0].seqrh);
	uahdseq.start(envh.rdagt_toph.rdagnth[0].seqrh);
	read1.start(envh.wragt_toph.wragnth[0].seqrh);
	#2000;
	phase.drop_objection(this);
endtask
endclass
class test_fullduplex extends uart_test;
`uvm_component_utils(test_fullduplex)

apb_fullduplex_seq aphdseq;
uart_fullduplex_seq uahdseq;
apb_rd_seq read1;
	function new(string name="test_fullduplex",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	lcr=32'h03;
	super.build_phase(phase);
aphdseq=apb_fullduplex_seq::type_id::create("aphdseq");
	uahdseq=uart_fullduplex_seq::type_id::create("uahdseq");
	read1=apb_rd_seq::type_id::create("read1");

endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	phase.raise_objection(this);

	aphdseq.start(envh.wragt_toph.wragnth[0].seqrh);
	uahdseq.start(envh.rdagt_toph.rdagnth[0].seqrh);
	read1.start(envh.wragt_toph.wragnth[0].seqrh);
	#2000;
	phase.drop_objection(this);
endtask


endclass
