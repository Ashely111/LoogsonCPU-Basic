/////////////////////////////////////////////////////////////
// Module:  Minisopc_tb 
// File:    Minisopc_tb.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////
`timescale  1ns/1ps
`include "Defines.v"
module Minisopc_tb ();
    reg CLOCK_50;
    reg rst;
    initial begin
        CLOCK_50=1'b0;
        forever begin
            #10 CLOCK_50 =~CLOCK_50;
        end
    end    
    initial begin
        rst=`RstEnable;
        #195 rst=`RstDisable;
        #1000 $stop;
    end

    Minisopc Minisopc0(
        .clk(clk),
        .rst(rst)
    );
endmodule