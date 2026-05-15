module add (
  input [3:0] a,
  input [3:0] b,
  output reg [4:0] sum,
  input clk,
  input err_flag
);
  
  always @(posedge clk) begin
    sum <= a + b;
  end
  
  
  
endmodule