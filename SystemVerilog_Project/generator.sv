class generator;
  
  transaction tr;
  
  // mbx : gen <-> driver
  mailbox #(transaction) mbx;
  // mbx : gen <-> scb
  mailbox #(transaction) mbx_ref;
  
  int stimulus_count;
  event scb_done;
  event gen_done;
  
  
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbx_ref);
    this.mbx = mbx;
    this.mbx_ref = mbx_ref;
    tr = new();
  endfunction
  
  
  task run();
    
    repeat(stimulus_count) begin
      assert(tr.randomize()) else $error("[GEN] RANDOMIZATION ERROR!!");
      mbx.put(tr.copy());
      mbx_ref.put(tr.copy());
      tr.display("GEN");
      @(scb_done);
    end
    
    -> gen_done;
    
  endtask
  
  
endclass