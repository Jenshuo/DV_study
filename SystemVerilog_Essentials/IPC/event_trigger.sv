// Trigger : ->
// edge sensitive blocking @()
// level sensitive non-blocking wait()


module tb;
  
  event a;
  
  initial begin
    #10;
    -> a;
  end
  
  initial begin
    @(a);
    $display("Event recieved at %0t (edge sensitive)", $time);
  end
  
  initial begin
    wait(a.triggered);
    $display("Event recieved at %0t (level sensitive)", $time);
  end
  
  
endmodule