/////////////////////////////////////////////////////////////
// Module:  Mem
// File:    Mem.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////
`include "Defines.v"

module Mem (
    input wire rst,
    input wire[`RegAddrBus] waddr_i,
    input wire[`RegBus] wdata_i,
    input wire we_i,

    output reg[`RegAddrBus] waddr_o,
    output reg[`RegBus] wdata_o,
    output reg we_o

);
always @(*) begin
    if (rst==`RstEnable) begin
        waddr_o <=`ZeroWord;
        waddr_o <=`ZeroWord;
        we_o <=`WriteDisable;
    end else  begin
        waddr_o <=waddr_i;
        wdata_o <=wdata_i;
        we_o <=we_i;
    end
end
endmodule