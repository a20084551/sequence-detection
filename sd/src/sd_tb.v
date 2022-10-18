`timescale 1ns/100ps
`define CYCLE 50.0
`define End_CYCLE  1000
`define rst_delay 20.0

module sd_tb;

reg clk;
reg rst;
reg [22:0] cycle;

reg pattern [13:0];
reg pattern_in;

reg golden [13:0];

wire done;
wire Dout;
reg [3:0] raddr;
reg result [13:0];
reg verify;

integer file,f1;   //pattern
integer file3,f3;  //golden
integer i,r,v;

integer fail;

sd sd1(
       .clk                 (clk),
       .rst                 (rst),
       .pattern_in          (pattern_in),
       .done                (done),
       .Dout                (Dout)
   );

initial
begin
    $fsdbDumpfile("conv.fsdb");
    $fsdbDumpvars(0,sd_tb);
end

initial
begin
    clk = 0;
    pattern_in = 1'd0;
    rst = 1;
    cycle = 0;
    raddr = 0;
end

initial
begin
    #`rst_delay rst = 0;
end

always
begin
    forever
        #(`CYCLE/2) clk=!clk;
end

initial
begin
    file = $fopen("./dat/pattern.dat","r");
    if(file == 0)
    begin
        $display("pattern.dat handle null");
        $finish;
    end
    else
    begin
        for (f1=0 ; f1<14 ; f1=f1+1)
        begin
            $fscanf(file ,"%f",pattern[f1]);
        end
        $fclose(file);
    end
end

initial
begin
    for(i=0 ; i<14 ; i=i+1)
    begin
        @(posedge clk)
         pattern_in = pattern[i];
    end
end

always @ (posedge clk)
begin
    cycle = cycle + 1;
    if(cycle == `End_CYCLE)
    begin
        $display("-------------------------------------\n");
        $display("---Timeout !! Simulation failed !!---\n");
        $display("-------------------------------------\n");
        $fclose(file);
        $finish;
    end
end

initial
begin
    file3 = $fopen("./dat/golden.dat","r");
    if(file3 == 0)
    begin
        $display("golden.dat handle null");
        $finish;
    end
    else
    begin
        for (f3=0 ; f3<14 ; f3=f3+1)
        begin
            $fscanf(file3 ,"%f",golden[f3]);
        end
        $fclose(file3);
    end
end

always @ (posedge clk)
begin
    if(rst)
    begin
        raddr = 4'd1;
    end
    else
    begin
        raddr = raddr + 4'd1;
    end
end

always@(*)
begin
    if(rst)
    begin
        for(r=0; r<13 ; r=r+1)
        begin
            result[r] = 1'd0;
        end
    end
    else
    begin
        result[raddr-1] = Dout;
    end
end

initial
begin
    wait(done);
    $display("-------------Simulation done--------------\n");
    fail=0;

    for(v=0; v<14; v=v+1)
    begin
        if(golden[v] == result[v])
        begin
            $display("result[%d] pass",v);
        end
        else
        begin
            fail = fail + 1;
            $display("result[%d] fail , result[%d] is %d !!",v,v,result[v]);
        end
    end

    check_fail(fail);
    $finish;
end

/*display finish result*/
task check_fail;
    input integer fail;

    if(fail == 0)
    begin
        $display("-------------Finish : ALL PASS----------------\n");
    end

endtask


endmodule
