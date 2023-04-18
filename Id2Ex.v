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
    input wire [`RegBus] id_reg1,
    input wire [`RegBus] id_reg2,
    input wire [`RegAddrBus] id_waddr,
    input wire id_reg_w_o,
    input wire [`AluSelBus] alusel_i,
    input wire[`AluOpBus] aluop_i,
    //output to EXE
    output reg [`RegBus] ex_reg1,
    output reg [`RegBus] ex_reg2,
    output reg ex_reg_w_o,
    output reg[`RegAddrBus] ex_waddr,
    output reg[`AluSelBus] alusel_o,
    output reg[`AluOpBus] aluop_o



);

always @(posedge clk) begin
    if(rst==`RstEnable)begin
        ex_reg1 <=`ZeroWord;
        ex_reg2 <=`ZeroWord;
        ex_waddr <=`NOPRegAddr;
        ex_reg_w_o <=`WriteDisable;
        aluop_o <=`EXE_OP_NOP;
        alusel_o<=`EXE_RESULT_NOP;
    end else begin
        ex_reg1 <=id_reg1;
        ex_reg2 <=id_reg2;
        ex_reg_w_o <=id_reg_w_o;
        ex_waddr <=id_waddr;
        aluop_o <=aluop_i;
        alusel_o <=alusel_i;
    end
end  
endmodule
