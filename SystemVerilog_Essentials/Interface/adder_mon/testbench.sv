class transaction;
  
  randc bit [3:0] a;
  randc bit [3:0] b;
  bit [4:0] sum;

  function void display();
    $display("a: %0d \t b: %0d \t sum: %0d", a, b, sum);
  endfunction
  
endclass

interface add_if;
  
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  logic clk;
  
  // Declare monitor clocking block
  //  -> sample the signal one monment before the posedge clk
  clocking mon_cb @(posedge clk);
    input a;
    input b;
    input sum;
  endclocking
  
endinterface


class monitor;
  
  virtual add_if aif;
  transaction tr;
  
  mailbox #(transaction) mbx;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  
  task run();
    @(posedge aif.clk);
    
    forever begin
      tr = new();
      // Use clocking block wait for posedge clk
      repeat(2) @(aif.mon_cb);
      tr.a = aif.mon_cb.a;
      tr.b = aif.mon_cb.b;
      tr.sum = aif.mon_cb.sum;
      $display("[MON] DATA SENT TO SCB \t time:%0t", $time);
      tr.display();
      mbx.put(tr);
    end
  endtask
  
endclass


class scoreboard;
  
  mailbox #(transaction) mbx;
  transaction tr;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  
  task run();
    forever begin
      mbx.get(tr);
      $display("[SCB] DATA RCVD FROM MON \t time: %0t", $time);
      tr.display();
      #40;
    end
  endtask
  
endclass



module tb;
  
  add_if aif();
  
  monitor mon;
  scoreboard scb;
  
  mailbox #(transaction) mbx;
  
  
  // Gen & drive
  initial begin
    for(int i=0;  i<10; i++) begin
      repeat(2) @(posedge aif.clk);
      aif.a <= $urandom_range(0, 15);
      aif.b <= $urandom_range(0, 15);
    end
  end
  
  
  initial begin
    mbx = new();
    mon = new(mbx);
    scb = new(mbx);
    mon.aif = aif;
  end
  
  initial begin
    fork
      mon.run();
      scb.run();
    join
  end
  
  
  
  // clock gen
  initial begin
    aif.clk = 0;
    forever begin
      #(20.0 / 2.0) aif.clk = ~aif.clk;
    end
  end
  
  // Waveform
  initial begin
    $dumpfile("add.vcd");
    $dumpvars;
    #400;
    $finish;
  end
  
  // DUT
  add u_add(aif.a, aif.b, aif.sum, aif.clk);
  
  
endmodule