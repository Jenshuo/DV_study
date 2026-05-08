class first;
  
  rand bit [1:0] var1;
  rand bit [1:0] var2;
  
  int var1_cnt [4] = '{default:0};
  int var2_cnt [4] = '{default:0};
  
  constraint data {
    var1 dist {0 := 30, [1:3] := 90};// P(0) = 30/30+90+90+90 = 30/300 = 1/10, P(1) = P(2) = P(3) = 90/30+90+90+90 = 90/300 = 3/10
    var2 dist {0 :/ 30, [1:3] :/ 90};// P(0) = 30/30+90 = 30/120 = 1/4, P(1) - P(2) = P(3) = (90/3)/30+90 = 1/4
  }
  
  function void display();
    $display("value var1 (:=) = %0d, value var2 (:/) = %0d", var1, var2);
  endfunction
  
  function void post_randomize();
    var1_cnt[var1] ++;
    var2_cnt[var2] ++;
  endfunction
  
endclass


module tb;
  
  first f;
  
  initial begin
    
    f = new();
    
    for (int i = 0; i<1000; i++) begin
      f.randomize();
      f.display();
    end
    
    for (int i=0; i<4; i++) begin
      $display("var1 : %0d = %0d times", i, f.var1_cnt[i]);
    end
    
    $display();
    
    for (int i=0; i<4; i++) begin
      $display("var2 : %0d = %0d times", i, f.var2_cnt[i]);
    end
    
  end
  
endmodule