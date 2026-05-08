class generator;
  
  rand bit rst;
  rand bit wr;
  
  int rst_cnt [2] = '{default: 0};
  int wr_cnt  [2] = '{default: 0};
  
  constraint data {
    rst dist {0 :/ 30, 1 :/ 70};
    wr  dist {0 :/ 50, 1 :/ 50};
  }
  
  function void post_randomize;
    rst_cnt[rst] ++;
    wr_cnt[wr] ++;
  endfunction
  
endclass


module tb;
  
  generator g;
  
  initial begin
    g = new();
    
    for (int i=0; i<20; i++) begin
      assert(g.randomize());
      $display("rst = %0b, wr = %0b", g.rst, g.wr);
    end
    
    $display("rst : 0 => %2d times, 1 => %2d times", g.rst_cnt[0], g.rst_cnt[1]);
    $display("wr  : 0 => %2d times, 1 => %2d times", g.wr_cnt[0],  g.wr_cnt[1]);
    
    
  end
  
endmodule