class first;
  
  rand bit wr;
  rand bit rd;
  
  int wr_cnt_0 = 0;
  int wr_cnt_1 = 0;
  int rd_cnt_0 = 0;
  int rd_cnt_1 = 0;
  
  constraint wr_c {
    wr dist {0 := 30, 1:= 70}; 
  }
  
  constraint rd_c {
    rd dist {0 :/ 30, 1 :/ 70}; 
  }
  
  function void display();
    $display("value wr = %0b, value rd = %0b", wr, rd);
  endfunction
  
  function void post_randomize();
    if(wr==0) wr_cnt_0 ++;
    if(wr==1) wr_cnt_1 ++;
    if(rd==0) rd_cnt_0 ++;
    if(rd==1) rd_cnt_1 ++;
  endfunction
  
endclass


module tb;
  
  first f;
  
  initial begin
    f = new();
    
    for (int i=0; i< 10; i++) begin
      f.randomize();
      f.display();
    end
    
    $display("value wr = 0 : %0d times, value wr = 1 : %0d times", f.wr_cnt_0, f.wr_cnt_1);
    $display("value rd = 0 : %0d times, value rd = 1 : %0d times", f.rd_cnt_0, f.rd_cnt_1);
    
  end
  
endmodule
