class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uart_env_config m_cfg;

  uvm_tlm_analysis_fifo #(write_xtn) fifo_w;
  uvm_tlm_analysis_fifo #(read_xtn) fifo_r;

  write_xtn uart1;
  read_xtn uart2,uart3;
  write_xtn cov_data1;
  read_xtn cov_data2;// coverage is pending
  //bit[7:0] rx[$], tx[$];
  int thrlsize, rbrlsize;
        
  covergroup apb_signals_cov;
    option.per_instance=1;

    ADDRESS: coverpoint cov_data1.Paddr {bins add={[0:255]};}
    WR_ENB: coverpoint cov_data1.Pwrite {bins rd={0};
                                         bins wr={1};}
    ERROR: coverpoint cov_data1.Pslverr {bins p1={0};
                                        bins p2={1};}
  endgroup

covergroup apb_lcr_cov;
  option.per_instance=1;

  CHAR_SIZE: coverpoint cov_data1.lcr[1:0] {bins five={2'b00};
                                            bins eight={2'b11};}
  STOP_BIT: coverpoint cov_data1.lcr[2] {bins one={1'b0};
                                         bins more={1'b1};}
  PARITY: coverpoint cov_data1.lcr[3] {bins no_parity ={1'b0};
                                      bins parity_en={1'b1};}
  Ev_odd_parity: coverpoint cov_data1.lcr[4] {bins odd_parity={1'b0};
                                              bins even_parity={1'b1};}
  STICK_PARITY: coverpoint cov_data1.lcr[5] {bins odd_parity = {1'b0};
                                             bins even_parity=  {1'b1};}
  BREAK: coverpoint cov_data1.lcr[6] {bins low={1'b0};
                                     bins high={1'b1};}
  DIV_LCH: coverpoint cov_data1.lcr[7] {bins low = {1'b0};
                                       bins high={1'b1};}
  LCR_RST: coverpoint cov_data1.lcr[7:0] {bins lcr_rst ={8'd3};}
  cross_cover: cross CHAR_SIZE,STOP_BIT,  PARITY,  Ev_odd_parity,  STICK_PARITY, BREAK,  DIV_LCH, LCR_RST;
endgroup

  covergroup apb_ier_cov;
    option.per_instance=1;
    RCVD_INT: coverpoint cov_data1.ier[0] { bins dis={1'b0};
                                           bins en={1'b1};}
    THRE_INT: coverpoint cov_data1.ier[1] { bins dis = {1'b0};
                                           bins en={1'b1};}
    LSR_INT: coverpoint cov_data1.ier[2] { bins dis = {1'b0};
                                           bins en={1'b1};}
    IER_INT: coverpoint cov_data1.ier[7:0] { bins ier_rst = {8'd0};}
  endgroup

  covergroup apb_fcr_cov;
    option.per_instance=1;

    RFIFO: coverpoint cov_data1.fcr[1] {bins dis={1'b0};
                                          bins clr={1'b1};}
    TFIFO: coverpoint cov_data1.fcr[2] {bins dis={1'b0};
                                          bins clr={1'b1};}

    TRG_LVL: coverpoint cov_data1.fcr[7:6] {bins one={2'b00};
                                            bins four={2'b01};
                                            bins eight={2'b10};
                                            bins fouteen={2'b11};
                                          }

    FCR_RST: coverpoint cov_data1.fcr[7:0] {bins fcr_rst={8'd192};}
  endgroup

  covergroup apb_mcr_cov;
    option.per_instance=1;
    LB: coverpoint cov_data1.mcr[4] {bins dis ={1'b0};
                                     bins en={1'b1};}
    MCR_RST: coverpoint cov_data1.mcr[7:0] { bins lcr_rst = {8'd0};}
  endgroup

  covergroup apb_iir_cov;
    option.per_instance=1;

    IIR: coverpoint cov_data1.iir[3:1] {bins lsr={3'b001};
                                        bins rdf={3'b010};
                                        bins ti_o ={3'b110};}
    IIR_RST : coverpoint cov_data1.iir[3:0] {bins iir_rst={4'h1};}
  endgroup

  covergroup apb_lsr_cov;
    option.per_instance =1;

    DATA_READY: coverpoint cov_data1.lsr[0] {bins fifoempty = {1'b0};
                                             bins datarcvd= {1'b1};}
    OVER_RUN: coverpoint cov_data1.lsr[1] {bins nooverrun={1'b0};
                                           bins overrun ={1'b1};}
    PARITY_ERR: coverpoint cov_data1.lsr[2] {bins noparityerr ={1'b0};
                                             bins parityerr ={1'b1};}
    FRAME_ERR: coverpoint cov_data1.lsr[3] {bins framerr ={1'b0};}

    BREAK_INT: coverpoint cov_data1.lsr[4] {bins nobreakint = {1'b0};
                                            bins breakint = {1'b1};}
    b1: coverpoint cov_data1.lsr[5] {bins a1={1'b0};
                                     bins a2={1'b1};}
  endgroup
  
    
          
  function new(string name="scoreboard", uvm_component parent);
    super.new(name,parent);
    fifo_w=new("fifo_w",this);
    fifo_r=new("fifo_r",this);

    apb_signals_cov=new();
    apb_lcr_cov =new();
    apb_ier_cov =new();
    apb_fcr_cov =new();
    apb_mcr_cov =new();
    apb_iir_cov =new();
    apb_lsr_cov =new();

  endfunction
                           
                                         
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(uart_env_config)::get(this,"","uart_env_config",m_cfg))
      `uvm_fatal("CONFIG","cannot get config")

uart1 = write_xtn::type_id::create("uart1");
uart2 = read_xtn::type_id::create("uart2");

//uart1.thr = new[8];
//uart1.rbr=new[8];

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
    `uvm_info(get_type_name(),$sformatf("values of uart2 =%p", uart2.rx),UVM_LOW)

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
                    `uvm_info(get_type_name(),"\nScoreboard loopback comparison failed",UVM_LOW)
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
                                  endclass
