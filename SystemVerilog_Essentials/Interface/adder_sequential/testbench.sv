interface add_if;
  
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  logic clk;
  
endinterface


class driver;
  
  // pointer/handle to the tb interface
  virtual add_if aif;
  
  task run();
    
    forever begin
      @(posedge aif.clk);
      aif.a <= $urandom;
      aif.b <= $urandom;
      
      #1;
      $display("[DRV] a = %0d, b = %0d, time = %0t", aif.a, aif.b, $time);
    end
    
  endtask
  
endclass


module tb;
  
  add_if aif();
  
  add u_add (.clk(aif.clk), .a(aif.a), .b(aif.b), .sum(aif.sum));
  
  // Driver
  driver drv;
  
  initial begin
    drv = new();
    
    // Connect real interface(static) to class interface handle (dynamic)
    drv.aif = aif;
    
    drv.run();
  end
  
  
  initial begin
    aif.clk = 0;
    forever begin
      #(20.0 / 2.0) aif.clk = ~aif.clk;
    end
  end
  
  initial begin
    $dumpfile("add.vcd");
    $dumpvars;
    #100;
    $finish;
  end
  
  
endmodule