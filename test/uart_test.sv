class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	bit[7:0] lcr;
	
	uart_env envh;
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
			if(!uvm_config_db #(virtual apb_if)::get(this,"","avif",m_agt_cfg.vif))
				begin
				`uvm_fatal("CONFIG","Not able to get the apb vif")
				end
				m_agt_cfg[i].is_active=UVM_ACTIVE;
				e_cfg.m_cfg[i]=m_agt_cfg[i];
			end 
			
			foreach(s_agt_cfg[i])
			begin
			s_agt_cfg[i]=uart_agent_config::type_id::create($sformatf("s_agt_cfg[%0d]",i));
			if(!uvm_config_db #(virtual uart_if)::get(this,"","uvif",s_agt_cfg.vif))
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
e_cfg=env_config::type_id::create("e_cfg");
envh=
