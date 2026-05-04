class data_abc;
  
  bit [7:0] a;
  bit [7:0] b;
  bit [7:0] c;
  
  function new(input bit [7:0] a=0, input bit [7:0] b=0, input bit [7:0] c=0);
    this.a = a;
    this.b = b;
    this.c = c;
  endfunction
  
endclass

module tb;
  
  data_abc d;
  
  initial begin
    d = new(.a(2), .b(4), .c(56));
    $display("a = %0d, b = %0d, c = %0d", d.a, d.b, d.c);
  end
  
endmodule