class generator;
  
  rand bit [3:0] addr;
  rand bit wr;
  
  //constraint data {
  //  (wr == 1) -> (addr inside {[0:7]});
  //  (wr == 0) -> (addr inside {[8:15]});
  //}
  
  constraint data_2 {
    if (wr == 1) {
      addr inside {[0:7]}; 
    }
    else {
      addr inside {[8:15]};
    }
  }
  
endclass


module tb;
  
  generator g;
  
  initial begin
    g = new();
    for(int i=0; i<20; i++) begin
      assert(g.randomize());
      $display("wr = %0b, addr = %0d", g.wr, g.addr);
    end
  end
  
endmodule