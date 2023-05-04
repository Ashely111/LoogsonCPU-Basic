/////////////////////////////////////////////////////////////
// Module:  Minisopc 
// File:    Minisopc.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////
`include "Defines.v"
module Minisopc(
    input wire clk,
    input wire rst
);
// connect to Inst_rom
wire AHU_LA2023_Inst_rom_ce;
wire[`InstAddrBus] AHU_LA2023_Inst_rom_instaddr;

wire[`InstBus] Inst_rom_AHU_LA2023_inst;
wire[`InstAddrBus] Mem_Ram_addr;
wire[`RegBus] Mem_Ram_data;
wire Mem_Ram_mem_we;
wire[`DataTypeBus] Mem_Ram_datatype_sel;
wire Mem_Ram_mem_ce;
wire[`RegBus] Ram_Mem_data;


AHU_LA2023 AHU_LA2023_0(
    .clk(clk),
    .rst(rst),
    .inst_i(Inst_rom_AHU_LA2023_inst),

    .inst_addr_o(AHU_LA2023_Inst_rom_instaddr),
    .rom_ce_o(AHU_LA2023_Inst_rom_ce),
    .Ram_Mem_data_i(Ram_Mem_data),

    .Mem_Ram_addr_o(Mem_Ram_addr),
    .Mem_Ram_mem_we_o(Mem_Ram_mem_we),
    .Mem_Ram_mem_ce_o(Mem_Ram_mem_ce),
    .Mem_Ram_data_o(Mem_Ram_data),
    .Mem_Ram_datatype_sel_o(Mem_Ram_datatype_sel)
);

Inst_rom Inst_rom0(
    .instaddr_i(AHU_LA2023_Inst_rom_instaddr),
    .ce(AHU_LA2023_Inst_rom_ce),

    .inst_o(Inst_rom_AHU_LA2023_inst)
);

Ram Ram0(

    .clk(clk),

    .data_i(Mem_Ram_data),
    .we_i(Mem_Ram_mem_we),
    .addr_i(Mem_Ram_addr),
    .ce_i(Mem_Ram_mem_ce),
    .datatype_sel_i(Mem_Ram_datatype_sel),

    .data_o(Ram_Mem_data)


);







endmodule