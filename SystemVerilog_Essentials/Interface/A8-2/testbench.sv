interface top_if;
  logic clk;
  logic [3:0] a, b;
  logic [7:0] mul;
  
endinterface

class transaction;
  
  randc bit [3:0] a;
  randc bit [3:0] b;
  bit [7:0] mul;
  
  function void display();
    $display("a: %0d \t b: %0d \t mul: %0d", a, b, mul);
  endfunction
  
endclass


class monitor;
  virtual top_if vif;
  
  mailbox #(transaction) mbx;
  transaction tr;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    
    forever begin
      @(posedge vif.clk);
      tr = new();
      tr.a = vif.a;
      tr.b = vif.b;
      tr.mul = vif.mul;
      mbx.put(tr);
      $display("-------------------------------------------------");
      $display("[MON] DATA SEND TO SCB \t time: %0t", $time);
      tr.display();
    end
    
  endtask
  
endclass


class scoreboard;
  
  mailbox #(transaction) mbx;
  transaction tr;
  
  bit [7:0] expected_queue [$];
  bit [7:0] golden_data;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  
  task run();
    
    forever begin
      mbx.get(tr);
      $display("[SCB] DATA RVCD FROM MON \t time: %0t", $time);
      tr.display();
      $display("-------------------------------------------------");
      
      // Calculate expected ans and store to queue
      expected_queue.push_back(tr.a *tr.b);
      
      if(expected_queue.size() >= 2) begin
        golden_data = expected_queue.pop_front();
        if(golden_data !== tr.mul) begin
          $error("[SCB] COMPARE ERROR, golden data: %0d \t your data: %0d", golden_data, tr.mul);
        end
        else begin
          $display("[SCB] COMPARE PASS, golden data: %0d \t your data: %0d", golden_data, tr.mul);
        end
      end
      
    end
  endtask
  
  
endclass


module tb;
  
  top_if vif();
  
  top dut (vif.clk, vif.a, vif.b, vif.mul);
  
  initial begin
    vif.clk <= 0;
  end
  
  always #5 vif.clk <= ~vif.clk;
  
  
  mailbox #(transaction) mbx;
  monitor mon;
  scoreboard scb;
  
  initial begin
    mbx = new();
    mon = new(mbx);
    scb = new(mbx);
    mon.vif = vif;
  end
  
  initial begin
    fork
      mon.run();
      scb.run();
    join
    
  end
  
  
  
  
  initial begin
    for(int i = 0; i<20; i++) begin
      @(posedge vif.clk);
      vif.a <= $urandom_range(1,15);
      vif.b <= $urandom_range(1,15);
    end
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
     $dumpvars;    
    #300;
    $finish();
  end
  
endmodule