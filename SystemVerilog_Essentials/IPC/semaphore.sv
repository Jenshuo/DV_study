class first;
  
  rand int data;
  
  constraint data_c {
    data > 0;
    data < 10;
  }
  
  function void display();
    $display("[First] random data = %0d, time = %0t", data, $time);
  endfunction
  
endclass


class second;
  
  rand int data;
  
  constraint data_c {
    data > 10;
    data < 20;
  }
  
  function void display();
    $display("[Second] random data = %0d, time = %0t", data, $time);
  endfunction
  
endclass


class main;
  
  first f;
  second s;
  
  semaphore sem;
  
  int data;
  
  function new();
    f = new();
    s = new();
    sem = new(1);
  endfunction
  
  
  task first_run();
    // Occupy semaphore
    sem.get(1);
    
    for (int i=0; i<10; i++) begin
      assert(f.randomize());
      data = f.data;
      f.display();
      $display("First run and sem occupied: data = %0d, time = %0t", data, $time);
      #10;
    end
    
    // Release semaphore
    sem.put(1);
    $display("First sem uncooupied, time = %0t", $time);
    
  endtask
  
  
  task second_run();
    // Occupy semaphore
    sem.get(1);
    
    for (int i=0; i<10; i++) begin
      assert(s.randomize());
      data = s.data;
      s.display();
      $display("Second run and sem occupied: data = %0d, time = %0t", data, $time);
      #10;
    end
    
    // Release semaphore
    sem.put(1);
    $display("Second sem uncooupied, time = %0t", $time);
    
  endtask
  
  
  task run();
    
    fork
      first_run();
      second_run();
    join
    
  endtask
  
endclass


module tb;
  
  main m;
  
  initial begin
    m = new();
    m.run();
  end
  
  initial begin
    #250;
    $finish;
  end
  
endmodule