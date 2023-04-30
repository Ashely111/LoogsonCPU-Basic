/////////////////////////////////////////////////////////////
// Module:  If2Id
// File:    If2Id.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"

module If2Id (
    input wire rst,
    input wire clk,
    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus] if_inst,
    input wire [`StallBus] stall_i, 
    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst

);
always @(posedge clk) begin
    if (rst==`RstEnable) begin
        id_pc <=`ZeroWord;
        id_inst <=`ZeroWord;
    end else if ((stall_i[4]==`Stop) &&(stall_i[3]==`NotStop)) begin
        id_pc <=`ZeroWord;
        id_inst <=`ZeroWord;
    end else if(stall_i[3]==`NotStop) begin
        id_pc <=if_pc;
        id_inst <=if_inst;
    end
end    
endmodule









