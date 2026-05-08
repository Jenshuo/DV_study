class generator;
  
  randc bit [3:0] a, b; ////////////rand or randc 
  bit [3:0] y;
   
endclass
 
module tb;
  generator g;
  int i = 0;
  int status = 0;
  
  initial begin
    g = new();
    
    for(i=0;i<32;i++) begin
      g.randomize();
      $display("Value of a :%0d and b: %0d", g.a,g.b);
      #10;
    end
    
  end
  
  
endmodule
  