class transaction;
    rand bit [7:0] din;
    randc bit [7:0] addr;
    
    bit wr;
    bit [7:0] dout;

    constraint addr_c {addr > 10; addr < 18};
endclass


class generator;
    transaction t;
    integer i;

    task run();
        for(i=0; i<100; i++) begin
            t = new();
            t.randomize();
        end
    endtask
endclass


class scoreboard;
    bit [7:0] tarr [256] = '{default:0};

    transaction t;
    task run();
        // .............

        if(t.wr) begin
            tarr[t.addr] = t.din;
            $display("[SCB] Time %0t: Write to address %0h with data %0h", $time, t.addr, t.din);
        end
        else begin
            if(t.dout != tarr[t.addr]) begin
            $display("Error at time %0t: expected %0h, got %0h", $time, tarr[t.addr], t.dout);
        end
    end
  endtask
endclass