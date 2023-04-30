/////////////////////////////////////////////////////////////
// Module:  Ex
// File:    Ex.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////
`include "Defines.v"

module Ex (
    input wire rst,
    // signal from id
    input wire[`AluSelBus] alusel_i,
    input wire[`AluOpBus] aluop_i,
    input wire [`RegBus] reg1_i,
    input wire [`RegBus] reg2_i,
    input wire [`RegAddrBus] waddr_i,
    input wire we_i,


    // result out
    output reg we_o,
    output reg[`RegAddrBus] waddr_o,
    output reg[`RegBus] wdata_o,
    

    //stall

    output reg stallreq_o,

    // //diverse
    // output reg[`RegBus]div_opdata1_o,
    // output reg[`RegBus]div_opdata2_o,
    // output reg signed_div_o,
    // output reg cancel_o,
    // output reg start_o,

    // input wire[`DoubleRegBus] div_result_i,
    // input wire div_ready_i

    //branch

    input wire is_in_delayslot_i,
    input wire[`InstAddrBus] link_addr_i

 );
reg[`RegBus] logicout ;
reg[`RegBus] shiftout;
reg[`RegBus] arithmetic ;


// wire sum_over; //溢出情况
 //wire reg1_equal_reg2;//reg1是否等于reg2
 wire reg2_smallto_reg1; //reg1是否小reg2
 
 wire [`RegBus] sum_result ;//加法结果
 wire [`RegBus] mult_opdata1;//被乘数
 wire [`RegBus] mult_opdata2;//乘数
 wire [`RegBus] reg1_i_mux ;
 wire [`DoubleRegBus] mult_result_temp;//乘法临时结果64
 reg [`DoubleRegBus] mult_result_H;//乘法结果64高位
 reg [`DoubleRegBus] mult_result_L;//乘法结果64低位
//

reg stallreq_for_div;




//






assign reg1_i_mux=((aluop_i==`EXE_OP_SUB_W)||(aluop_i==`EXE_OP_SLT)) ? (~reg1_i+1):reg1_i;
assign sum_result =reg2_i+reg1_i_mux;
assign reg2_smallto_reg1 =((aluop_i==`EXE_OP_SLT)||(aluop_i==`EXE_OP_SLTI)) ? ((reg1_i[31]&&!reg2_i[31])||
                                                  (reg2_i[31]&&reg1_i[31]&&sum_result)||
                                                    (reg2_i[31]&&reg1_i[31]&&sum_result[31]))
                                                    :(reg2_i<reg1_i);
assign mult_opdata1 =(((aluop_i==`EXE_OP_MULH_W)||(aluop_i==`EXE_OP_MUL_W))
                        &&(reg1_i[31]==1'b1))
                        ?(~reg1_i+1) :reg1_i; 

assign mult_opdata2 =(((aluop_i==`EXE_OP_MULH_W)||(aluop_i==`EXE_OP_MUL_W))
                        &&(reg2_i[31]==1'b1))
                        ?(~reg2_i+1) :reg2_i; 
assign mult_result_temp =mult_opdata1 *mult_opdata2;

//对mult_result_temp 结果修正

always @(*) begin
    if (rst==`RstEnable) begin
        mult_result_H <={`ZeroWord,`ZeroWord};
    end else if((aluop_i ==`EXE_OP_MULH_W)&&(reg1_i[31]^reg2_i[31]==1'b1))begin
            mult_result_H <=~mult_result_temp+1;//有符号乘法
    end else if(aluop_i==`EXE_OP_MULH_WU)begin
            mult_result_H <=mult_result_temp;//无符号乘法符号拓展
    end else if(aluop_i ==`EXE_OP_MUL_W) begin
            mult_result_L <= ~mult_result_temp+1;//乘法低
    end 
end



    always @(*) begin
        if (rst==`RstEnable) begin
            logicout <=`ZeroWord;
        end 
        else begin
            case (aluop_i)
                `EXE_OP_ORI:begin
                    logicout <=reg1_i | reg2_i;
                end
                `EXE_OP_XORI:begin
                    logicout <=reg1_i ^ reg2_i;
                end
                `EXE_OP_ANDI:begin
                    logicout <=reg1_i & reg2_i;
                end
                `EXE_OP_NOR:begin
                    logicout <=~(reg1_i | reg2_i );
                end 
                `EXE_OP_AND:begin
                    logicout <=reg1_i & reg2_i;
                end
                `EXE_OP_OR:begin
                    logicout <=reg1_i | reg2_i ;
                end
                `EXE_OP_XOR:begin
                    logicout <=reg1_i ^ reg2_i;
                end
                default: begin
                    logicout <=`ZeroWord;
                end
            endcase
        end
    end
    always @(*) begin
        if (rst==`RstEnable) begin
            shiftout <=`ZeroWord;
        end 
        else begin
            case (aluop_i)
                `EXE_OP_SLL_W:begin
                    shiftout <= reg2_i <<reg1_i[4:0];
                end
                `EXE_OP_SRL_W:begin
                    shiftout <=reg2_i >>reg1_i[4:0];
                end
                `EXE_OP_SRA_W:begin
                    shiftout <= ({32{reg2_i[31]}})<<(6'd32-{1'b0,reg1_i[4:0]})|reg1_i >>reg1_i[4:0];              
                 end 
                 `EXE_OP_SLLI_W:begin
                    shiftout <=reg2_i <<reg1_i[4:0];
                 end
                 `EXE_OP_SRLI_W:begin
                    shiftout <=reg2_i <<reg1_i[4:0];
                 end
                 `EXE_OP_SRAI_W:begin
                    shiftout <=({32{reg2_i[31]}})<<(6'd32-{1'b0,reg1_i[4:0]})|reg1_i >>reg1_i[4:0]; 
                 end
                default:begin
                    
                end 
            endcase
        end 

    end

    always @(*) begin
        if (rst==`RstEnable) begin
            arithmetic <=`ZeroWord;
        end else begin
            case (aluop_i)
                `EXE_OP_ADD_W:begin
                 arithmetic <=sum_result;   
                end
                `EXE_OP_SUB_W:begin
                arithmetic <=sum_result;
                end 
                `EXE_OP_ADDI_W:begin
                arithmetic <=reg2_i+reg1_i;
                end
                `EXE_OP_SLT:begin
                arithmetic <=reg2_smallto_reg1;
                end
                `EXE_OP_SLTU:begin
                arithmetic <=reg2_smallto_reg1;  
                end
                `EXE_OP_SLTI:begin
                arithmetic <=reg2_smallto_reg1;     
                end
                `EXE_OP_SLTUI:begin
                arithmetic <=reg2_smallto_reg1;    
                end
                `EXE_OP_MUL_W:begin
                arithmetic <=mult_result_L[31:0];
                end
                `EXE_OP_MULH_W:begin
                arithmetic <=mult_result_H[63:32];
                end
                `EXE_OP_MULH_WU:begin
                arithmetic <=mult_result_H;
                end
                default: begin
                    
                end
            endcase
        end
    end


    // always @(*) begin
    //     if(rst==`RstEnable)begin
    //         stallreq_for_div <=`NotStop;
    //         div_opdata1_o<=`ZeroWord;
    //         div_opdata2_o<=`ZeroWord;
    //         start_o <=`DivStop;
    //         signed_div_o<=1'b0;
    //     end else begin
    //         stallreq_for_div <=`NotStop;
    //         div_opdata1_o<=`ZeroWord;
    //         div_opdata2_o<=`ZeroWord;
    //         start_o <=`DivStop;
    //         signed_div_o<=1'b0;
    //         case (aluop_i)
    //             `EXE_OP_DIV_W:begin
    //             if (div_ready_i==`DivResultNotReady) begin
    //                 div_opdata1_o <=reg2_i;//被除数
    //                 div_opdata2_o <=reg1_i;//除数
    //                 start_o <=`DivStart;//开始除法
    //                 signed_div_o <=1'b1;
    //                 stallreq_for_div <=`Stop;
    //             end else if(div_ready_i ==`DivResultReady) begin
    //                 div_opdata1_o <=reg2_i;//被除数
    //                 div_opdata2_o <=reg1_i;//除数
    //                 start_o <=`DivStop;//结束除法
    //                 signed_div_o <=1'b1;
    //                 stallreq_for_div <=`NotStop;
    //             end else begin
    //                 stallreq_for_div <=`NotStop;
    //                 div_opdata1_o<=`ZeroWord;
    //                 div_opdata2_o<=`ZeroWord;
    //                 start_o <=`DivStop;
    //                 signed_div_o<=1'b0;
    //             end
    //             end
    //             `EXE_OP_DIV_WU:begin
    //                 if (div_ready_i==`DivResultNotReady) begin
    //                 div_opdata1_o <=reg2_i;//被除数
    //                 div_opdata2_o <=reg1_i;//除数
    //                 start_o <=`DivStart;//开始除法
    //                 signed_div_o <=1'b0;
    //                 stallreq_for_div <=`Stop;
    //             end else if(div_ready_i ==`DivResultReady) begin
    //                 div_opdata1_o <=reg2_i;//被除数
    //                 div_opdata2_o <=reg1_i;//除数
    //                 start_o <=`DivStop;//结束除法
    //                 signed_div_o <=1'b0;
    //                 stallreq_for_div <=`NotStop;
    //             end else begin
    //                 stallreq_for_div <=`NotStop;
    //                 div_opdata1_o<=`ZeroWord;
    //                 div_opdata2_o<=`ZeroWord;
    //                 start_o <=`DivStop;
    //                 signed_div_o<=1'b0;
    //             end
    //             end 
    //             default:begin
                    
    //             end
    //         endcase 
    //     end
    // end



    // always @(*) begin//流水线暂停
    //     stallreq_o <=stallreq_for_div ;
    // end















    always @(*) begin
        waddr_o <=waddr_i;//写寄存器地址
        we_o <=we_i;//写使能
        case (alusel_i)
            `EXE_RESULT_LOGIC:begin //将逻辑运算的值作为输出结果
                wdata_o <=logicout;
            end
            `EXE_RESULT_SHIFT:begin
                wdata_o <=shiftout;
            end
            `EXE_RESULT_ARITHMETIC:begin
                wdata_o <=arithmetic;
            end
            `EXE_RESULT_BRANCH:begin
                wdata_o <=link_addr_i;
            end
            default:begin
                wdata_o <=`ZeroWord;//
            end 
        endcase
    end






endmodule