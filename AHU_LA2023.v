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
    input wire [`InstBus] inst_i,
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


//stall
wire [`StallBus] CTRL_stall ;
wire Id_CTRL_stallreq;
wire Ex_CTRL_stallreq;

// between div and ex

// wire [`RegBus] Ex_Div_opdata1 ;
// wire [`RegBus] EX_Div_opdata2 ;
// wire signed_div;
// wire div_cancel;
// wire div_start;

// wire [`DoubleRegBus] Div_Ex_dive_result;
// wire Div_Ex_div_ready;

//branch


wire [`InstAddrBus]Id_PcReg_branch_addr;
wire[`InstAddrBus]Id_Id2Ex_link_addr;
wire [`InstAddrBus]Id2Ex_Ex_link_addr;
wire Id_PcReg_branch_flag;
wire Id_Id2Ex_next_inst_in_delayslot;
wire Id_Id2Ex_is_in_delayslot;
wire Id2Ex_Ex_is_in_delayslot;
wire Id2Ex_Id_is_in_delayslot;

//Load/Store


wire[`InstAddrBus] Id_Id2EX_inst;
wire[`InstAddrBus] Id2Ex_Ex_inst;
wire[`AluOpBus] Ex_Ex2Mem_aluop;
wire[`InstAddrBus] Ex_Ex2Mem_mem_addr;
wire[`RegBus] Ex_Ex2Mem_reg1;
wire[`AluOpBus] Ex2Mem_Mem_aluop;
wire[`InstAddrBus] Ex2Mem_Mem_mem_addr;
wire[`RegBus] Ex2Mem_Mem_reg1 ;
wire[`InstAddrBus] Mem_Ram_addr;
wire[`RegBus] Mem_Ram_data;
wire Mem_Ram_mem_we;
wire[`DataTypeBus] Mem_Ram_datatype_sel;
wire Mem_Ram_mem_ce;
wire[`RegBus] Ram_Mem_data;















// instance PcReg

PcReg PcReg0(
    .clk(clk),
    .rst(rst),
    .pc(PcReg_If2Id_pc),
    .ce(rom_ce_o),
    .stall_i(CTRL_stall),
    .branch_target_addr_i(Id_PcReg_branch_addr),
    .branch_flag_i(Id_PcReg_branch_flag)//分支信号
);

assign inst_addr_o =PcReg_If2Id_pc;

//instance If2Id

If2Id If2Id0(
    .clk(clk),
    .rst(rst),
    .if_pc(PcReg_If2Id_pc),
    .if_inst(inst_i),
    .id_pc(If2Id_Id_pc),
    .id_inst(If2Id_Id_inst),
    .stall_i(CTRL_stall)
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
    .aluop_o(Id_Id2Ex_aluop),


    .Ex_we_i(Ex_Ex2Mem_we),
    .Ex_waddr_i(Ex_Ex2Mem_waddr),
    .Ex_wdata_i(Ex_Ex2Mem_wdata),

    .Mem_we_i(Mem_Mem2Wb_we),
    .Mem_waddr_i(Mem_Mem2Wb_waddr),
    .Mem_wdata_i(Mem_Mem2Wb_wdata),

    // .Id_CTRL_stallreq_o(Id_CTRL_stallreq)

    .is_in_delayslot_o(Id_Id2Ex_is_in_delayslot),
    .link_addr_o(Id_Id2Ex_link_addr),
    .branch_target_addr_o(Id_PcReg_branch_addr),
    .branch_flag_o(Id_PcReg_branch_flag),
    .next_inst_in_delayslot_o(Id_Id2Ex_next_inst_in_delayslot),
    .is_in_delayslot_i(Id2Ex_Id_is_in_delayslot),

    .inst_o(Id_Id2EX_inst)
);


//instance Regfile


Regfile Regfile0(
    .clk(clk),
    .rst(rst),
    .we_i(Mem2Wb_Regfile_we),
    .waddr_i(Mem2Wb_Regfile_waddr),
    .wdata_i(Mem2Wb_Regfile_wdata),
    .re1_i(Id_Regfile_reg1_re),
    .raddr1_i(Id_Regfile_raddr1),
    .re2_i(Id_Regfile_reg2_re),
    .raddr2_i(Id_Regfile_raddr2),
    .rdata1_o(Regfile_Id_reg1),
    .rdata2_o(Regfile_Id_reg2)
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
    .aluop_o(Id2Ex_Ex_aluop),
    .stall_i(CTRL_stall),

    //branch
    .idis_in_delayslot_i(Id_Id2Ex_is_in_delayslot),
    .link_addr_i(Id_Id2Ex_link_addr),
    .next_inst_in_delayslot_i(Id_Id2Ex_next_inst_in_delayslot),

    .exis_in_delayslot_o(Id2Ex_Ex_is_in_delayslot),
    .link_addr_o(Id2Ex_Ex_link_addr),
    .is_in_delayslot_o(Id2Ex_Id_is_in_delayslot),

    .inst_i(Id_Id2EX_inst)
);


//instance Ex

Ex Ex0(
    .rst(rst),
    .reg1_i(Id2Ex_Ex_reg1),
    .reg2_i(Id2Ex_Ex_reg2),
    .waddr_i(Id2Ex_Ex_waddr),
    .we_i(Id2Ex_Ex_we),
    .alusel_i(Id2Ex_Ex_alusel),
    .aluop_i(Id2Ex_Ex_aluop),

    .wdata_o(Ex_Ex2Mem_wdata),
    .waddr_o(Ex_Ex2Mem_waddr),
    .we_o(Ex_Ex2Mem_we),

    // .div_ready_i(Div_Ex_div_ready),
    // .div_result_i(Div_Ex_dive_result),

    // .div_opdata1_o(Ex_Div_opdata1),
    // .div_opdata2_o(EX_Div_opdata2),
    // .sigend_div_o(signed_div),
    // .cancel_o(div_cancel),
    // .start_o(div_start)


    // .Ex_CTRL_stallreq_o(Ex_CTRL_stallreq)

    //branch
    .is_in_delayslot_i(Id2Ex_Ex_is_in_delayslot),
    .link_addr_i(Id2Ex_Ex_link_addr),


    .inst_i(Id2Ex_Ex_inst),
    .aluop_O(Ex_Ex2Mem_aluop),
    .mem_addr_o(Ex_Ex2Mem_mem_addr),
    .reg1_o(Ex_Ex2Mem_reg1)
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
    .we_o(Ex2Mem_Mem_we),
    .stall_i(CTRL_stall),

    .reg1_i(Ex_Ex2Mem_reg1),
    .mem_addr_i(Ex_Ex2Mem_mem_addr),
    .aluop_i(Ex_Ex2Mem_aluop),


    .reg1_o(Ex2Mem_Mem_reg1),
    .mem_addr_o(Ex2Mem_Mem_mem_addr),
    .aluop_o(Ex2Mem_Mem_aluop)

);

// instance Mem


Mem Mem0(
    .rst(rst),
    .waddr_i(Ex2Mem_Mem_waddr),
    .wdata_i(Ex2Mem_Mem_wdata),
    .we_i(Ex2Mem_Mem_we),

    .waddr_o(Mem_Mem2Wb_waddr),
    .wdata_o(Mem_Mem2Wb_wdata),
    .we_o(Mem_Mem2Wb_we),

    .aluop_i(Ex2Mem_Mem_aluop),
    .mem_addr_i(Ex2Mem_Mem_mem_addr),
    .reg1_i(Ex2Mem_Mem_reg1),
    .mem_data_i(Ram_Mem_data),

    .mem_addr_o(Mem_Ram_addr),
    .mem_we_o(Mem_Ram_mem_we),
    .datatype_sel_o(Mem_Ram_datatype_sel),
    .mem_ce_o(Mem_Ram_mem_ce),
    .mem_data_o(Mem_Ram_data)
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
    .we_o(Mem2Wb_Regfile_we),
    .stall_i(CTRL_stall)    
        
);


//instance CTRL
CTRL CTRL0 (
    .rst(rst),
    .Id_CTRL_stallreq_i(Id_CTRL_stallreq),
    .Ex_CTRL_stallreq_i(Ex_CTRL_stallreq),

    .stall_o(CTRL_stall)
 
);


//instance div

// Div Div0(
//     .clk(clk),
//     .rst(rst),
//     .opdata1_i(Ex_Div_opdata1),
//     .opdata2_i(Ex_Div_opdata2),
//     .signed_div_i(signed_div),
//     .cancel_i(div_cancel),
//     .start_i(div_start),

//     .div_result_o(Div_Ex_div_result),
//     .div_ready_o(Div_Ex_div_ready)




// );
//




//Ram

Ram Ram0(

    .clk(clk),
    .rst(rst),
    .data_i(Mem_Ram_data),
    .we_i(Mem_Ram_mem_we),
    .addr_i(Mem_Ram_addr),
    .ce_i(Mem_Ram_mem_ce),
    .datatype_sel_i(Mem_Ram_datatype_sel),

    .data_o(Mem_Ram_data)


);












endmodule