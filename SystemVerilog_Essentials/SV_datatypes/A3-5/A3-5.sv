`timescale 1ns/1ps;

module tb();
  
  int arr[20];
  int arr_q [$];
  
  int tmp;
  
  initial begin
    
    foreach(arr[i]) begin
      tmp = $urandom();
      arr[i] = tmp;
      arr_q.push_front(tmp);
    end
    
    $display("arr   = %0p, size = %0d", arr, $size(arr));			// fix array : size use $size => system task/function
    $display("arr_p = %0p, size = %0d", arr_q, arr_q.size());
    //$display("arr_p = %0p, size = %0d", arr_q, $size(arr_q));		// dynamic array, queue : size use $size, .size() => method
    
    // Check
    foreach(arr[i]) begin
      tmp = arr_q.pop_back();
      if(tmp != arr[i]) begin
        $display("[Error] arr[%0d] = %0d, arr_q[%0d] = %0d", i, arr[i], $size(arr)-i-1, tmp);
      end
      else begin
        $display("[Pass] arr[%0d] = %0d, arr_q[%0d] = %0d", i, arr[i], $size(arr)-i-1, tmp);
      end
    end
    
  end



endmodule