class data_abc;
  
  bit [3:0] a;
  bit [3:0] b;
  bit [3:0] c;
  
  bit [5:0] sum;
  
  function new(input bit [3:0] a = 0, input bit [3:0] b = 0, input bit [3:0] c = 0);
    this.a = a;
    this.b = b;
    this.c = c;
  endfunction
  
  task add_abc;
    sum = a + b + c;
  endtask
  
endclass


module tb;
  
  data_abc d;
  
  initial begin
  
    d = new(.a(1), .b(2), .c(4));
    d.add_abc();
  
    $display("a = %0d, b = %0d, c = %0d, sum = %0d", d.a, d.b, d.c, d.sum);
    
  end
  
endmodule