//pre-randomize
//post-randomize
 
 
class generator;
  
  randc bit [31:0] a,b; 
  bit [31:0] sum;
  
  int min;
  int max;
  int count = 0;
  int sum;
  
  function void pre_randomize();
    count ++;
    min = 0;
    max = count * 10;
    $display("No. %0d randmoization: min=%0d, max=%0d", count, min, max);
    $display("Pre a = %0d, Pre b = %0d", a, b);
  endfunction
  
  constraint data {
    a inside {[min:max]};
    b inside {[min:max]};
  }
  
  function void post_randomize();
    sum = a + b;
    $display("Value of a :%0d and b: %0d, sum: %0d\n", a,b,sum);
  endfunction
   
  
  
endclass

 
 
module tb;
  
  int i =0;
  generator g;
  
  initial begin
    g = new();
    
    for(i = 0; i<10;i++)begin
      g.randomize();		// pre_randmoize -> randmoize -> post_randomize
      #10;
    end
    
  end
  
  
endmodule