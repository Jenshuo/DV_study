module tb;
  
  bit [7:0] arr [32];
  
  initial begin
    set_array(arr);
    foreach (arr[i]) begin
      $display("arr[%0d] = %0d", i, arr[i]);
    end
  end
  
  function automatic void set_array(ref bit [7:0] arr[32]);
    for(int i=0; i<32; i++) begin
      arr[i] = 8 * i;
    end
  endfunction
  
endmodule