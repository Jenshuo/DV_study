module tb();

  bit [31:0] arr [10];

  initial begin

    foreach(arr[i]) begin
      arr[i] = i * i;
    end

    $display("arr is %0p", arr);

  end
 
endmodule