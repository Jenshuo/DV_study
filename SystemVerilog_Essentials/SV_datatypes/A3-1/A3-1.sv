`timescale 1ns/10ps

module tb();

  reg [7:0] a;

  reg [7:0] b;

  integer c;

  integer d;



  initial begin

    a = 12;

    b = 34;

    c = 67;

    d = 255;

    #12;

    $display("a = %0d, b = %0d, c = %0d, d = %0d, time = %0t", a, b, c, d, $time());

  end



endmodule