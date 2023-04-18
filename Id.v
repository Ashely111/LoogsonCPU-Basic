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
    input wire[`RegBus] reg1_data_i,
    input wire[`RegBus] reg2_data_i,
    

    //output regfile values
    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`RegAddrBus] reg1_addr_o,
    output reg[`RegAddrBus] reg2_addr_o,
    output reg[`AluSelBus] alusel_o,
    output reg[`AluOpBus]   aluop_o,
    //transent to  id2ex
    output reg[`RegBus] reg1_data_o,
    output reg[`RegBus] reg2_data_o,
    output reg[`RegAddrBus] waddr_o,
    output reg reg_write_o

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
        reg1_addr_o <=`NOPRegAddr;
        reg2_addr_o <=`NOPRegAddr;
        reg1_read_o <=1'b0;
        reg2_read_o <=1'b0;
        imm <=`ZeroWord;
        instvalid <=`InstInvalid;
        reg_write_o <=`WriteDisable;
        waddr_o <=`NOPRegAddr;
        alusel_o <=`EXE_RESULT_NOP;
        aluop_o <=`EXE_OP_NOP;
    end else begin
        reg1_addr_o <=inst_i[`Reg1addr];
        reg2_addr_o <=inst_i[`Reg2addr];
        reg1_read_o <=1'b0;
        reg2_read_o <=1'b0;
        imm <=`ZeroWord;
        instvalid <=`InstInvalid;
        reg_write_o <=`WriteDisable;
        waddr_o <=`NOPRegAddr; 
        alusel_o <=`EXE_RESULT_NOP;
        aluop_o <=`EXE_OP_NOP;

        case (op_10)//第30位作为第一类指令特征码
            1'b1:begin
                
            end
            1'b0:begin
                case (op_20)//第29位作为第二类指令特征码
                    1'b1:begin
                        
                    end
                    1'b0:begin
                        case (op_30)//第28位作为第三类指令特征码
                            1'b1:begin
                                
                            end
                            1'b0:begin
                                case (op_60)//第25位作为第四类指令特征码
                                    1'b1:begin
                                        case (inst_i[24:22])
                                            `EXE_ORI:begin
                                                    reg1_read_o <=1'b0;
                                                    reg2_read_o <=1'b1;
                                                
                                                    imm<={20'b0,inst_i[21:10]};
                                                    reg_write_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_LOGIC;
                                                    aluop_o <=`EXE_OP_ORI;
                                                    instvalid <=`InstValid;
                                            end
                                            default:begin
                                                
                                            end
                                        endcase
                                    end
                                    1'b0:begin
                                        case (op_90)//第22位作为第五类指令特征码
                                            1'b1:begin
                                                
                                            end
                                            1'b0:begin
                                                case (op_A0)//第21位作为第六类指令特征码
                                                    1'b1:begin
                                                        
                                                    end
                                                    1'b0:begin
                                                       case (op_B0)//第20位作为第七类指令特征码
                                                            1'b1:begin
                                                                
                                                            end
                                                           // 1'b0:
                                                        default:begin
                                                            
                                                        end
                                                       endcase 
                                                    end







                                                    default: begin
                                                        
                                                    end
                                                endcase
                                            end 







                                            default:begin
                                                
                                            end
                                        endcase
                                    end











                                    default:begin
                                        
                                    end 
                                endcase
                            end












                            default:begin
                                
                            end 
                        endcase
                    end











                    default:begin
                        
                    end 
                endcase  
            end









            
            default:begin
                
            end 
        endcase



    end
end
//确定第1个源操作数
always @(*) begin
    if(rst==`RstEnable)begin
        reg1_data_o <=`ZeroWord;//端口1的值
    end else if(reg1_read_o==1'b1)begin
        reg1_data_o <=reg1_data_i;
    end else if(reg1_read_o==1'b0)begin
        reg1_data_o <=imm; 
    end else begin
        reg1_data_o <=`ZeroWord;
    end
end
//确定第2个源操作数
always @(*) begin
    if(rst==`RstEnable)begin
        reg2_data_o <=`ZeroWord;
    end else if(reg2_read_o==1'b1)begin
        reg2_data_o <=reg2_data_i; //端口2的值
    end else if(reg2_read_o==1'b0)begin
        reg2_data_o <=imm; 
    end else begin
        reg2_data_o <=`ZeroWord;
    end
end







endmodule