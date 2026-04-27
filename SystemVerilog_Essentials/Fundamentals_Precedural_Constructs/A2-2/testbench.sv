`include "test.sv"


module tb;
  
  reg resetn = 0;   //////rst represent DUT reset Signal

  /////// User Logic goes here
  
  reg clk;
  
  initial begin
    clk = 0;
    resetn = 0;
    #100;
    resetn = 1;
    #50;
    resetn = 0;
    #50;
    resetn = 1;
  end
  
  
  
  
  /////// User code ends here
 
  
  test t1 = new();
  
  initial begin
    #201;
    t1.no_gen(resetn);
    t1.display();
  end
  
  
endmodule