class transaction;
  
  // Trigger on the testbench top
  bit clk;
  bit rst_n;
  
  rand bit wreq;
  rand bit rreq;
  
  rand bit [7:0] wdata;
  bit [7:0] rdata;
  
  bit full;
  bit empty;
  
  constraint wr_c {
    wreq dist {0 := 30, 1 := 70};  
  }
  
  constraint rd_c {
    rreq dist {0 := 30, 1 := 70}; 
  }
  
  constraint wr_rd {
    rreq != wreq; 
  }
  
endclass


module tb;
  
  transaction tr;
  
  initial begin
    tr = new();
    
    for(int i=0; i<10; i++) begin
      assert(tr.randomize());
      $display("wrreq = %0b, rreq = %0b", tr.wreq, tr.rreq);
    end
  end
  
endmodule