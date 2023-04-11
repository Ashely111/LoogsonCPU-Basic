/////////////////////////////////////////////////////////////
// Module:  Ex2Mem
// File:    Ex2Mem.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"

module Ex2Mem (
    input wire rst,
    input wire clk,

    //input from EXE 
    input wire[`RegBus] ex_waddr,
    input wire[`RegAddrBus] ex_wdata,
    input wire ex_reg_w,
    // output to MEM
    output reg[`RegBus] mem_wdata,
    output reg[`RegAddrBus] mem_waddr,
    output reg mem_write
);

always @(posedge clk) begin
    if (rst==`RstEnable) begin
        mem_waddr <=`ZeroWord;
        mem_wdata <=`ZeroWord;
        mem_write <=`WriteDisable;
    end else begin
        mem_write <=ex_reg_w;
        mem_waddr <=ex_waddr;
        mem_wdata <=ex_wdata;
        
    end
end



    
endmodule