`include "transaction.sv"
`include "interface.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"


module tb;
  
  dff_if dif();
  
  environment env;
  
  
  initial begin
    env = new(dif);
    env.gen.stimulus_count = 10;
    env.run();
  end
  
  
  initial begin
    dif.clk = 0;
    forever begin
      #(20.0/2.0) dif.clk = ~dif.clk;
    end
  end
  
  initial begin
    $dumpfile("dff.vcd");
    $dumpvars;
  end
  
  dff u_dff (.clk(dif.clk), .rst_n(dif.rst_n), .din(dif.din), .dout(dif.dout));
  
  
endmodule