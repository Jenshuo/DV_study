module tb();
  
  bit [3:0] a;
  bit [3:0] b;
  bit [4:0] y;
  
  bit clk;
  
  initial begin
    
    for(int i=0; i<11; i++) begin
      
      stim_clk();
      
    end
    
    $finish;
    
  end
  
  initial begin
    clk = 0;
    forever #(20.0 / 2.0) clk = ~clk;
  end
  
  
  task stim_clk();
    @(posedge clk);
    a = $urandom();
    b = $urandom();
    add();
  endtask
  
  
  task add();
    y = a + b;
    $display("a = %0d, b = %0d, y = %0d", a, b, y);
  endtask
  
endmodule
