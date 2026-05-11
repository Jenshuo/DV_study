class transaction;
  
  randc bit [3:0] din1;
  rand  bit [3:0] din2;
  bit [4:0] dout;
  
endclass


class generator;
  
  transaction tr;
  transaction tr_c;
  
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    
    // randc feature : when new(), the memory will be vanish, so need to keep the handler
    tr_c = new();
    for(int i=0; i<20; i++) begin
      
      // create new object (memory location)
      tr = new();
      
      assert(tr.randomize());
      assert(tr_c.randomize());
      
      // copy randc value
      tr.din1 = tr_c.din1;
      
      mbx.put(tr);
      $display("[GEN] SEND TR : din1 = %0d, din2 = %0d, time = %0t", tr.din1, tr.din2, $time);
      #10;
    end
  endtask
  
endclass


class driver;
  
  transaction tr;
  
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(tr);
      $display("[DRV] RCVD TR : din1 = %0d, din2 = %0d, time = %0t", tr.din1, tr.din2, $time);
      #50;
    end
  endtask
  
endclass


module tb;
  
  generator gen;
  driver drv;
  mailbox mbx;
  
  initial begin
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    
    
    fork
      gen.run();
      drv.run();
    join
    
  end
  
endmodule