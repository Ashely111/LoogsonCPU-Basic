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
    input wire[`RegAddrBus] mem_waddr_o,
    input wire[`RegBus] mem_wdata_o,
    input wire mem_write_o,

    output reg[`RegAddrBus] wb_waddr,
    output reg[`RegBus] wb_wdata,
    output reg wb_write

);
always @(posedge clk) begin
    if (rst==`RstEnable) begin
        wb_waddr <=`NOPRegAddr;
        wb_wdata <=`ZeroWord;
        wb_write <=`WriteDisable;
    end else begin
        wb_waddr <=mem_waddr_o;
        wb_wdata <=mem_wdata_o;
        wb_write <=mem_write_o;
        end
end  
endmodule