/////////////////////////////////////////////////////////////
// Module:  Id2Ex
// File:    Id2Ex.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////
`include "Defines.v"
module Id2Ex (
    //ID input
    input wire clk,
    input wire rst,
    input wire [`RegBus] reg1_i,
    input wire [`RegBus] reg2_i,
    input wire [`RegAddrBus] waddr_i,
    input wire we_i,
    input wire [`AluSelBus] alusel_i,
    input wire[`AluOpBus] aluop_i,
    //output to EXE
    output reg [`RegBus] reg1_o,
    output reg [`RegBus] reg2_o,
    output reg we_o,
    output reg[`RegAddrBus] waddr_o,
    output reg[`AluSelBus] alusel_o,
    output reg[`AluOpBus] aluop_o



);

always @(posedge clk) begin
    if(rst==`RstEnable)begin
        reg1_o <=`ZeroWord;
        reg2_o <=`ZeroWord;
        waddr_o <=`NOPRegAddr;
        we_o <=`WriteDisable;
        aluop_o <=`EXE_OP_NOP;
        alusel_o<=`EXE_RESULT_NOP;
    end else begin
        reg1_o <=reg1_i;
        reg2_o <=reg2_i;
        we_o <=we_i;
        waddr_o <=waddr_i;
        aluop_o <=aluop_i;
        alusel_o <=alusel_i;
    end
end  
endmodule
