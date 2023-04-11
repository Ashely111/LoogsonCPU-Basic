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
    input wire mem_write_i,

    output reg[`RegAddrBus] mem_waddr_o,
    output reg[`RegBus] mem_wdata_o,
    output reg mem_write_o
);
always @(*) begin
    if (rst==`RstEnable) begin
        mem_waddr_o <=`ZeroWord;
        mem_waddr_o <=`ZeroWord;
        mem_write_o <=`WriteDisable;
    end else  begin
        mem_waddr_o <=waddr_i;
        mem_wdata_o <=wdata_i;
        mem_write_o <=mem_write_i;
    end
end
endmodule