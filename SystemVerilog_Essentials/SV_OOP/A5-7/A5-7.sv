class generator;
  
  bit [3:0] a = 5;
  bit [3:0] b = 7;
  bit wr = 1;
  bit en = 1;
  bit [4:0] s = 12;
  
  function void display();
    $display("a:%0d, b:%0d, wr:%0b, en:%0b, s:%0d", a, b, wr, en, s);
  endfunction
  
  function generator do_copy();
    generator tmp;
    tmp = new();
    tmp.a = a;
    tmp.b = b;
    tmp.wr = wr;
    tmp.en = en;
    tmp.s = s;
    return tmp;
  endfunction
  
endclass


module tb;
  
  generator g1;
  generator g_copy;
  
  initial begin
    g1     = new();
    g_copy = new();
  
    g_copy = g1.do_copy();
    g_copy.display();
    
    g1.a = 3;
    g1.b = 4;
    g1.wr = 0;
    g1.en = 0;
    g1.s = 10;
    
    g_copy.display();
    
  end
  
endmodule