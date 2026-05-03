module tb();
  
  function bit[63:0] multiplication (input bit [31:0] a, input bit [31:0] b);
    return a * b;
  endfunction
  
  bit [31:0] a_in = 32'd20;
  bit [31:0] b_in = 32'd40;
  bit [63:0] result = 0;
  bit [63:0] result_golden = 0;
  
  initial begin
    result = multiplication(a_in, b_in);
  	result_golden = a_in * b_in;
  
  	if(result !== result_golden) begin
      $display("Test Failed");
      $display("Result = %0d, Result golden = %0d", result, result_golden);
  	end
  	else begin
      $display("Test Passed");
      $display("Result = %0d, Result golden = %0d", result, result_golden);
  	end
  end
  
  
endmodule