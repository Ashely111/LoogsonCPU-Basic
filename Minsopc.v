/////////////////////////////////////////////////////////////
// Module:  Minisopc 
// File:    Minisopc.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////

module Minisopc(
    input wire clk,
    input wire rst
);
// connect to Inst_rom
wire AHU_LA2023_Inst_rom_ce;
wire AHU_LA2023_Inst_rom_instaddr;

wire Inst_rom_AHU_LA2023_inst;

AHU_LA2023 AHU_LA2023_0(
    .clk(clk),
    .rst(rst),
    .inst_i(Inst_rom_AHU_LA2023_inst),

    .inst_addr_o(AHU_LA2023_Inst_rom_instaddr),
    .rom_ce_o(AHU_LA2023_Inst_rom_ce)
);

Inst_rom Inst_rom0(
    .instaddr_i(AHU_LA2023_Inst_rom_instaddr),
    .ce(AHU_LA2023_Inst_rom_ce),

    .inst_o(Inst_rom_AHU_LA2023_inst)
);






endmodule