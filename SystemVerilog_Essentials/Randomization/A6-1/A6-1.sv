class generator;
  
  rand bit [7:0] x;
  rand bit [7:0] y;
  rand bit [7:0] z;
  
  function void display();
    $display("x = %3d, y = %3d, z = %3d, time = %0t", x, y, z, $time);
  endfunction
  
endclass


module tb;
  
  generator g;
  
  initial begin
    
    g = new();
    
    for (int i=0; i<20; i++) begin
      g.randomize();
      g.display();
      #20;
    end
    
  end
  
endmodule