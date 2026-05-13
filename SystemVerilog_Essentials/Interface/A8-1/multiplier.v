module mutiplier(
  input clk,
  input [3:0] a,
  input [3:0] b,
  output reg [7:0] mul
);
  
  always @(posedge clk) begin
    mul <= a * b;
  end
  
  
endmodule