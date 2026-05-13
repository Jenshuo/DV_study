class transaction;
  
  randc bit [3:0] a;
  randc bit [3:0] b;
  bit [4:0] sum;
  
  function void display();
    $display("[TR] a : %0d, b : %0d", a, b);
  endfunction
  
  function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
  endfunction
  
endclass


class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction
  
  task run();
    
    for (int i=0; i<10; i++) begin
      assert(tr.randomize());
      tr.display();
      mbx.put(tr.copy);
      #10;
    end
    
  endtask
  
endclass


module tb;
  
  generator gen;
  mailbox #(transaction) mbx;
  
  initial begin
    mbx = new();
    gen = new(mbx);
    gen.run();
  end
  
  
  
endmodule