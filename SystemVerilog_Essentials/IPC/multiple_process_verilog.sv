module tb;
  
  int data1;
  int data2;
  
  event drv_done;
  event gen_done;
  
  
  /*
    The generator, driver, and control are run in parrel (two initial block)
    but the run order of initial block is not specified
    So, there will occur race condition between generator, driver, and control
    To avoid this, we can use event to synchronize the two processes 
    => event drv_done is triggered when the driver finishes driving the data, and the generator waits for this event to be triggered before it generates the next data.
    => event gen_done is triggered when the generator finishes its job, and the control process waits for this event to be triggered before it prints the message and finishes the simulation.
  */
  
  ////// Generator
  initial begin
    for (int i=0; i<10; i++) begin
      data1 = $urandom();
      $display("[Gen] Generate data : %0d, time = %0t", data1, $time);
      #10;
      wait(drv_done.triggered);
    end
    -> gen_done;
  end
  
  ////// Driver
  initial begin
    forever begin
      #10;
      data2 = data1;
      $display("[DRV] Drive data : %0d, time = %0t", data2, $time);
      -> drv_done;
    end
  end
  
  
  ////// Control
  initial begin
    wait(gen_done.triggered);
    $display("[TB] Generator gen data done at %0t", $time);
    $finish;
  end
  
  
endmodule