class  generator;
  
  int data = 123;
  
  mailbox mbx;
  
  task run();
    mbx.put(data);
    $display("[GEN] SENT data %0d", data);
  endtask
  
endclass


class driver;
  
  // data container
  int data;
  
  mailbox mbx;
  
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
    gen = new();
    drv = new();
    mbx = new();
    
    gen.mbx = mbx;
    drv.mbx = mbx;
    
    fork
      gen.run();
      drv.run();
    join
    
  end
  
endmodule