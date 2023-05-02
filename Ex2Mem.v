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
    input wire[`RegAddrBus] waddr_i,
    input wire[`RegBus] wdata_i,
    input wire we_i,

    input wire[`AluOpBus] aluop_i,
    input wire[`InstAddrBus] mem_addr_i,
    input wire[`RegBus] reg1_i,


    //stall
    input wire [`StallBus] stall_i,




    // output to MEM
    output reg[`RegBus] wdata_o,
    output reg[`RegAddrBus] waddr_o,
    output reg we_o,
//Load&Store
    output reg[`AluOpBus] aluop_o,
    output reg[`InstAddrBus] mem_adddr_o,
    output reg[`RegBus] reg1_o
);

always @(posedge clk) begin
    if (rst==`RstEnable) begin
        waddr_o <=`ZeroWord;
        wdata_o <=`ZeroWord;
        we_o <=`WriteDisable;
        aluop_o <=`EXE_OP_NOP;
        mem_adddr_o<=`ZeroWord;
        reg1_o<=`ZeroWord;
    end else if ((stall_i[2]==`Stop)&&stall_i[1]==`NotStop) begin
        waddr_o <=`ZeroWord;
        wdata_o <=`ZeroWord;
        we_o <=`WriteDisable;
        aluop_o <=`EXE_OP_NOP;
        mem_adddr_o<=`ZeroWord;
        reg1_o<=`ZeroWord;
    end else if(stall_i[1]==`NotStop) begin
        we_o <=we_i;
        waddr_o <=waddr_i;
        wdata_o <=wdata_i;
        aluop_o <=aluop_i;
        mem_adddr_o<=mem_addr_i;
        reg1_o<=reg1_i;
        
    end
end



    
endmodule