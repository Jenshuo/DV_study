class test;
  bit rst  = 1;
  int temp = 0;
  
  
  task display();
    $display("---------------------------");
    $display("magic_no = %0d", this.temp);
    $display("---------------------------");
  endtask
  
  task no_gen(rst);
    this.temp = rst*5*6*2; 
  endtask
  
endclass