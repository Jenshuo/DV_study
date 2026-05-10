module tb;
  
  int task1_num = 0;
  int task2_num = 0;
  
  task task1;
    #20ns;
    $display("Task1 trigger at %0t", $time);
    task1_num ++;
  endtask
  
  
  task task2;
    #40ns;
    $display("Task2 trigger at %0t", $time);
    task2_num ++;
  endtask
  
  
  initial begin
    fork
      #200;
      forever task1;
      forever task2;
    join_any
        
    $display("[Task1] task1_num = %0d", task1_num);
    $display("[Task2] task2_num = %0d", task2_num);
    
    $finish;
  end
  
  
endmodule