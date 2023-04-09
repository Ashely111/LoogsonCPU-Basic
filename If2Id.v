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
    
    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst

);
    
endmodule









