class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  env_config m_cfg;

  uvm_tlm_analysis_fifo #(apb_xtn) fifo_w;
  uvm_tlm_analysis_fifo #(uart_xtn) fifo_r;

  apb_xtn uart1;
  uart_xtn uart2,uart3;
  apb_xtn cov_data1;
  uart_xtn cov_data2;
  bit[7:0] rx[$], tx[$];
  int thrlsize, rbrlsize;

  function new(string name="scoreboard", uvm_component parent);
    super.new(name,parent);
    apb_signals_cov=new();
    apb_lcr_cov =new();
    apb_ier_cov =new();
    apb_fcr_cov =new();
    apb_mcr_cov =new();
    apb_iir_cov =new();
    apb_lsr_cov =new();
  endfunction
        
  covergroup apb_signals_cov;
    option.per_instance=1;

    ADDRESS: coverpoint cov_data1.Paddr {bins add={[0:255]};}
    WR_ENB: coverpoint cov_data1.Pwrite {bins rd={0};
                                         bins wr={1};}
  endgroup


  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
      `uvm_fatal("CONFIG","cannot get config")
      fifo_w=new["fifo_w",this];
    fifo_r=new["fifo_r",this];
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    begin
      fork
        forever begin
          fifo_w.get(uart1);
          uart1.print;
          thrlsize=uart1.thr.size;
          rbrlsize=uart1.rbr.size;
          `uvm_info("SCOREBOARD",$sformatf("printing from scoreboard of uart1 \n %s", uart1.sprint()),UVM_LOW)
          cov_data1=uart1;
        end

        forever begin
          fifo_r.get(uart2);
          `uvm_info("SB UART2", "PRINTING UART2 DATA IN SCOREBOARD", UVM_LOW)
          uart2.print;
          cov_data2=uart2;
          `uvm_info("SCOREBOARD", $sformatf("printing from scoreboard of uart2 \n %s", uart2.sprint()),UVM_LOW)
        end
      join
    end
    apb_signals_cov.sample();
    apb_lcr_cov.sample();
    apb_ier_cov.sample();
    apb_fcr_cov.sample();
    apb_mcr_cov.sample();
    apb_iir_cov.sample();
    apb_lsr_cov.sample();
  endtask

  function void check_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("size of thr 1=%0d", thrlsize),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("size of rbr 1=%0d", rbrlsize),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("values of uart1 =%p", uart1.thr),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("values of uart2 =%p", uart2.tx),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("values of uart1 =%p", uart1.rbr),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("values of uart2 =%p", uart2.tx),UVM_LOW)

    if((uart1.iir[3:1] ==3'b010)) begin
      if((uart1.mcr[4] ==0)) begin
        if(uart1.thr.size()==0) begin
          if((uart1.Pwdata[7:0]==uart2.rx)||(uart2.tx==uart1.Prdata[7:0]))
            `uvm_info(get_type_name(),"\n Scoreboard half duplex comparison passed",UVM_LOW)
            else
              `uvm_info(get_type_name(),"\n Scoreboard half duplex comparison failed", UVM_LOW)
              end
              else begin
                if((uart1.Pwdata[7:0]==uart2.rx) && (uart2.tx == uart1.Prdata[7:0]))
                  `uvm_info(get_type_name(),"\n Scoreboard half duplex comparison passed",UVM_LOW)
            else
              `uvm_info(get_type_name(),"\n Scoreboard half duplex comparison failed", UVM_LOW)
              end
              end
              else begin
                if((uart1.Pwdata[7:0]==uart1.Prdata[7:0]))
                  `uvm_info(get_type_name(),"\n Scoreboard loopback comparison passed",UVM_LOW)
                  else
                    `uvm_info(get_type_name(),\n"Scoreboard loopback comparison failed",UVM_LOW)
                    end

                    end

                    if(uart1.iir[3:1] == 3) begin
                      if(uart1.lsr[1]==1)
                        `uvm_info(get_type_name(),"\nFrom Scoreboard= overrun error", UVM_LOW)
                        if(uart1.lsr[2]==1)
                          `uvm_info(get_type_name(),"\n From Scoreboard= parity error", UVM_LOW)
                          if(uart1.lsr[3] ==1)
                            `uvm_info(get_type_name(),"\n From Scoreboard= framing error", UVM_LOW)
                            if(uart1.lsr[4]==1)
                              `uvm_info(get_type_name(),"\n From Scoreboard= break interrupt error",UVM_LOW)
                              end
                              if(uart1.iir[3:1]==3'b110)
                                `uvm_info(get_type_name(),"\n From Scoreboard= timeout error",UVM_LOW)
                                if(uart1.iir[3:1]==3'b001)
                                  `uvm_info(get_type_name(),"\n From Scoreboard= thr empty error", UVM_LOW)
                                  endfunction
