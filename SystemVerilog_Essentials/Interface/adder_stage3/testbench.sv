class transaction;
  
  randc bit [3:0] a;
  randc bit [3:0] b;
  bit [4:0] sum;
  
  function string display();
    return $sformatf ("[TR] a = %0d, b = %0d", a, b);
  endfunction
  
  function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
  endfunction
  
endclass


interface add_if;
  
  logic clk;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  
  modport DRV_IF (output a, b, input clk, sum);
  
endinterface


class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  
  
  event drv_done;
  
  function new(mailbox #(transaction) mbx, event drv_done);
    tr = new();
    this.mbx = mbx;
    this.drv_done = drv_done;
  endfunction
  
  task run();
    
    for (int i=0; i<10; i++) begin
      assert(tr.randomize());
      $display("[GEN] %0s, time = %0t", tr.display(), $time);
      //tr.display();
      mbx.put(tr.copy);
      #5;
      wait(drv_done.triggered);
    end
    
  endtask
  
endclass


class driver;
  
  transaction tr;
  mailbox #(transaction) mbx;
  
  event drv_done;
  
  virtual add_if.DRV_IF aif;
  
  function new(mailbox #(transaction) mbx, virtual add_if.DRV_IF aif);
    this.mbx = mbx;
    this.aif = aif;
  endfunction
  
  task run();
    
    forever begin
      mbx.get(tr);
      @(posedge aif.clk);
      aif.a <= tr.a;
      aif.b <= tr.b;
      
      #1;
      $display("[DRV] Send intf a = %0d, b = %0d, time = %0t", aif.a, aif.b, $time);
      -> drv_done;
    end
    
  endtask
  
endclass


module tb;
  
  generator gen;
  driver drv;
  
  mailbox #(transaction) mbx;
  
  add_if aif();
  
  event drv_done;
  
  
  initial begin
    mbx = new();
    drv = new(mbx, aif);
    drv_done = drv.drv_done;
    gen = new(mbx, drv_done);
  end
  
  initial begin
    fork
      gen.run();
      drv.run();
    join_any
    $finish;
  end
  
  
  initial begin
    aif.clk = 0;
    forever begin
      #(20.0/2.0) aif.clk = ~aif.clk;
    end
  end
  
  
  adder u_adder (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));
  
  initial begin
    $dumpfile("adder.vcd");
    $dumpvars;
  end
  
  
endmodule