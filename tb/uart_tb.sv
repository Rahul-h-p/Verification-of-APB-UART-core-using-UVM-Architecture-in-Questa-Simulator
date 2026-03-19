class uart_tb extends uvm_env;
`uvm_component_utils(uart_tb)

apb_agent_top wragt_toph;
uart_agent_top rdagt_toph;
scoreboard scrh;
uart_env_config e_cfg;

function new(string name="uart_tb", uvm_component parent);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",e_cfg))
begin
	`uvm_fatal("CONFIG","Cannot get_env_conig")
end
if(e_cfg.has_agent)
begin
wragt_toph=apb_agent_top::type_id::create("wragt_toph",this);
end
if(e_cfg.has_agent)
begin
rdagt_toph=uart_agent_top::type_id::create("rdagt_toph",this);
end
if(e_cfg.has_scoreboard)
begin
scrh=scoreboard::type_id::create("scrh",this);
end
endfunction

function void connect_phase(uvm_phase phase);
	//connect scoreboard
if (wragt_toph == null) 
begin
  `uvm_fatal("DEBUG", "wragt_toph is NULL at connect_phase!")
end
else if (scrh == null) 
begin
  `uvm_fatal("DEBUG", "scrh is NULL at connect_phase!")
end

foreach(wragt_toph.wragnth[i]) begin
  if (wragt_toph.wragnth[i] == null) begin
    `uvm_fatal("DEBUG", $sformatf("wragt_toph.wragnth[%0d] is NULL!", i))
  end
  
  $display("DEBUG: Agent %0d type is %s", i, wragt_toph.wragnth[i].get_type_name());
  
  if (wragt_toph.wragnth[i].monh == null) begin
    `uvm_fatal("DEBUG", $sformatf("Monitor in Agent %0d is NULL! Full path: %s", i, wragt_toph.wragnth[i].get_full_name()))
  end
  
  wragt_toph.wragnth[0].monh.monitor_port.connect(scrh.fifo_w.analysis_export);
end
foreach(rdagt_toph.rdagnth[i])
rdagt_toph.rdagnth[0].monh.monitor_port.connect(scrh.fifo_r.analysis_export);

endfunction
endclass
