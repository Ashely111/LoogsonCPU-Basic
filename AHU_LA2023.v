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
    input wire [`RegBus] inst_i,
    output wire [`InstAddrBus] inst_addr_o, 
    output wire rom_ce_o  
);

//between Pcreg and If2Id

wire [`InstAddrBus] PcReg_If2Id_pc ;

//between If2Id and Id
wire [`InstAddrBus] If2Id_Id_pc ;
wire [`InstBus] If2Id_Id_inst ;

// between Regfile and Id
wire [`RegBus] Regfile_Id_reg1;
wire [`RegBus] Regfile_Id_reg2;

//between Id and Regfile
wire Id_Regfile_reg2_re;
wire Id_Regfile_reg1_re;
wire[`RegAddrBus] Id_Regfile_raddr1;
wire[`RegAddrBus] Id_Regfile_raddr2;
//between Id and Id2Ex
wire Id_Id2EX_we;
wire[`RegAddrBus] Id_Id2Ex_waddr;
wire[`RegBus] Id_Id2Ex_reg1;
wire[`RegBus] Id_Id2Ex_reg2;
wire[`AluSelBus] Id_Id2Ex_alusel;
wire[`AluOpBus] Id_Id2Ex_aluop;
//between Id2Ex and Ex
wire [`RegBus] Id2Ex_Ex_reg1;
wire [`RegBus] Id2Ex_Ex_reg2;
wire Id2Ex_Ex_we ;
wire [`RegAddrBus] Id2Ex_Ex_waddr ;
wire [`AluSelBus] Id2Ex_Ex_alusel ;
wire [`AluOpBus] Id2Ex_Ex_aluop ;
//between Ex and Ex2Mem

wire [`RegBus] Ex_Ex2Mem_wdata ;
wire [`RegAddrBus] Ex_Ex2Mem_waddr ;
wire Ex_Ex2Mem_we ;

//between Ex2Mem and Mem

wire [`RegBus] Ex2Mem_Mem_wdata ;
wire [`RegAddrBus] Ex2Mem_Mem_waddr ;
wire Ex2Mem_Mem_we;

//between Mem and Mem2Wb

wire [`RegBus] Mem_Mem2Wb_wdata;
wire [`RegAddrBus] Mem_Mem2Wb_waddr ;
wire Mem_Mem2Wb_we;


//between Mem2Wb and Regfile 

wire [`RegAddrBus] Mem2Wb_Regfile_waddr ;
wire Mem2Wb_Regfile_we;
wire [`RegBus] Mem2Wb_Regfile_wdata ;


// instance PcReg

PcReg PcReg0(
    .clk(clk),
    .rst(rst),
    .pc(PcReg_If2Id_pc),
    .ce(rom_ce_o)
);

assign inst_addr_o =PcReg_If2Id_pc;

//instance If2Id

If2Id If2Id0(
    .clk(clk),
    .rst(rst),
    .if_pc(PcReg_If2Id_pc),
    .if_inst(inst_i),
    .id_pc(If2Id_Id_pc),
    .id_inst(If2Id_Id_inst)
);

//instance Id

Id Id0(

    .rst(rst),
    .pc_i(If2Id_Id_pc),
    .inst_i(If2Id_Id_inst),
    .raddr1_o(Id_Regfile_raddr1),
    .raddr2_o(Id_Regfile_raddr2),
    .reg2_re_o(Id_Regfile_reg2_re),
    .reg1_re_o(Id_Regfile_reg1_re),
    .reg1_i(Regfile_Id_reg1),
    .reg2_i(Regfile_Id_reg2),
    .waddr_o(Id_Id2Ex_waddr),
    .we_o(Id_Id2EX_we),
    .reg1_o(Id_Id2Ex_reg1),
    .reg2_o(Id_Id2Ex_reg2),
    .alusel_o(Id_Id2Ex_alusel),
    .aluop_o(Id_Id2Ex_aluop)

);


//instance Regfile


Regfile Regfile0(
    .clk(clk),
    .rst(rst),
    .we(Mem2Wb_Regfile_we),
    .waddr(Mem2Wb_Regfile_waddr),
    .wdata(Mem2Wb_Regfile_wdata),
    .re1(Id_Regfile_reg1_re),
    .raddr1(Id_Regfile_raddr1),
    .re2(Id_Regfile_reg2_re),
    .raddr2(Id_Regfile_raddr2),
    .rdata1(Regfile_Id_reg1),
    .rdata2(Regfile_Id_reg2)
);

//instance Id2Ex

Id2Ex Id2Ex0(
    .clk(clk),
    .rst(rst),
    .reg1_i(Id_Id2Ex_reg1),
    .reg2_i(Id_Id2Ex_reg2),
    .waddr_i(Id_Id2Ex_waddr),
    .we_i(Id_Id2EX_we),
    .alusel_i(Id_Id2Ex_alusel),
    .aluop_i(Id_Id2Ex_aluop),

    .reg1_o(Id2Ex_Ex_reg1),
    .reg2_o(Id2Ex_Ex_reg2),
    .we_o(Id2Ex_Ex_we),
    .waddr_o(Id2Ex_Ex_waddr),
    .alusel_o(Id2Ex_Ex_alusel),
    .aluop_o(Id2Ex_Ex_aluop)
);


//instance Ex

Ex Ex0(
    .rst(rst),
    .reg1_i(Id2Ex_Ex_alusel),
    .reg2_i(Id_Id2Ex_reg2),
    .waddr_i(Id2Ex_Ex_waddr),
    .we_i(Id2Ex_Ex_we),
    .alusel_i(Id_Id2Ex_alusel),
    .aluop_i(Id2Ex_Ex_aluop),

    .wdata_o(Ex_Ex2Mem_wdata),
    .waddr_o(Ex_Ex2Mem_waddr),
    .we_o(Ex_Ex2Mem_we)
);


//instance Ex2Mem


Ex2Mem Ex2Mem0(
    .rst(rst),
    .clk(clk),
    .waddr_i(Ex_Ex2Mem_waddr),
    .wdata_i(Ex_Ex2Mem_wdata),
    .we_i(Ex_Ex2Mem_we),

    .waddr_o(Ex2Mem_Mem_waddr),
    .wdata_o(Ex2Mem_Mem_wdata),
    .we_o(Ex2Mem_Mem_we)

);

// instance Mem


Mem Mem0(
    .rst(rst),
    .waddr_i(Ex2Mem_Mem_waddr),
    .wdata_i(Ex2Mem_Mem_wdata),
    .we_i(Ex2Mem_Mem_we),

    .waddr_o(Mem_Mem2Wb_waddr),
    .wdata_o(Mem_Mem2Wb_wdata),
    .we_o(Mem_Mem2Wb_we)
);

//instance Mem2Wb


Mem2Wb Me2Wb0(
    .rst(rst),
    .clk(clk),
    .waddr_i(Mem_Mem2Wb_waddr),
    .wdata_i(Mem_Mem2Wb_wdata),
    .we_i(Mem_Mem2Wb_we),


    .waddr_o(Mem2Wb_Regfile_waddr),
    .wdata_o(Mem2Wb_Regfile_wdata),
    .we_o(Mem2Wb_Regfile_we)
);























endmodule