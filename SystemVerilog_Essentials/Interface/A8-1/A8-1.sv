class transaction;
  
  randc bit [3:0] a;
  randc bit [3:0] b;
  bit [7:0] mul;
  
  function string display();
    return $sformatf("TR : a = %0d, b = %0d", a, b);
  endfunction
  
  function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
  endfunction
  
endclass

interface mul_if;
  
  logic [3:0] a;
  logic [3:0] b;
  logic [7:0] mul;
  
  logic clk;
  
  modport DRV_IF (output a, b, input mul, clk);
  
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
      mbx.put(tr.copy());
      #5;
      wait(drv_done.triggered);
    end
    
  endtask
  
endclass


class driver;
  
  virtual mul_if.DRV_IF mif;
  
  mailbox #(transaction) mbx;
  transaction tr;
  
  event drv_done;
  
  
  function new(mailbox #(transaction) mbx, virtual mul_if.DRV_IF mif, event drv_done);
    this.mbx = mbx;
    this.mif = mif;
    this.drv_done = drv_done;
  endfunction
    
    
  task run();
    
    forever begin
      mbx.get(tr);
      
      @(posedge mif.clk);
      mif.a <= tr.a;
      mif.b <= tr.b;
      
      #1;
      $display("[DRV] interface a = %0d, b = %0d, time = %0t", mif.a, mif.b, $time);
      
      -> drv_done;
    end
    
  endtask
  
endclass


module tb;
  
  mul_if mif();
  
  generator gen;
  driver drv;
  
  mailbox #(transaction) mbx;
  
  event drv_done;
  
  initial begin
    mbx = new();
    drv = new(mbx, mif, drv_done);
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
    mif.clk = 0;
    forever begin
      #(20.0 / 2.0) mif.clk = ~mif.clk;
    end
  end
  
  mutiplier dut(.a(mif.a), .b(mif.b), .mul(mif.mul), .clk(mif.clk));
  
  
  initial begin
    $dumpfile("mul.vcd");
    $dumpvars;
  end
  
  
endmodule