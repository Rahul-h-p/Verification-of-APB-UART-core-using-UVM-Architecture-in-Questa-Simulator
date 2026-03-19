lass uart_agent_top extends uvm_env;
`uvm_component_utils(uart_agent_top)
uart_agent rdagnth[];
uart_env_config e_cfg;
function new(string name="uart_agent_top",uvm_component parent);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(uart_env_config)::get(this,"","uart_env_config",e_cfg))
	`uvm_fatal("CONFIG","Cannot get env_config")
rdagnth=new[e_cfg.has_no_of_agent];
foreach(rdagnth[i])
begin
rdagnth[i]=uart_agent::type_id::create($sformatf("rdagnth[%0d]",i),this);
uvm_config_db#(uart_agent_config)::set(this,$sformatf("rdagnth[%0d]*",i),"uart_agent_config",e_cfg.s_cfg[i]);
end
endfunction

task run_phase(uvm_phase phase);
uvm_top.print_topology();
endtask
endclass
