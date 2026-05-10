module tb;
 event a1,a2;
  
  initial begin
    ->a1;
    ->a2;
  end
  
  initial begin
    wait(a1.triggered);
    $display("Event A1 Trigger (Thread 1)");
    wait(a2.triggered);
    $display("Event A2 Trigger (Thread 1)");
  end
  
  initial begin
    @(a1);
    $display("Event A1 Trigger (Thread 2)");
    wait(a2.triggered);
    $display("Event A2 Trigger (Thread 2)");
  end
 
 
 
endmodule