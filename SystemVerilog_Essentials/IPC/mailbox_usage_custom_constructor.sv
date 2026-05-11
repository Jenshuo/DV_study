class  generator;
  
  int data = 123;
  
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.put(data);
    $display("[GEN] SENT data %0d", data);
  endtask
  
endclass


class driver;
  
  // data container
  int data;
  
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.get(data);
    $display("[DRV] RCVD data %0d", data);
  endtask
  
endclass


module tb;
  
  generator gen;
  driver drv;
  mailbox mbx;
  
  initial begin
    mbx = new();

    // Pass mailbox handle to generator and driver
    // generator and driver points to the same mailbox, so they can communicate with each other
    gen = new(mbx);
    drv = new(mbx);
    
    fork
      gen.run();
      drv.run();
    join
    
  end
  
endmodule