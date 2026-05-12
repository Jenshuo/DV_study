class transaction;
  
  bit [7:0] addr;
  bit [3:0] data;
  bit we;
  bit rst;
  
endclass


class generator;
  
  transaction tr;
  
  mailbox #(transaction) mbx;
  
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    
    tr = new();
    tr.addr = 7'h12;
    tr.data = 4'h4;
    tr.we = 1'b1;
    tr.rst = 1'b0;
    
    mbx.put(tr);
    $display("[GEN] SEND tr : addr = 0x%0h, data = 0x%0h, we = %0b, rst = %0b", tr.addr, tr.data, tr.we, tr.rst);
    
  endtask
  
endclass


class driver;
  
  transaction tr;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    mbx.get(tr);
    $display("[DRV] RCVD tr : addr = 0x%0h, data = 0x%0h, we = %0b, rst = %0b", tr.addr, tr.data, tr.we, tr.rst);
  endtask
  
endclass


module tb;
  
  generator gen;
  driver drv;
  mailbox #(transaction) mbx;
  
  initial begin
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    
    gen.run();
    drv.run();
    
  end
  
  
endmodule