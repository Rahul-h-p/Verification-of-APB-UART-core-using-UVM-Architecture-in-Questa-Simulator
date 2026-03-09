class uart_reg_block extends uvm_reg_block;

  rand uart_lcr_reg lcr;
  rand uart_ier_reg ier;
rand uart_rxd_reg rxd;
  rand uart_txd_reg txd;
  rand uart_fcr_reg fcr;
  rand uart_iir_reg iir;
  rand uart_mcr_reg mcr;
  rand uart_lsr_reg lsr;
  rand uart_msr_reg msr;
  rand uart_div1_reg div1;
  rand uart_div2_reg div2;
  
  `uvm_object_utils(uart_reg_block)

  function new (string nmae="uart_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    ier=uart_ier_reg::type_id::create("ier", , get_full_name());
    lcr=uart_lcr_reg::type_id::create("lcr");
    rxd=uart_rxd_reg::type_id::create("rxd", , get_full_name());
    txd=uart_txd_reg::type_id::create("txd", , get_full_name());
    fcr=uart_fcr_reg::type_id::create("fcr", , get_full_name());
    iir=uart_iir_reg::type_id::create("iir", , get_full_name());
    mcr=uart_mcr_reg::type_id::create("mcr", , get_full_name());
    lsr=uart_lsr_reg::type_id::create("lsr", , get_full_name());
    msr=uart_msr_reg::type_id::create("msr", , get_full_name());
    div1=uart_div1_reg::type_id::create("div1", , get_full_name());
    div2=uart_div2_reg::type_id::create("div2", , get_full_name());

    ier.build();
    ier.configure(this,null,"");

    lcr.build();
    lcr.configure(this);

    rxd.build();
    rxd.configure(this,null,"");

    txd.build();
    txd.configure(this);

    fcr.build();
    fcr.configure(this,null,"");

    iir.build();
    iir.configure(this);

    lsr.build();
    lsr.configure(this,null,"");

    mcr.build();
    mcr.configure(this);

    msr.build();
    msr.configure(this,null,"");

   div1.build();
    div1.configure(this);

    div2.build();
    div2.configure(this);
  //create map
    default_map = create_map("default_map",0,4,UVM_LITTLE_ENDIAN);
    // add register to map
    default_map.add_reg(rxd, 'h00,"RO");
    default_map.add_reg(txd,'h00,"WO");
    default_map.add_reg(ier,'h04,"RW");
    default_map.add_reg(iir,'h08,"RO");
    default_map.add_reg(fcr,'h08,"WO");
    default_map.add_reg(lcr,'h0c,"RW");
    default_map.add_reg(mcr,'h10,"RW");
    default_map.add_reg(lsr,'h14,"RO");
    default_map.add_reg(msr,'h18,"RO");
    default_map.add_reg(div1,'h1C,"RW");
    default_map.add_reg(div2,'h20,"RW");
    
    lcr.add_hdl_path_slice("LCR",0.7);
    ier.add_hdl_path_slice("IER",0,7);

    //set_hdl_path("tb_top.dut.reg_module_instnace");
    add_hdl_path("top.dut1.control","RTL");

  endfunction

endclass
