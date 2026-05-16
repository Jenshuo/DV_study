class transaction;
  randc bit [3:0] a;
  randc bit [3:0] b;
  bit [4:0] sum;
  
  
  virtual function void display();
    $display("a : %0d \t b: %0d \t sum : %0d",a,b,sum);
  endfunction
  
  virtual function transaction copy();
    transaction tc;
    tc = new();
    return this.copy_data(tc);
  endfunction
  
  virtual function transaction copy_data(transaction target);
    target.a = this.a;
    target.b = this.b;
    target.sum = this.sum;
    return target;
  endfunction
  
  virtual function bit get_err_flag();
    return 1'b0;
  endfunction
  
  
endclass
 
class error extends transaction;
  
  rand bit err_flag;
  
  constraint data_c {a ==  0; b == 0; err_flag == 1;}
  
  virtual function void display();
    $display("a : %0d \t b: %0d \t sum : %0d \t err_flag = %0d",a,b,sum,err_flag);
  endfunction
  
  virtual function transaction copy();
    error tmp;
    tmp = new();
    void'(super.copy_data(tmp));
    tmp.err_flag = this.err_flag;
    return tmp;
  endfunction
  
  virtual function bit get_err_flag();
    return this.err_flag;
  endfunction
  
endclass
 
 
 
 
class generator;
  
  transaction trans;
  mailbox #(transaction) mbx;
  event done;
 
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    this.trans = new();
  endfunction
  
  
  task run();
    for(int i = 0; i<10; i++) begin
      trans.randomize();
      mbx.put(trans.copy());
      $display("[GEN] : DATA SENT TO DRIVER");
      trans.display();
      #20;
    end
   -> done;
  endtask
  
endclass
 
 
interface add_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;
  logic clk;
  logic err_flag;
  
  modport DRV (output a,b,err_flag, input sum,clk);
  
endinterface
 
 
class driver;
  
  virtual add_if aif;
  
  mailbox #(transaction) mbx;
  
  transaction data;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction 
  
  
  task run();
    forever begin
      mbx.get(data);
      @(posedge aif.clk);  
      aif.a <= data.a;
      aif.b <= data.b;
      aif.err_flag <= data.get_err_flag();
      $display("[DRV] : Interface Trigger");
      data.display();
    end
  endtask
  
  
endclass
 
 
 
 
module tb;
  
  add_if aif();
  
  driver drv;
  generator gen;
  
  error err;
    
  event done;

  
  mailbox #(transaction) mbx;
  
  add dut (aif.a, aif.b, aif.sum, aif.clk );
 
 
  initial begin
    aif.clk <= 0;
  end
  
  always #10 aif.clk <= ~aif.clk;
 
  initial begin
    
    mbx = new();
    err = new();
    drv = new(mbx);
    gen = new(mbx);
     
    drv.aif = aif;
    done = gen.done;
    
    
    $display("[Normal Transaction]");
    fork
      gen.run();
      drv.run();
    join_none
    wait(done.triggered);
    
    #10;
    
    
    $display("[Error Transaction]");
    err = new();
    gen.trans = err;
    
    fork
      gen.run();
      //drv.run();
    join_none
    wait(done.triggered);
    
    
//    [generator::run()] 
//       │
//       ▼
// call trans.copy()
//       │
//       ├─► Simulator check：It is a virtual function！
//       ├─► Check handler：It is point to error object !
//       │
//       ▼
// [jump to error::copy()]
//       │
//       ├─► 1. exec tmp = new(); (child class create its own space )
//       ├─► 2. exec super.copy_data(tmp); (jump to parent and fill a, b, sum)
//       ├─► 3. exec tmp.err_flag = this.err_flag; (go back to child class and fill its own err_flag)
//       │
//       ▼
//[return to mailbox] Perfect error copy put to mailbox
    
    $finish();
  end
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;  
  end
  
endmodule