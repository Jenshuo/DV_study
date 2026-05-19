class monitor;
  
  virtual dff_if vif;
  
  transaction tr;
  event drv_done;
  
  // mailbox : mon <-> scb
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction
  
  task run();
    forever begin
      wait(drv_done.triggered);
      repeat(2) @(posedge vif.clk);
      tr.dout = vif.dout;
      mbx.put(tr);
      tr.display("MON");
    end
  endtask
  
endclass