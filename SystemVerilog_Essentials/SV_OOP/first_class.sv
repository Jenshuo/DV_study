// Class : dynamic object
class first;
  
  bit [2:0] data; 
  bit [1:0] data2;
  
  
endclass
 
 
module tb;
  
  first f;          // declare handler
  
  initial begin
    f = new();      // Create object, add constructor to the handler
                    // data member will be initialize to default value
                    // ex : 2 state bit initialize to 0
                    //      4 state reg initialize to X
    #1;
    $display("Initial Value of data : %0d and data2 : %0d",f.data, f.data2);

    f.data = 3'b010;
    f.data2 = 2'b10;

    #1;
    $display("Value of data : %0d and data2 : %0d",f.data, f.data2);

    f = null;       // Delete object, ceallocate the memory assign to the class


  end
  
  
  
endmodule