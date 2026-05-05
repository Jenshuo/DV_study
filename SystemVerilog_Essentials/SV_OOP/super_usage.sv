class first; ////////////parent class
  int data;
  
  function new(input int data);
    this.data = data;  
  endfunction
  
  virtual function display();
    $display("First value = %0d", data);
  endfunction
  
  
endclass
 
class second extends first;
  int temp;
  
  function new(int data, int temp);
    super.new(data);
    this.temp = temp;
  endfunction
  
  function display();
    super.display();
    $display("Second temp = %0d", temp);
  endfunction
  
endclass
 
module tb;
  second s;
  
  initial begin
    s = new(67, 45);
    $display("Value of data : %0d and Temp : %0d", s.data, s.temp);
    s.display();
  end
  
endmodule