class generator;
  
  rand bit [7:0] x;
  rand bit [7:0] y;
  rand bit [7:0] z;
  
  constraint data_c {
    x inside {[0:50]};
    y inside {[0:50]};
    z inside {[0:50]};
  }
  
  function void display();
    $display("x = %3d, y = %3d, z = %3d, time = %0t", x, y, z, $time);
  endfunction
  
  function void post_randomize();
    if(x>50) $display("[Err] x is greater than 50");
    if(y>50) $display("[Err] y is greater than 50");
    if(z>50) $display("[Err] z is greater than 50");
  endfunction
  
endclass


module tb;
  
  generator g;
  
  initial begin
    
    g = new();
    
    for (int i=0; i<20; i++) begin
      assert(g.randomize());
      g.display();
      #20;
    end
    
  end
  
endmodule