`include "test.sv"
`timescale 1ns/1ps

module tb;
  
  reg sclk = 0;   //////sclk represent SPI Clock Signal
  
  
  /////// User code for generating clock goes here
  ///// Generate 9 MHz Clock stimulus for signal sclk with 50% Duty cycle and upto 3-bit precision
  
  initial begin
    sclk = 0;
    forever #(111.111 / 2.000) sclk = ~sclk;
  end
  
  
  
  
  /////// User code ends here
 
  
  
  
 
  /////Do not change any code after this ->
  
  sub_tb s (sclk);
  
 initial 
   begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #800;
    $stop;
  end
  
  
endmodule