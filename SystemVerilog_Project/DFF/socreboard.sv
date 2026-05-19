class scoreboard;
  
  // mailbox : mon <-> scb
  mailbox #(transaction) mbx;
  transaction tr;
  
  // mbx : gen <-> scb
  mailbox #(transaction) mbx_ref;
  transaction tr_ref;
  
  event scb_done;
  
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbx_ref);
    this.mbx = mbx;
    this.mbx_ref = mbx_ref;
  endfunction
  
  
  task run();
    
    forever begin
      // Get transaction from monitor mbx
      mbx.get(tr);
      tr.display("SCB");
      
      // Gen transaction from gen mbx (golden)
      mbx_ref.get(tr_ref);
      tr_ref.display("REF");
      
      if(tr.dout !== tr_ref.din) begin
        $display("[SCB] DFF DATA MISMATCH!!");
      end
      else begin
        $display("[SCB] DFF MATCH!!");
      end
      
      -> scb_done;
    end
    
    
  endtask
  
endclass