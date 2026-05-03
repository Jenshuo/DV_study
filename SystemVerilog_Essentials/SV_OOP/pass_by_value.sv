module tb();
  
  bit [3:0] a;
  
  initial begin
    a = 3;
    test(a);  // pass by value
    $display("Main a = %0d", a);
  end
  
  task test(bit [3:0] a);
    a = a + 5;		// Local copy of the variable in the stack
                    // will not update values of the main program
    $display("[Task] value a = %0d", a);
  endtask
  
endmodule