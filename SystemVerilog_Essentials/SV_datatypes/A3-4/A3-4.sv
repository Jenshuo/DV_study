`timescale 1ns/1ps;

module tb();
  

  int arr[];
  int first_size;
  int second_size;
  
  initial begin
    arr = new[7];
    
    for(int i=0; i<arr.size(); i++) begin
      arr[i] = 7 * (i+1);
    end
    $display("time : %0t, arr = %0p", $time, arr);
    
    first_size = arr.size();
    
    #20
    
    second_size = 20;
    arr = new[second_size](arr);
	
    for(int i=0; i<second_size-first_size; i++) begin
      arr[first_size+i] = 5 * (i+1);
    end
    
    $display("time : %0t, arr = %0p", $time, arr);
    
    
  end



endmodule