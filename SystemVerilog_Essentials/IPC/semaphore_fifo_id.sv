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


class third;
  
  rand int data;
  
  constraint data_c {
    data > 20;
    data < 30;
  }
  
  function void display();
    $display("[Third] random data = %0d, time = %0t", data, $time);
  endfunction
  
endclass


class resource_manager;
  
  int free_id [$];
  semaphore sem;
  
  function new(int _num);
    // key num = id num
    sem = new(_num);
    for (int i=0; i<_num; i++) begin
      free_id.push_back(i);
    end
  endfunction
  
  // get_resource and release_resource ensures that resource are used in rotation (FIFO)
  task get_resource (output int id);
    // Guarantee there are at least 1 key
    sem.get(1);
    // Get id from free_id queue
    id = free_id.pop_front();
  endtask
  
  function void release_resource (input int id);
    // Put id to queue
    free_id.push_back(id);
    // Release 1 key
    sem.put(1);
  endfunction
  
endclass


class main;
  
  first f;
  second s;
  third t;
  
  resource_manager m;
  
  int data_f;
  int data_s;
  int data_t;
  
  function new(int _num);
    f = new();
    s = new();
    t = new();
    m = new(_num);
  endfunction
  
  
  task first_run();
    int local_id;
    // Occupy semaphore
    m.get_resource(local_id);
    
    for (int i=0; i<2; i++) begin
      assert(f.randomize());
      data_f = f.data;
      f.display();
      $display("First run and sem %0d occupied: data = %0d, time = %0t", local_id, data_f, $time);
      #10;
    end
    
    // Release semaphore
    m.release_resource(local_id);
    $display("First sem uncooupied sem id %0d, time = %0t", local_id, $time);
    
  endtask
  
  
  task second_run();
    int local_id;
    // Occupy semaphore
    m.get_resource(local_id);
    
    for (int i=0; i<2; i++) begin
      assert(s.randomize());
      data_s = s.data;
      s.display();
      $display("Second run and sem %0d occupied: data = %0d, time = %0t", local_id, data_s, $time);
      #10;
    end
    
    // Release semaphore
    m.release_resource(local_id);
    $display("Second sem uncooupied sem id %0d, time = %0t", local_id, $time);
    
  endtask
  
  task third_run();
    int local_id;
    // Occupy semaphore
    m.get_resource(local_id);
    
    for (int i=0; i<2; i++) begin
      assert(t.randomize());
      data_t = t.data;
      t.display();
      $display("Third run and sem %0d occupied: data = %0d, time = %0t", local_id, data_t, $time);
      #10;
    end
    
    // Release semaphore
    m.release_resource(local_id);
    $display("Third sem uncooupied sem id %0d, time = %0t", local_id, $time);
    
  endtask
  
  
  task run();
    
    /*
        There are only two keys, but 3 thrads are trying to get the key, so one of the thread will be blocked until one of the other two threads release the key.
        T=0 : first_run, second_run get the key (ID0, ID1), third_run is blocked
        T=20 : first_run releases the key (ID0), third_run gets the key (ID0)
    */
    fork
      first_run();
      second_run();
      third_run();
    join
    
  endtask
  
endclass


module tb;
  
  main m;
  
  initial begin
    m = new(2);
    m.run();
  end
  
  initial begin
    #250;
    $finish;
  end
  
endmodule