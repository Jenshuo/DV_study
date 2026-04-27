`include "test.sv"
`timescale 1ns/1ps

module tb;
  
  reg rst  = 0;   //////rst represent DUT reset Signal
  bit clk = 0;   //////clk represent DUT Clock Signal
  
  
  /////// User code for generating clock goes here
  ///// Generate 25 MHz Clock stimulus for signal clk with 50% Duty cycle
  
  initial begin
    clk = 0;
    forever #(40.0/2.0) clk = ~clk;
  end
  
  
  
  /////// User code ends here
 
  
  
  
 
  /////Do not change any code after this ->
  
  sub_tb s (clk);
  
 initial 
   begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $stop;
  end
  
  
endmodule