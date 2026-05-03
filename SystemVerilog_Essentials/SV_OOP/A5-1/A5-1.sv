class data;
  
  bit [31:0] a;
  bit [31:0] b;
  bit [31:0] c;
  
endclass


module tb();
  
  data d;
  
  initial begin
    d = new();
    
    d.a = 45;
    d.b = 78;
    d.c = 90;
    
    $display("data a = %0d, data b = %0d, data c = %0d", d.a, d.b, d.c);
  end
  
endmodule