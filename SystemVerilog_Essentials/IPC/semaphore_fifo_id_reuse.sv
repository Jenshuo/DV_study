class data_random;
  
  rand int data;
  
  int min;
  int max;
  string rank;
  
  function new (input int min, input int max, input string rank);
    this.min = min;
    this.max = max;
    this.rank = rank;
  endfunction
  
  constraint data_c {
    data > min;
    data < max;
  }
  
  function void display();
    $display("[%0s] random data = %0d, time = %0t", rank, data, $time);
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
  
  data_random f, s, t;
  
  resource_manager m;
  
  function new(int _num);
    f = new( 0, 10, "First");
    s = new(10, 20, "Second");
    t = new(20, 30, "Thrid");
    m = new(_num);
  endfunction
  
  
  task generic_run(data_random dr);
    int local_id;
    // Occupy semaphore
    m.get_resource(local_id);
    
    for (int i=0; i<2; i++) begin
      assert(dr.randomize());
      dr.display();
      $display("%0s run and sem %0d occupied: data = %0d, time = %0t", dr.rank, local_id, dr.data, $time);
      #10;
    end
    
    // Release semaphore
    m.release_resource(local_id);
    $display("%0s sem uncooupied sem id %0d, time = %0t", dr.rank, local_id, $time);
    
  endtask
  
  
  task run();
    
    /*
        There are only two keys, but 3 thrads are trying to get the key, so one of the thread will be blocked until one of the other two threads release the key.
        T=0 : first_run, second_run get the key (ID0, ID1), third_run is blocked
        T=20 : first_run releases the key (ID0), third_run gets the key (ID0)
    */
    fork
      generic_run(f);
      generic_run(s);
      generic_run(t);
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