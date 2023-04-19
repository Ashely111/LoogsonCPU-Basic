/////////////////////////////////////////////////////////////
// Module:  Ex2Mem
// File:    Ex2Mem.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"

module Ex2Mem (
    input wire rst,
    input wire clk,

    //input from EXE 
    input wire[`RegBus] waddr_i,
    input wire[`RegAddrBus] wdata_i,
    input wire we_i,
    // output to MEM
    output reg[`RegBus] wdata_o,
    output reg[`RegAddrBus] waddr_o,
    output reg we_o
);

always @(posedge clk) begin
    if (rst==`RstEnable) begin
        waddr_o <=`ZeroWord;
        wdata_o <=`ZeroWord;
        we_o <=`WriteDisable;
    end else begin
        we_o <=we_i;
        waddr_o <=waddr_i;
        wdata_o <=wdata_i;
        
    end
end



    
endmodule