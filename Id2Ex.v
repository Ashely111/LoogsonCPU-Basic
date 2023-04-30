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

    //stall
    input wire[`StallBus] stall_i,


    //output to EXE
    output reg [`RegBus] reg1_o,
    output reg [`RegBus] reg2_o,
    output reg we_o,
    output reg[`RegAddrBus] waddr_o,
    output reg[`AluSelBus] alusel_o,
    output reg[`AluOpBus] aluop_o,

    //branch

    input wire idis_in_delay_slot_i,//当前译码阶段指令是否处于延迟槽
    input wire [`InstAddrBus] link_addr_i,//转移指令要保存的返回地址
    input wire next_inst_in_delayslot_i,//下一条进入译码指令是否处于延迟槽

    output reg exis_in_delayslot_o,//执行阶段的转移指令是否位于延迟槽
    output reg[`InstAddrBus] link_addr_o,
    output reg is_in_delayslot_o//当前处于译码阶段指令是否位于延迟槽

);

always @(posedge clk) begin
    if(rst==`RstEnable)begin
        reg1_o <=`ZeroWord;
        reg2_o <=`ZeroWord;
        waddr_o <=`NOPRegAddr;
        we_o <=`WriteDisable;
        aluop_o <=`EXE_OP_NOP;
        alusel_o<=`EXE_RESULT_NOP;

        exis_in_delayslot_o<=`NotInDelaySlot;
        link_addr_o<=`ZeroWord;
        is_in_delayslot_o <=`NotInDelaySlot;
    end else if ((stall_i[3]==`Stop)&&stall_i[2]==`NotStop) begin
        reg1_o <=`ZeroWord;
        reg2_o <=`ZeroWord;
        waddr_o <=`NOPRegAddr;
        we_o <=`WriteDisable;
        aluop_o <=`EXE_OP_NOP;
        alusel_o<=`EXE_RESULT_NOP;
        exis_in_delayslot_o<=`NotInDelaySlot;
        link_addr_o<=`ZeroWord;
    end else if(stall_i[2]==`NotStop) begin
        reg1_o <=reg1_i;
        reg2_o <=reg2_i;
        we_o <=we_i;
        waddr_o <=waddr_i;
        aluop_o <=aluop_i;
        alusel_o <=alusel_i;
        exis_in_delayslot_o<=next_inst_in_delayslot_i;
        link_addr_o<=link_addr_i;
        is_in_delayslot_o <=idis_in_delay_slot_i;
    end
end  
endmodule
