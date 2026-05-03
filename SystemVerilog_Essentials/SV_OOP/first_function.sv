module tb;
  
  function bit [4:0] add (input bit [3:0] a, input bit [3:0] b);
  	return a + b;
  endfunction
  
  function void display_in(input bit [3:0] a, input bit [3:0] b);
    $display("Value a_in = %0d, b_in = %0d", a, b);
  endfunction
  
  
  bit [4:0] res = 0;
  bit [3:0] a_in = 4'b0100;
  bit [2:0] b_in = 4'b0010;
  
  initial begin
    display_in(a_in, b_in);
    res = add(a_in, b_in);
    $display("value of addition : %0d", res);
  end
  
endmodule