/////////////////////////////////////////////////////////////
// Module:  Defines
// File:    Defines.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
//Globle 

`define RstEnable      1'b1
`define RstDisable      1'b0
`define ZeroWord        32'h00000000
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define InstValid       1'b0
`define InstInvalid     1'b0
`define True            1'b1
`define False           1'b0
`define ChipEnable      1'b1
`define ChipDisable     1'b0


//Instruction






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





















