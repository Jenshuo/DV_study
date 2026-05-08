class generator;
  
  rand bit [4:0] a;
  rand bit [4:0] b;
  
  constraint data {
    a inside {[0:8]};
    b inside {[0:5]};
  }
  
endclass


module tb;
  
  generator g;
  
  int g_faile_cnt = 0;
  
  initial begin
    g = new();
    
    for(int i=0; i<20; i++) begin
      assert(g.randomize()) else begin
        g_faile_cnt++;
      end
      $display("value a = %0d, value b = %0d", g.a, g.b);
    end
    
    $display("Generator randomize fail %0d times", g_faile_cnt);
    
  end
  
endmodule