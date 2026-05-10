module tb;
  
  
  task first;
    $display("[First] task start at %0t", $time);
    #20;
    $display("[First] task end at %0t",  $time);
  endtask
  
  task second;
    $display("[Second] task start at %0t", $time);
    #30;
    $display("[Second] task end at %0t",  $time);
  endtask
  
  task third;
    $display("[Third] Next task start at %0t", $time);
  endtask
  
  
  initial begin
    
    fork
      first();
      second();
    join_none
    
    third();		// fork, join      : [Third] Next task start at 30
    				// fork, join_any  : [Third] Next task start at 20
    				// fork, join_none : [Third] Next task start at 0
    
  end
  
  
endmodule