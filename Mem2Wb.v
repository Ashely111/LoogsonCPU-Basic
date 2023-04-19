/////////////////////////////////////////////////////////////
// Module:  Mem2Wb
// File:    Mem2Wb.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////
`include "Defines.v"

module Mem2Wb (
    input wire rst,
    input wire clk,
    input wire[`RegAddrBus] waddr_i,
    input wire[`RegBus] wdata_i,
    input wire we_i,

    output reg[`RegAddrBus] waddr_o,
    output reg[`RegBus] wdata_o,
    output reg we_o

);
always @(posedge clk) begin
    if (rst==`RstEnable) begin
        waddr_o <=`NOPRegAddr;
        wdata_o <=`ZeroWord;
        we_o <=`WriteDisable;
    end else begin
        waddr_o <=waddr_i;
        wdata_o <=wdata_i;
        we_o <=we_i;
        end
end  
endmodule