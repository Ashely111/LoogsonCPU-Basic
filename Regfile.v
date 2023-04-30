/////////////////////////////////////////////////////////////
// Module:  Regfile
// File:    Regfile.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////

`include "Defines.v"


module Regfile (
    input wire clk,
    input wire rst,
    //write port 
    input wire we_i,
    input wire [`RegAddrBus] waddr_i,
    input wire [`RegBus] wdata_i,
    //read port 1
    input wire re1_i,
    input wire[`RegAddrBus] raddr1_i,
    output reg [`RegBus] rdata1_o,
    //read port 2
    input wire re2_i ,
    input wire [`RegAddrBus] raddr2_i,
    output reg [`RegBus] rdata2_o

);
// 32 registers
reg [`RegBus] regs[0:`RegNum-1]  ;



// write operation
always @(posedge clk) begin
  if (rst==`RstDisable) begin
    if ((we_i==`WriteEnable)&&(waddr_i !=`RegNumLog2'h0)) begin
        regs[waddr_i] <= wdata_i;
    end
  end  
end

// read port 1
always @(*) begin
    if (rst==`RstEnable) begin
        rdata1_o <= `ZeroWord;
    end else if (raddr1_i ==`RegNumLog2'h0) begin
        rdata1_o <= `ZeroWord;
    end else if ((raddr1_i==waddr_i)&&(we_i==`WriteEnable)&&(re1_i==`ReadEnable)) begin
        rdata2_o <=wdata_i;
    end else if (re1_i==`ReadEnable) begin
        rdata1_o <= regs[raddr1_i];
    end else begin
        rdata1_o <=`ZeroWord;
    end
end

//read port 2
always @(*) begin
    if (rst==`RstEnable) begin
        rdata2_o <=`ZeroWord;
    end else if (raddr2_i==`RegNumLog2'h00000000) begin
        rdata2_o <=`ZeroWord;
    end else if ((raddr2_i == waddr_i)&&(we_i==`WriteEnable)&&(re2_i==`ReadEnable) ) begin
        rdata2_o <=wdata_i;
    end else if (re2_i==`ReadEnable) begin
        rdata2_o <=regs[raddr2_i];
    end else begin
        rdata2_o <=`ZeroWord;
    end
end

endmodule