/////////////////////////////////////////////////////////////
// Module:  CTRL
// File:    CTRL.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"

module CTRL (
    input wire rst,
    input wire Id_CTRL_stallreq_i,
    input wire Ex_CTRL_stallreq_i,

    output reg[`StallBus]stall_o
);

// stall[5]=1表示pc不变
// stall[4]=1空指令
// stall[3]=1表示If_Id暂停
// stall[2]=1表示Id_Ex暂停
// stall[1]=1表示Ex_Mem暂停
// stall[0]=1表示Mem_Wb暂停




always @(*) begin
   if (rst==`RstEnable) begin
    stall_o <=6'b000000;
   end else if ((Ex_CTRL_stallreq_i==`Stop)) begin
    stall_o <=6'b111100;
   end else if ((Id_CTRL_stallreq_i==`Stop)) begin
    stall_o <=6'b111000;
   end else begin
    stall_o <=1'b000000;
   end
end


endmodule













