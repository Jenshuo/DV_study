class transaction;
  rand bit [7:0] wdata;
  bit [7:0] rdata;
  rand bit wreq, rreq;
endclass

class generator;
  transaction trans;

  task run();
    repeat (count) begin
      trans = new();
      assert(trans.randomize()) else $display("Randomization failed at time %0t", $time);
    end
  endtask

endclass

class scoreboard;
  bit [7:0] rdata;
  bit [7:0] queue [$];

  task run();
    // ........

    if(tr.wreq) begin
      queue.push_back(tr.wdata);
      $display("[SCB] Time %0t: Write data %0h", $time, tr.wdata);
    end
    else if(tr.rreq) begin
      if(queue.size() > 0) begin
        rdata = queue.pop_front();
        $display("[SCB] Time %0t: Read data %0h", $time, rdata);
        if(tr.rdata != rdata) begin
          $display("[Error] Time %0t: Expected %0h, got %0h", $time, rdata, tr.rdata);
        end
        else begin
          $display("[Pass] Time %0t: Expected %0h, got %0h", $time, rdata, tr.rdata);
        end
      end
      else begin
        $display("[SCB] Time %0t: Read request but queue is empty", $time);
      end
    end
  endtask

endclass