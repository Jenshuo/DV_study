interface add_if;
  
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] c;
  
endinterface



module tb;
  
  add_if aif();
  
  // mapping by position
  // add u_add (aif.a, aif.b, aif.c);
  
  // mapping by name
  add u_add ( .a(aif.a), .b(aif.b), .c(aif.c) );
  
  
  initial begin
    
    aif.a = 2;
    aif.b = 7;
    
    #10;
    
    aif.a = 7;
    aif.b = 3;
    
    #10;
    
    aif.a = 15;
    aif.b = 15;
    
    #10;
    
    aif.a = 0;
    aif.b = 0;
    
  end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule