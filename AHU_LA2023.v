/////////////////////////////////////////////////////////////
// Module:  AHU_LA2023
// File:    AHU_LA2023.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////

`include "Defines.v"
module AHU_LA2023 (
   input wire clk,
   input wire rst,
    input wire [`RegBus] rom_data_i,
    output wire [`InstAddrBus] inst_addr_o   
);
//conect if2id and id
wire [`InstAddrBus] if2id_pc_id ;
wire [`InstBus] if2id_inst_id ;


//conect id and id2ex

wire [`] ;

endmodule