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
`define AluSelBus       2:0
`define AluOpBus        5:0
`define Reg1addr        14:10
`define Reg2addr        9:5
`define Reg3addr        4:0
`define StallBus         5:0

`define Stop 1'b1
`define NotStop 1'b0

`define DivFree 2'b00 //除法模块空闲
`define DivByZero 2'b01 //除数为0
`define DivOn 2'b10 //除法运算进行中
`define DivEnd 2'b11 //除法运算结束
`define DivResultReady 1'b1 
`define DivResultNotReady 1'b0
`define DivStart 1'b1
`define DivStop 1'b0

`define Branch 1'b1
`define NotBranch 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define DataTypeBus 3:0

//Ram

`define DataAddrBus 31:0
`define DataBus 31:0
`define DataMemNum 131071 //RAM大小，128K Byte
`define DataMemNumLog2 17 //实际使用地址宽度
`define ByteWidth 7:0 //一个字宽度














//Instruction译码阶段识别
//第7类指令

`define EXE_NOR 5'b01000//
`define EXE_AND 5'b01001//
`define EXE_OR 5'b01010//
`define EXE_XOR 5'b01011//
`define EXE_SLL_W 5'b01110//
`define EXE_SRL_W 5'b01111//
`define EXE_SRA_W 5'b10000//

`define EXE_ADD_W 5'b00000//
`define EXE_SUB_W 5'b00010//
`define EXE_SLT 5'b00100
`define EXE_SLTU 5'b00101

`define EXE_MUL_W 5'b11000
`define EXE_MULH_W 5'b11001
`define EXE_MULH_WU 5'b11010


//第6类指令

`define EXE_DIV_W 6'b000000
`define EXE_MOD_W 6'b000001
`define EXE_DIV_WU 6'b000010
`define EXE_MOD_WU 6'b000011

`define BREAK  6'b010100
`define SYSCALL 6'b010110







//第5类指令
`define EXE_SLLI_W 5'b00001//
`define EXE_SRLI_W 5'b01001//
`define EXE_SRAI_W 5'b10001//


//第4类指令


`define EXE_ORI 3'b110//
`define EXE_ANDI 3'b101//
`define EXE_XORI 3'b111//
`define EXE_NOP  3'b101// =ANDI r0,r0,0//
`define EXE_ADDI_W 3'b010//
`define EXE_SLTI 3'b000
`define EXE_SLTUI 3'b001



//第3类指令


`define EXE_LU12I_W 3'b010//
`define EXE_PCADDU12I 3'b110


//第2类指令

`define EXE_LD_B 4'b0000
`define EXE_LD_H 4'b0001
`define EXE_LD_W 4'b0010
`define EXE_ST_B 4'b0100
`define EXE_ST_H 4'b0101
`define EXE_ST_W 4'b0110
`define EXE_LD_BU 4'b1000
`define EXE_LD_HU 4'b1001
`define EXE_PRELD 4'b1011


//第1类指令

`define EXE_JIRL 5'b10011
`define EXE_B 5'b10100
`define EXE_BL 5'b10101
`define EXE_BEQ 5'b10110
`define EXE_BNE 5'b10111
`define EXE_BLT 5'b11000
`define EXE_BGE 5'b11001
`define EXE_BLTU 5'b11010
`define EXE_BGEU 5'b11011



//AluSel/////////////////////////////////////////

`define EXE_RESULT_NOP 3'b000 //无结果
`define EXE_RESULT_LOGIC 3'b001 
`define EXE_RESULT_SHIFT 3'b010
`define EXE_RESULT_ARITHMETIC 3'b011
`define EXE_RESULT_DIV 3'b100
`define EXE_RESULT_BRANCH 3'b101
`define EXE_RESULT_LOAD_STORE 3'b110






















//AluOp//执行阶段识别///////////////////////////////////////////
`define EXE_OP_NOP 6'b000000 //无操作
`define EXE_OP_ORI 6'b001110//
`define EXE_OP_ANDI 6'b001101 //EXE_OP_NOP 
`define EXE_OP_XORI 6'b001111//
`define EXE_OP_ADDI_W 6'b001010
`define EXE_OP_SLTI 6'b001000
`define EXE_OP_SLTUI 6'b001001



`define EXE_OP_NOR 6'b101000//
`define EXE_OP_AND 6'b101001//
`define EXE_OP_OR 6'b101010//
`define EXE_OP_XOR 6'b101011//

`define EXE_OP_SLL_W 6'b101110//
`define EXE_OP_SRL_W 6'b101111//
`define EXE_OP_SRA_W 6'b110000//
`define EXE_OP_SLLI_W 6'b000001//
`define EXE_OP_SRLI_W 6'b001001//
`define EXE_OP_SRAI_W 6'b010001//

`define EXE_OP_ADD_W 6'b100000//
`define EXE_OP_SUB_W 6'b100010//
`define EXE_OP_SLT 6'b100100
`define EXE_OP_SLTU 6'b100101


`define EXE_OP_DIV_W 6'b000000
`define EXE_OP_MOD_W 6'b000001
`define EXE_OP_DIV_WU 6'b000010
`define EXE_OP_MOD_Wu 6'b000011

`define BREAK  6'b010100
`define SYSCALL 6'b010110

`define EXE_OP_LD_B 6'b100000
`define EXE_OP_LD_H 6'b100001
`define EXE_OP_LD_W 6'b100010
`define EXE_OP_ST_B 6'b100100
`define EXE_OP_ST_H 6'b100101
`define EXE_OP_ST_W 6'b100110
`define EXE_OP_LD_BU 6'b101000
`define EXE_OP_LD_HU 6'b101001
`define EXE_OP_PRELD 6'b101011

`define EXE_OP_JIRL 6'b010011
`define EXE_OP_B 6'b010100
`define EXE_OP_BL 6'b010101
`define EXE_OP_BEQ 6'b010110
`define EXE_OP_BNE 6'b010111
`define EXE_OP_BLT 6'b011000
`define EXE_OP_BGE 6'b011001
`define EXE_OP_BLTU 6'b011010
`define EXE_OP_BGEU 6'b011011

`define EXE_OP_MUL_W 6'b111000
`define EXE_OP_MULH_W 6'b111001
`define EXE_OP_MULH_WU 6'b111010















/////////////////////////////////////Inst_rom


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

`define Reg0 5'b00000
`define Reg1 5'b00001



















