class driver;
  
  transaction tr;
  
  // mbx : gen <-> driver
  mailbox #(transaction) mbx;
  
  virtual dff_if vif;
  event drv_done;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task reset();
    vif.rst_n = 1'b1;
    #5;
    vif.rst_n = 1'b0;
    vif.din = 1'b0;
    #5;
    vif.rst_n = 1'b1;
    $display("[DRV] REST DONE!!");
  endtask
  
  
  task run();
    forever begin
      mbx.get(tr);
      @(posedge vif.clk);
      vif.din <= tr.din;
      tr.display("DRV");
      -> drv_done;
      @(posedge vif.clk);
      vif.din <= 1'b0;
    end
  endtask
  
  
endclass