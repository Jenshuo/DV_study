class test;
  real temp = 0;  // Holds the "magic number"
  
  // Task to display the result
  task display();
    $display("---------------------------");
    $display("magic_no = %0d", $rtoi(this.temp));
    $display("---------------------------");
  endtask
  
  // Task to generate the magic number based on the calculated value
  task no_gen(input real value);
    // The magic number will be calculated as twice the value of high + low times
    this.temp = value * 7*3;  // Multiply the total time by 2 for evaluation
  endtask
  
endclass
