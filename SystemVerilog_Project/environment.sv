class environment;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  virtual dff_if vif;
  event next;
  event gen_done;
  event drv_done;
  
  mailbox #(transaction) gen_drv_mbx;
  mailbox #(transaction) gen_scb_mbx;
  mailbox #(transaction) mon_scb_mbx;
  
  
  function new(virtual dff_if vif);
    gen_drv_mbx = new();
    gen_scb_mbx = new();
    mon_scb_mbx = new();
    
    gen = new(gen_drv_mbx, gen_scb_mbx);
    drv = new(gen_drv_mbx);
    mon = new(mon_scb_mbx);
    scb = new(mon_scb_mbx, gen_scb_mbx);
    
    this.vif = vif;
    drv.vif = this.vif;
    mon.vif = this.vif;
    
    gen.gen_done = gen_done;
    
    gen.scb_done = next;
    scb.scb_done = next;
    
    drv.drv_done = drv_done;
    mon.drv_done = drv_done;
    
  endfunction
  
  
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_any
  endtask
  
  task post_test();
    wait(gen_done.triggered);
    $finish;
  endtask
  
  
  task run();
    pre_test();
    test();
    post_test();
  endtask
  
  
endclass