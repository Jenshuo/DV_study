`timescale 1ns/1ps
 
 ////Do not change any code after this ->

module sub_tb(input probe);

  realtime st = 0,ed = 0;
  realtime dif = 0;

  initial begin
    @(posedge probe);
    st = $realtime();
    @(posedge probe);
    ed = $realtime();
    #2;
    dif = ed - st;
    $display("---------------------------");
    $display("magic_no = %0t", (dif/1000));
    $display("---------------------------");
  end
  
endmodule