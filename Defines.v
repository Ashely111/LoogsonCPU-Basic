/////////////////////////////////////////////////////////////
// Module:  Defines
// File:    Defines.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
//Gloable 

`define RstEnable      1'b1
`define RstDisable      1'b0
`define ZeroWord        32'h00000000
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define InstValid       1'b1
`define InstInvalid     1'b0
`define True            1'b1
`define False           1'b0
`define ChipEnable      1'b1
`define ChipDisable     1'b0
`define AluSelBus       3:0
`define AluOpBus        5:0
`define Reg1addr        14:10
`define Reg2addr        9:5
`define Reg3addr        4:0
//Instruction
//第4类指令
`define OP4 {2'b0,OP_60,inst_i[24:22]}
`define EXE_ORI 3'b110


`define EXE_OR_OP 
`define EXE_

//AluSel

`define EXE_RESULT_NOP 3'b000 //无结果
`define EXE_RESULT_LOGIC 3'b001 
//AluOp
`define EXE_OP_NOP 6'b000000 //无操作
`define EXE_OP_ORI 6'b001110


//Inst_rom


`define InstAddrBus     31:0
`define InstBus         31:0
`define InstMemNum      131071
`define InstMemNumLog2  17




//Regfile 


`define RegAddrBus  4:0
`define RegBus      31:0
`define RegWidth    32
`define DoubleRegWith 64
`define DoubleRegBus    63:0
`define RegNum          32
`define RegNumLog2      5
`define NOPRegAddr      5'b00000





















