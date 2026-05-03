module tb();
  
  bit clk;
  bit en;
  bit wr;
  bit [5:0] addr;
  
  
  initial begin
    clk = 0;
    forever #(40.0 / 2.0) clk = ~clk;
  end
  
  initial begin
    en = 0;
    wr = 0;
    addr = 0;
    #1;
    gen_stim();
    $finish;
  end
  
  
  task gen_stim();
    
    @(posedge clk);
    en <= 1'b1;
    wr <= 1'b1;
    addr <= 6'd12;
    
    @(posedge clk);
    en <= 1'b1;
    wr <= 1'b1;
    addr <= 6'd14;
    
    @(posedge clk);
    en <= 1'b1;
    wr <= 1'b0;
    addr <= 6'd23;
    
    
    @(posedge clk);
    en <= 1'b1;
    wr <= 1'b0;
    addr <= 6'd48;
    
    @(posedge clk);
    en <= 1'b0;
    wr <= 1'b0;
    addr <= 6'd56;
    
    @(posedge clk);
    
  endtask
  
  

  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
  end
  
endmodule