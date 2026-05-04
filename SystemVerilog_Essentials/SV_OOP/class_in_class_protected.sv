class first;
  
 local int data = 34;				// local : protected data member
  
  task set(input int data);
    this.data = data;
  endtask
  
  function int get();
    return data;   
  endfunction
  
  task display();
    $display("Value of data : %0d",data);
  endtask 
  
endclass
 
class second;
  
  first f1;
  
  function new();
    f1 = new();
  endfunction
   
endclass
 
 
module tb;
  
  second s;
  
  initial begin
    s = new();
    // $display("value of f1 data = %0d", s.f1.data);	=> not visible outside of the first class
    // s.f1.data = 123;								    => not visible outside of the first class
    s.f1.set(123);
    $display("Value of data : %0d", s.f1.get());
    
  end
  
  
  
endmodule