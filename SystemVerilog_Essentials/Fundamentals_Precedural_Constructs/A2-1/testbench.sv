`include "test.sv"


module tb;
  
  reg rst = 0;   //////rst represent DUT reset Signal

  /////// User Logic goes here
  
  reg clk;
  
  initial begin
    clk = 0;
    rst = 1;
    #60;
    rst = 0;
  end
  
  
  
  /////// User code ends here
 
  
  test t1 = new();
  
  initial begin
    #59;
    t1.no_gen(rst);
    t1.display();
  end
  
  
endmodule