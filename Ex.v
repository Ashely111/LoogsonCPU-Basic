/////////////////////////////////////////////////////////////
// Module:  Ex
// File:    Ex.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"
module EX (
    input wire rst,
    // signal from id

    input wire [`RegBus] reg1_i,
    input wire [`RegBus] reg2_i,
    input wire [`RegAddrBus] waddr_i,
    input wire reg_write_i,


    // result out

    output reg[`RegBus] ex_wdata_o,
    output reg[`RegAddrBus] ex_waddr_o,
    output reg ex_write_o
    




);
    reg[RegBus] logicout ;
    always @(*) begin
        if (rst==`RstEnable) begin
            logicout <=`ZeroWord;
        end else begin
            case (aluop_i)
                `EXE_OR_OP:begin
                    logicout <=reg1_i | reg2_i;
                end 
                default: begin
                    logicout <=`ZeroWord;
                end
            endcase
        end
    end 








endmodule