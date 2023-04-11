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
    input wire[`InstAddrBus] instaddr,
    output reg[`InstBus] inst
);

// size InstMemNum, with InstBus
reg[`InstBus] inst_mem[0:`InstMemNum-1];

//initial mem

initial $readmem ("inst_rom.data",inst_mem);

//output inst

always @(*) begin
    if (ce==`ChipDisable) begin
        inst <=`ZeroWord;
    end else begin
        inst <=inst_mem[instaddr[`InstMemNumLog2+1:2]];
    end
end






endmodule