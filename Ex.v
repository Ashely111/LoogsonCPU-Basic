/////////////////////////////////////////////////////////////
// Module:  Ex
// File:    Ex.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"
module Ex (
    input wire rst,
    // signal from id
    input wire[`AluSelBus] alusel_i,
    input wire[`AluOpBus] aluop_i,
    input wire [`RegBus] reg1_i,
    input wire [`RegBus] reg2_i,
    input wire [`RegAddrBus] waddr_i,
    input wire we_i,


    // result out
    output reg we_o,
    output reg[`RegAddrBus] waddr_o,
    output reg[`RegBus] wdata_o

 );
reg[`RegBus] logicout ;

    always @(*) begin
        if (rst==`RstEnable) begin
            logicout <=`ZeroWord;
        end else begin
            case (aluop_i)
                `EXE_OP_ORI:begin
                    logicout <=reg1_i | reg2_i;
                end 
                default: begin
                    logicout <=`ZeroWord;
                end
            endcase
        end
    end 
    always @(*) begin
        waddr_o <=waddr_i;//写寄存器地址
        we_o <=we_i;//写使能
        case (alusel_i)
            `EXE_RESULT_LOGIC:begin //将逻辑运算的值作为输出结果
                wdata_o <=logicout;
            end 
            default:begin
                wdata_o <=`ZeroWord;//
            end 
        endcase
    end


endmodule