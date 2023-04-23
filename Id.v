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
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    

    //output regfile values
    output reg reg1_re_o,
    output reg reg2_re_o,
    output reg[`RegAddrBus] raddr1_o,
    output reg[`RegAddrBus] raddr2_o,
    //transent to  id2ex
    output reg[`AluSelBus] alusel_o,
    output reg[`AluOpBus]   aluop_o,
    output reg[`RegBus] reg1_o,
    output reg[`RegBus] reg2_o,
    output reg[`RegAddrBus] waddr_o,
    output reg we_o

);
wire op_10 = inst_i[30];// 第一类指令 
wire op_20= inst_i[29];// 第二类指令
wire op_30= inst_i[28];//第三类指令
wire op_60= inst_i[25];//第四类指令
wire op_90=inst_i[22];//第五类指令
wire op_A0= inst_i[21];//第六类指令
wire op_B0=inst_i[20];//第七类指令
//
reg[`RegBus] imm;
//
reg instvalid;

//decode

always @(*) begin
        if(rst==`RstEnable)begin
            raddr1_o <=`NOPRegAddr;
            raddr2_o <=`NOPRegAddr;
            reg1_re_o <=1'b0;
            reg2_re_o <=1'b0;
            imm <=`ZeroWord;
            instvalid <=`InstInvalid;
        we_o <=`WriteDisable;
            waddr_o <=`NOPRegAddr;
            alusel_o <=`EXE_RESULT_NOP;
            aluop_o <=`EXE_OP_NOP;
        end else begin
            raddr1_o <=inst_i[`Reg1addr];
            raddr2_o <=inst_i[`Reg2addr];
            reg1_re_o <=1'b0;
            reg2_re_o <=1'b0;
            imm <=`ZeroWord;
            instvalid <=`InstInvalid;
            we_o <=`WriteDisable;
            waddr_o <=`NOPRegAddr; 
            alusel_o <=`EXE_RESULT_NOP;
            aluop_o <=`EXE_OP_NOP;

            if (op_10==1'b1) begin//第30位作为第一类指令特征码
            


                end else if (op_20==1'b1) begin//第29位作为第二类指令特征码
                        

                    end else if (op_30==1'b1) begin//第28位作为第三类指令特征码
                            
                        end else if (op_60==1'b1)begin//第25位作为第四类指令特征码
                            case (inst_i[24:22])
                                `EXE_ORI:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;
                                    
                                        imm<={20'b0,inst_i[21:10]};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_LOGIC;
                                        aluop_o <=`EXE_OP_ORI;
                                        instvalid <=`InstValid;
                                    end  
                            endcase                     
                            end else if (op_90==1'b1) begin//第22位作为第五类指令特征码
                            
                                end else if (op_A0==1'b1) begin//第21位作为第六类指令特征码
                                
                                    end else if (op_B0==1'b1) begin//第20位作为第七类指令特征码
                                
                                        end
        end

end





//确定第1个源操作数
always @(*) begin
    if(rst==`RstEnable)begin
        reg1_o <=`ZeroWord;//端口1的值
    end else if(reg1_re_o==1'b1)begin
        reg1_o <=reg1_i;
    end else if(reg1_re_o==1'b0)begin
        reg1_o <=imm; 
    end else begin
        reg1_o <=`ZeroWord;
    end
end
//确定第2个源操作数
always @(*) begin
    if(rst==`RstEnable)begin
        reg2_o <=`ZeroWord;
    end else if(reg2_re_o==1'b1)begin
        reg2_o <=reg2_i; //端口2的值
    end else if(reg2_re_o==1'b0)begin
        reg2_o <=imm; 
    end else begin
        reg2_o <=`ZeroWord;
    end
end







endmodule