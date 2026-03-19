class apb_agent_top extends uvm_env;
`uvm_component_utils(apb_agent_top)
apb_agent wragnth[];
uart_env_config e_cfg;
function new(string name="apb_agent_top",uvm_component parent);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(uart_env_config)::get(this,"","uart_env_config",e_cfg))
begin
	`uvm_fatal("CONFIG","not able to get config from env to agent top")
end

wragnth=new[e_cfg.has_no_of_agent];
foreach(wragnth[i])
begin
wragnth[i]=apb_agent::type_id::create($sformatf("wragnth[%0d]",i),this);
uvm_config_db#(apb_agent_config)::set(this,$sformatf("wragnth[%0d]*",i),"apb_agent_config",e_cfg.m_cfg[i]);
end
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction
endclass
