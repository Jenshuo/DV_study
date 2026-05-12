class Transaction;
  
  rand bit [3:0] din1, din2;
  rand bit [4:0] dout;
  
endclass


class Generator;
  
  Transaction tr;
  mailbox #(Transaction) mbx;
  
  function new(mailbox #(Transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    for (int i=0; i<10; i++) begin
      tr = new();
      assert(tr.randomize());
      mbx.put(tr);
      $display("[GEN] SEND tr : din1 = %0d, din2 = %0d, time = %0t", tr.din1, tr.din2, $time);
      #10;
    end
  endtask
  
endclass


class Driver;
  
  Transaction tr;
  mailbox #(Transaction) mbx;
  
  function new(mailbox #(Transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(tr);
      $display("[DRV] RCVD tr : din1 = %0d, din2 = %0d, time = %0t", tr.din1, tr.din2, $time);
      #10;
    end
  endtask
  
endclass


module tb;
  
  Generator gen;
  Driver drv;
  
  mailbox #(Transaction) mbx;
  
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