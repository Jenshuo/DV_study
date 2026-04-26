class test;
  int temp = 0;  // Holds the "magic number"
  
  // Task to display the result
  task display();
    $display("---------------------------");
    $display("magic_no = %0d", this.temp);
    $display("---------------------------");
  endtask
  
  // Task to generate the magic number based on clk1 and clk2
  task no_gen(input bit clk1, input bit clk2);
    // Generate magic number based on clk1 and clk2 states
    this.temp = clk1 * clk2 * 75 + (clk1 ^ clk2) * 50;
  endtask
  
endclass
