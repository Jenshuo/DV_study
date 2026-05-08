class generator;
  
  randc bit [3:0] raddr, waddr;
  rand bit wr; ///write to mem
  rand bit oe; ///output enable
  
  constraint wr_c {
    wr dist {0:= 50, 1 := 50};
  }
  
  
  constraint oe_c {
    oe dist {1:= 50, 0 := 50};
  }
  
  constraint wr_oe_c {
    ( wr == 1 ) <-> (oe == 0); 	// A:(wr==1), B:(oe==0) 
    							// <-> means A and B must both be true simultaneously or both be false simultaneously
    							// so, wr==1, oe == 0 and wr==0, oe==1
  }
 
endclass
 
module tb;
  
  generator g;
  
  initial begin
    g = new();
    
    for (int i = 0; i<10 ; i++) begin
      assert(g.randomize()) else $display("Randomization Failed");
      $display("value wr = %0d, value oe = %0d", g.wr, g.oe);
      
    end
    
  end
 
  
endmodule
