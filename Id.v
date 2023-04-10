/////////////////////////////////////////////////////////////
// Module:  Id
// File:    Id.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////

`include "Defines.v"
module Id (
    input wire rst,
    input wire[`InstAddrBus] pc_i,
    input wire[`InstBus] inst_i,

    // input regfile values
    input wire[`RegBus] reg1_data_i,
    input wire[`RegBus] reg2_data_i,
    

    //output regfile values
    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`RegAddrBus] reg1_addr_o,
    output reg[`RegAddrBus] reg2_addr_o,

    //transent to  id2ex
    output reg[`RegBus] reg1_data_o,
    output reg[`RegBus] reg2_data_o,
    output reg[`RegAddrBus] waddr_o,
    output reg reg_write_o

);










endmodule