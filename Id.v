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
    //data from Ex
    input wire Ex_we_i,
    input wire[`RegAddrBus] Ex_waddr_i,
    input wire[`RegBus] Ex_wdata_i,

    //data from Mem
    input wire[`RegAddrBus] Mem_waddr_i,
    input wire[`RegBus] Mem_wdata_i,
    input wire Mem_we_i, 


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
    output reg we_o,

    
    //stall
    output wire stallreq_o,

    //branch

    input wire is_in_delayslot_i,//当前指令是否处于延迟槽
    output reg branch_flag_o,//是否发生转移
    output reg [`InstAddrBus] branch_target_addr_o,//转移目标地址
    output reg is_in_delayslot_o,//当前指令是否处于延迟槽
    output reg[`InstAddrBus] link_addr_o,//转移指令要保存的返回地址
    output reg next_inst_in_delayslot_o//下条进入译码阶段指令是否位于延迟槽





);
wire op_10 = inst_i[30];// 第一类指令 
wire op_20= inst_i[29];// 第二类指令
wire op_30= inst_i[28];//第三类指令
wire op_60= inst_i[25];//第四类指令
wire op_90=inst_i[22];//第五类指令
wire op_A0= inst_i[21];//第六类指令
wire op_B0=inst_i[20];//第七类指令

wire [`InstAddrBus] Pc_plus_4 ;//Pc后一条指令地址
//
reg[`RegBus] imm;
//
reg instvalid;
//
assign stallreq_o = `NotStop;

assign Pc_plus_4 = pc_i +4;

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

            link_addr_o<=`ZeroWord;
            branch_flag_o<=`NotBranch;
            branch_target_addr_o<=`ZeroWord;
            next_inst_in_delayslot_o<=`NotInDelaySlot;
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

            link_addr_o<=`ZeroWord;
            branch_flag_o<=`NotBranch;
            branch_target_addr_o<=`ZeroWord;
            next_inst_in_delayslot_o<=`NotInDelaySlot;

            if (op_10==1'b1) begin//第30位作为第一类指令特征码          
                end else if (op_20==1'b1) begin//第29位作为第二类指令特征码  
                    case (inst_i[30:26])
                        `EXE_JIRL:begin
                            we_o <=`WriteEnable;
                            waddr_o <=inst_i[`Reg3addr];
                            aluop_o<=`EXE_OP_JIRL;
                            alusel_o <=`EXE_RESULT_BRANCH;
                            reg1_re_o <=1'b0;
                            reg2_re_o <=1'b1;
                            link_addr_o<=Pc_plus_4;
                            branch_flag_o <=`Branch;
                            branch_target_addr_o<={{14{inst_i[25]}},inst_i[25:10],2'b0}+reg2_i;
                            next_inst_in_delayslot_o<=`InDelaySlot;
                            instvalid<=`InstValid;
                            
                        end 
                        `EXE_B:begin
                            we_o <=`WriteDisable;
                            aluop_o<=`EXE_OP_B;
                            alusel_o <=`EXE_RESULT_BRANCH;
                            branch_target_addr_o<={{4{inst_i[25]}},inst_i[9:0],inst_i[25:10],2'b0}+pc_i;
                            link_addr_o<=`ZeroWord;
                            branch_flag_o <=`Branch;
                            next_inst_in_delayslot_o<=`InDelaySlot;
                            instvalid<=`InstValid;
                        end
                        `EXE_BL:begin
                            we_o<=`WriteEnable;
                            aluop_o<=`EXE_OP_BL;
                            alusel_o<=`EXE_RESULT_BRANCH;
                            waddr_o<=`Reg1;
                            link_addr_o<=Pc_plus_4;
                            branch_target_addr_o<={{4{inst_i[25]}},inst_i[9:0],inst_i[25:10],2'b0}+pc_i;
                            branch_flag_o <=`Branch;
                            next_inst_in_delayslot_o<=`InDelaySlot;
                            instvalid<=`InstValid;
                        end
                        `EXE_BEQ:begin
                            waddr_o<=`WriteDisable;
                            aluop_o<=`EXE_OP_BEQ;
                            alusel_o<=`EXE_RESULT_BRANCH;
                            reg1_re_o <=1'b1;
                            reg2_re_o <=1'b1;
                            raddr1_o<=inst_i[`Reg3addr];
                            link_addr_o<=`ZeroWord;
                            if (reg1_i==reg2_i) begin
                                branch_flag_o <=`Branch;
                                branch_flag_o <={branch_target_addr_o<={{14{inst_i[25]}},inst_i[25:10],2'b0}}+pc_i;
                           
                                next_inst_in_delayslot_o<=`InDelaySlot;
                            end
                            
                            instvalid<=`InstValid;
                        end
                        `EXE_BNE:begin
                            we_o<=`WriteDisable;
                            alusel_o<=`EXE_RESULT_BRANCH;
                            aluop_o<=`EXE_OP_BNE;
                            reg1_re_o <=1'b1;
                            reg2_re_o <=1'b1;
                            raddr1_o<=inst_i[`Reg3addr];
                            link_addr_o<=`ZeroWord;
                            if (reg1_i!=reg2_i) begin
                                branch_flag_o <=`Branch;
                                branch_target_addr_o<={branch_target_addr_o<={{14{inst_i[25]}},inst_i[25:10],2'b0}}+pc_i;
                                next_inst_in_delayslot_o<=`InDelaySlot;
                            end
                            
                            
                            instvalid<=`InstValid;
                        end
                        `EXE_BLT:begin
                            we_o<=`WriteDisable;
                            alusel_o<=`EXE_RESULT_BRANCH;
                            aluop_o<=`EXE_OP_BLT;
                            reg1_re_o <=1'b1;
                            reg2_re_o <=1'b1;
                            raddr1_o<=inst_i[`Reg3addr];
                            link_addr_o<=`ZeroWord;
                            if ((reg2_i[31]^reg1_i[31]&&reg2_i[31]==1)||(reg1_i[31]==reg2_i[31]&&reg2_i[31]==1'b1&&reg1_i[30:0]<reg2_i[30:0])||(reg1_i[31]==reg2_i[31]&&reg2_i[31]==1'b0&&reg1_i[30:0]>reg2_i[30:0])) begin
                                branch_flag_o <=`Branch;
                                branch_target_addr_o<={branch_target_addr_o<={{14{inst_i[25]}},inst_i[25:10],2'b0}}+pc_i;
                                next_inst_in_delayslot_o<=`InDelaySlot;
                            end
                            
                            instvalid<=`InstValid;
                        end
                        `EXE_BGE:begin
                            we_o<=`WriteDisable;
                            alusel_o<=`EXE_RESULT_BRANCH;
                            aluop_o<=`EXE_OP_BLT;
                            reg1_re_o <=1'b1;
                            reg2_re_o <=1'b1;
                            raddr1_o<=inst_i[`Reg3addr];
                            link_addr_o<=`ZeroWord;
                            if ((reg1_i[31]^reg2_i[31]&&reg1_i[31]==1)||(reg1_i[31]==reg2_i[31]&&reg1_i[31]==1'b1&&reg1_i[30:0]>reg2_i[30:0])||(reg1_i[31]==reg2_i[31]&&reg1_i[31]==1'b0&&reg1_i[30:0]<reg2_i[30:0])) begin
                                branch_flag_o <=`Branch;
                                branch_target_addr_o<={branch_target_addr_o<={{14{inst_i[25]}},inst_i[25:10],2'b0}}+pc_i;
                                next_inst_in_delayslot_o<=`InDelaySlot;
                            end
                            
                            instvalid<=`InstValid;
                        end
                        `EXE_BLTU:begin
                            we_o<=`WriteDisable;
                            alusel_o<=`EXE_RESULT_BRANCH;
                            aluop_o<=`EXE_OP_BLTU;
                            reg1_re_o <=1'b1;
                            reg2_re_o <=1'b1;
                            raddr1_o<=inst_i[`Reg3addr];
                            link_addr_o<=`ZeroWord;
                            if (reg1_i>reg2_i) begin
                                branch_flag_o <=`Branch;
                                branch_target_addr_o<={branch_target_addr_o<={{14{inst_i[25]}},inst_i[25:10],2'b0}}+pc_i;
                                next_inst_in_delayslot_o<=`InDelaySlot;
                            end
                        end
                        `EXE_BGEU:begin
                            we_o<=`WriteDisable;
                            alusel_o<=`EXE_RESULT_BRANCH;
                            aluop_o<=`EXE_OP_BGEU;
                            reg1_re_o <=1'b1;
                            reg2_re_o <=1'b1;
                            raddr1_o<=inst_i[`Reg3addr];
                            link_addr_o<=`ZeroWord;
                            if (reg1_i<reg2_i) begin
                                branch_flag_o <=`Branch;
                                branch_target_addr_o<={branch_target_addr_o<={{14{inst_i[25]}},inst_i[25:10],2'b0}}+pc_i;
                                next_inst_in_delayslot_o<=`InDelaySlot;
                            end
                        end
                        default:begin
                            
                        end 
                    endcase                   
                    end else if (op_30==1'b1) begin//第28位作为第三类指令特征码
                        case (inst_i[27:25])
                            `EXE_LU12I_W:begin
                                        reg1_re_o <=1'b1;
                                        reg2_re_o <=1'b0;
                                        raddr1_o <=`Reg0;                           
                                        imm<={inst_i[24:5],12'b0};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_LOGIC;
                                        aluop_o <=`EXE_OP_ORI;
                                        instvalid <=`InstValid;
                            end 
                            default:begin
                                
                            end 
                        endcase   
                        end else if (op_60==1'b1)begin//第25位作为第四类指令特征码
                            case (inst_i[24:22])
                                `EXE_ORI:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b0;                           
                                        imm<={20'b0,inst_i[21:10]};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_LOGIC;
                                        aluop_o <=`EXE_OP_ORI;
                                        instvalid <=`InstValid;
                                    end
                                `EXE_ANDI:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;                           
                                        imm<={20'b0,inst_i[21:10]};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_LOGIC;
                                        aluop_o <=`EXE_OP_ANDI;
                                        instvalid <=`InstValid;
                                end
                                `EXE_XORI:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;                           
                                        imm<={20'b0,inst_i[21:10]};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_LOGIC;
                                        aluop_o <=`EXE_OP_XORI;
                                        instvalid <=`InstValid;
                                end
                                `EXE_NOP:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;  
                                        raddr2_o <=`Reg0;                         
                                        imm<=`ZeroWord;
                                        we_o<=`WriteEnable;
                                        waddr_o <=`Reg0;
                                        alusel_o <=`EXE_RESULT_LOGIC;
                                        aluop_o <=`EXE_OP_ANDI;
                                        instvalid <=`InstValid;
                                end
                                `EXE_ADDI_W:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;  
                      
                                        imm<= {{30{inst_i[21]}},inst_i[21:10]};//有符号拓展
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_ARITHMETIC;
                                        aluop_o <=`EXE_OP_ADDI_W;
                                        instvalid <=`InstValid;
                                end
                                `EXE_SLTI:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;  
                      
                                        imm<= {{30{inst_i[21]}},inst_i[21:10]};//有符号拓展
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_ARITHMETIC;
                                        aluop_o <=`EXE_OP_SLTI;
                                        instvalid <=`InstValid;

                                end
                                `EXE_SLTUI:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;  
                      
                                        imm<= {{30{inst_i[21]}},inst_i[21:10]};//有符号拓展
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_ARITHMETIC;
                                        aluop_o <=`EXE_OP_SLTUI;
                                        instvalid <=`InstValid;

                                end
                                
                                 default:begin
                                                
                                 end 
                              
                            endcase                     
                            end else if (op_90==1'b1) begin//第22位作为第五类指令特征码
                                case (inst_i[19:15])
                                    `EXE_SLLI_W:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;                           
                                        imm<={27'b0,inst_i[`Reg1addr]};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_SHIFT;
                                        aluop_o <=`EXE_OP_SLLI_W;
                                        instvalid <=`InstValid;
       
                                    end
                                    `EXE_SRLI_W:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;                           
                                        imm<={27'b0,inst_i[`Reg1addr]};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_SHIFT;
                                        aluop_o <=`EXE_OP_SRLI_W;
                                        instvalid <=`InstValid;

                                    end
                                   `EXE_SRAI_W:begin
                                        reg1_re_o <=1'b0;
                                        reg2_re_o <=1'b1;                           
                                        imm<={27'b0,inst_i[`Reg1addr]};
                                        we_o<=`WriteEnable;
                                        waddr_o <=inst_i[`Reg3addr];
                                        alusel_o <=`EXE_RESULT_SHIFT;
                                        aluop_o <=`EXE_OP_SRAI_W;
                                        instvalid <=`InstValid;
                                   end 
                                    default: begin
                                        
                                    end
                                endcase
                            
                                end else if (op_A0==1'b1) begin//第21位作为第六类指令特征码
                                    case (inst_i[20:15])
                                        `EXE_DIV_W:begin
                                        reg1_re_o <=1'b1;
                                        reg2_re_o <=1'b1;
                                        alusel_o <=`EXE_RESULT_DIV ;
                                        we_o<=`WriteEnable;
                                        waddr_o<=inst_i[`Reg3addr];
                                        aluop_o <=`EXE_OP_DIV_W;
                                        instvalid <=`InstValid; 
                                        end
                                        `EXE_DIV_WU:begin
                                        reg1_re_o <=1'b1;
                                        reg2_re_o <=1'b1;
                                        we_o<=`WriteEnable;
                                        waddr_o<=inst_i[`Reg3addr];
                                        we_o<=`WriteDisable;
                                        aluop_o <=`EXE_OP_DIV_WU;
                                        instvalid <=`InstValid;   
                                        alusel_o<=`EXE_RESULT_DIV ; 
                                        end
                                        `EXE_MOD_W:begin
                                            
                                        end
                                        `EXE_MOD_WU:begin
                                            
                                        end
                                        default:begin
                                            
                                        end
                                    endcase
                                    end else if (op_B0==1'b1) begin//第20位作为第七类指令特征码
                                        case (inst_i[19:15])
                                            `EXE_NOR:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_LOGIC;
                                                    aluop_o <=`EXE_OP_NOR;
                                                    instvalid <=`InstValid;
                                            end
                                            `EXE_AND:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_LOGIC;
                                                    aluop_o <=`EXE_OP_AND;
                                                    instvalid <=`InstValid;
  
                                            end
                                            `EXE_OR:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_LOGIC;
                                                    aluop_o <=`EXE_OP_OR;
                                                    instvalid <=`InstValid;                                            
                                            end
                                            `EXE_XOR:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_LOGIC;
                                                    aluop_o <=`EXE_OP_XOR;
                                                    instvalid <=`InstValid;   
                                            end        
                                            `EXE_SLL_W:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_SHIFT;
                                                    aluop_o <=`EXE_OP_SLL_W;
                                                    instvalid <=`InstValid;   
                                            end
                                            `EXE_SRL_W:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_SHIFT;
                                                    aluop_o <=`EXE_OP_SRL_W;
                                                    instvalid <=`InstValid;     
                                            end 
                                            `EXE_SRA_W:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_SHIFT;
                                                    aluop_o <=`EXE_OP_SRA_W;
                                                    instvalid <=`InstValid;
                                            end
                                            `EXE_ADD_W:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_ARITHMETIC;
                                                    aluop_o <=`EXE_OP_ADD_W;
                                                    instvalid <=`InstValid; 
                                            end
                                            `EXE_SUB_W:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_ARITHMETIC;
                                                    aluop_o <=`EXE_OP_SUB_W;
                                                    instvalid <=`InstValid;   
                                            end
                                            `EXE_SLT:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_ARITHMETIC;
                                                    aluop_o <=`EXE_OP_SLT;
                                                    instvalid <=`InstValid; 
                                            end
                                            `EXE_SLTU:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_ARITHMETIC;
                                                    aluop_o <=`EXE_OP_SLTU;
                                                    instvalid <=`InstValid;  
                                            end
                                            `EXE_MUL_W:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_ARITHMETIC;
                                                    aluop_o <=`EXE_OP_MUL_W;
                                                    instvalid <=`InstValid;        
                                            end
                                            `EXE_MULH_W:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_ARITHMETIC;
                                                    aluop_o <=`EXE_OP_MULH_W;
                                                    instvalid <=`InstValid;  
                                            end
                                            `EXE_MULH_WU:begin
                                                    reg1_re_o <=1'b1;
                                                    reg2_re_o <=1'b1;                           
                                                    
                                                    we_o<=`WriteEnable;
                                                    waddr_o <=inst_i[`Reg3addr];
                                                    alusel_o <=`EXE_RESULT_ARITHMETIC;
                                                    aluop_o <=`EXE_OP_MULH_WU;
                                                    instvalid <=`InstValid;  
                                            end
                                            default:begin
                                                
                                            end 
                                        endcase
                                        end
        end

end





//确定第1个源操作数
always @(*) begin
    if(rst==`RstEnable)begin
        reg1_o <=`ZeroWord;//端口1的值
    end else if ((reg1_re_o==1'b1)&&(Ex_we_i==1'b1)&&(Ex_waddr_i==raddr1_o)) begin
        reg1_o <=Ex_wdata_i;
    end else if ((reg1_re_o==1'b1)&&(Mem_we_i==1'b1)&&(Mem_waddr_i==raddr1_o)) begin
        reg1_o <=Mem_wdata_i;
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
    end else if ((reg2_re_o==1'b1)&&(Ex_we_i==1'b1)&&(Ex_waddr_i==raddr2_o)) begin
        reg2_o <=Ex_wdata_i;
    end else if ((reg2_re_o==1'b1)&&(Mem_we_i==1'b1)&&(Mem_waddr_i==raddr2_o)) begin
        reg2_o <=Mem_wdata_i;
    end else if(reg2_re_o==1'b1)begin
        reg2_o <=reg2_i; //端口2的值
    end else if(reg2_re_o==1'b0)begin
        reg2_o <=imm; 
    end else begin
        reg2_o <=`ZeroWord;
    end
end

//输出变量is_in_delayslot_o表示当前是否是延迟槽指令

always @(*) begin
    if(rst==`RstEnable)begin
        is_in_delayslot_o<=`NotInDelaySlot;
    end else begin
        is_in_delayslot_o <=is_in_delayslot_i;
    end
end





endmodule