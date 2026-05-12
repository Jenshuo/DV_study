class transaction;
  
  rand bit [7:0] a;
  rand bit [7:0] b;
  rand bit wr;
  
endclass


class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    for (int i=0; i<10; i++) begin
      tr = new();
      assert(tr.randomize());
      mbx.put(tr);
      $display("[GEN] SEND tr : a = %0d, b = %0d, wr = %0b, time = %0t", tr.a, tr.b, tr.wr, $time);
      #10;
    end
  endtask
  
endclass



class driver;
  
  transaction tr;
  mailbox #(transaction) mbx;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(tr);
      $display("[DEV] RCVD tr : a = %0d, b = %0d, wr = %0b, tiime = %0t", tr.a, tr.b, tr.wr, $time);
      #10;
    end
  endtask
  
endclass



module tb;
  
  generator gen;
  driver drv;
  
  mailbox #(transaction) mbx;
  
  
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