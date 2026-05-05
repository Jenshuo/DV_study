class first;
  
  int data;
  
endclass
 
module tb;
  
  first f1;
  first p1;
  
  
  initial begin
    f1 = new();  	// constructor 
    f1.data = 24;   // processing f1
    
    p1 = new f1; 	// copying data from f1 to p1
    $display("Value of data member : %0d", p1.data);
    
    p1.data = 12;	// processing p1 => not reflect to f1
    
    $display("Value of data member : %0d", f1.data);
    
    f1.data = 100;	// f1 and p1 are independent
    $display("Value of data member : %0d", p1.data);
       
    
  end
  
  
  
endmodule