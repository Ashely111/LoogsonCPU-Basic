/////////////////////////////////////////////////////////////
// Module:  Inst_rom
// File:    Inst_rom.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"


module Inst_rom (
    input wire ce,
    input wire[`InstAddrBus] instaddr_i,
    output reg[`InstBus] inst_o
);

// size InstMemNum, with InstBus
reg[`InstBus] inst_mem[0:`InstMemNum-1];

//initial mem

initial $readmem ("inst_rom.data",inst_mem);

//output inst

always @(*) begin
    if (ce==`ChipDisable) begin
        inst_o <=`ZeroWord;
    end else begin
        inst_o <=inst_mem[instaddr_i[`InstMemNumLog2+1:2]];
    end
end






endmodule