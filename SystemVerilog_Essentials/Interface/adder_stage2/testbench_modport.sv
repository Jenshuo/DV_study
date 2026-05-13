interface add_if;
  
  logic clk;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  
  modport DRV_IF (output a, b, input sum, clk);
  
endinterface


class driver;
  
  // modport advantage: only access signals in the modport, avoid accidental access to other signals in the interface
  // ex : aif.sum <= 5 => error because sum is not in DRV_IF modport output list
  virtual add_if.DRV_IF aif;
  
  task run();
    forever begin
      @(posedge aif.clk);
      aif.a <= $urandom;
      aif.b <= $urandom;
      
      #1
      $display("[DRV] a = %0d, b = %0d, time = %0t", aif.a, aif.b, $time);
    end
  endtask
  
endclass


module tb;
  
  add_if aif();
  
  driver drv;
  
  adder u_adder (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));
  
  initial begin
    drv = new();
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
    $dumpfile("adder.vcd");
    $dumpvars;
    #100;
    $finish;
  end
  
endmodule