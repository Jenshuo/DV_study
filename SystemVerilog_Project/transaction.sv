class transaction;
  
  rand bit din;
  bit dout;
  
  function void display(input string tag);
    $display("[%0s] DIN: %0d \t DOUT: %0d \t time: %0t", tag, din, dout, $time);
  endfunction
  
  function transaction copy();
    transaction tmp;
    tmp = new();
    tmp.din = this.din;
    tmp.dout = this.dout;
    return tmp;
  endfunction
  
endclass