/////////////////////////////////////////////////////////////
// Module:  Mem
// File:    Mem.v
// Author:  Qilin FU
// Description:
//
//
//////////////////////////////////////////////////////////////
`include "Defines.v"

module Mem (
    input wire rst,
    input wire[`RegAddrBus] waddr_i,
    input wire[`RegBus] wdata_i,
    input wire we_i,


    input wire[`AluOpBus] aluop_i,
    input wire[`InstAddrBus] mem_addr_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] mem_data_i,

    output reg[`InstAddrBus] mem_addr_o,
    output wire mem_we_o,
    output reg [`DataTypeBus]datatype_sel_o,
    output reg [`RegBus]mem_data_o,
    output reg  mem_ce_o,


    output reg[`RegAddrBus] waddr_o,
    output reg[`RegBus] wdata_o,
    output reg we_o

);

wire [`RegBus] zero32;
reg  mem_we_reg;

assign mem_we_o=mem_we_reg;
assign zero32 =`ZeroWord;

always @(*) begin
    if (rst==`RstEnable) begin
        waddr_o <=`ZeroWord;
        wdata_o <=`ZeroWord;
        we_o <=`WriteDisable;
        mem_addr_o <=`ZeroWord;
        mem_we_reg <=`WriteDisable;
        datatype_sel_o<=4'b0000;
        mem_data_o<=`ZeroWord;
        mem_ce_o<=`ChipDisable;
    end else  begin
        waddr_o <=waddr_i;
        wdata_o <=wdata_i;
        we_o <=we_i;
        mem_addr_o <=`ZeroWord;
        mem_we_reg <=`WriteDisable;
        datatype_sel_o<=4'b1111;
        mem_data_o<=`ZeroWord;
        mem_ce_o<=`ChipDisable;
        case (aluop_i)
            `EXE_OP_LD_B:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;
                case (mem_addr_i[1:0])
                    2'b00:begin
                        wdata_o <={{24{mem_data_i[7]}},mem_data_i[7:0]};//小端
                        datatype_sel_o<=4'b0001; 

                    end
                    2'b01:begin
                        wdata_o <={{24{mem_data_i[15]}},mem_data_i[15:8]};//小端
                        datatype_sel_o<=4'b0010; 
                        
                    end
                    2'b10:begin
                        wdata_o <={{24{mem_data_i[23]}},mem_data_i[23:16]};//小端
                        datatype_sel_o<=4'b0100; 
                    end
                    2'b11:begin
                        wdata_o <={{24{mem_data_i[31]}},mem_data_i[31:24]};//小端
                        datatype_sel_o<=4'b1000; 
                    end
                    default: begin
                        wdata_o<=`ZeroWord;
                    end
                endcase

            end
            `EXE_OP_LD_BU:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;
                case (mem_addr_i[1:0])
                    2'b00:begin
                        wdata_o <={24'b0,mem_data_i[7:0]};//小端
                        datatype_sel_o<=4'b0001; 

                    end
                    2'b01:begin
                        wdata_o <={24'b0,mem_data_i[15:8]};//小端
                        datatype_sel_o<=4'b0010; 
                        
                    end
                    2'b10:begin
                        wdata_o <={24'b0,mem_data_i[23:16]};//小端
                        datatype_sel_o<=4'b0100; 
                    end
                    2'b11:begin
                        wdata_o <={24'b0,mem_data_i[31:24]};//小端
                        datatype_sel_o<=4'b1000; 
                    end
                    default: begin
                        wdata_o<=`ZeroWord;
                    end
                endcase
            end
            `EXE_OP_LD_H:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;
                case (mem_addr_i[1:0])
                    2'b00:begin
                        wdata_o <={{16{mem_data_i[15]}},mem_data_i[15:0]};//小端
                        datatype_sel_o<=4'b0011; 

                    end

                    2'b10:begin
                        wdata_o <={{16{mem_data_i[16]}},mem_data_i[31:16]};//小端
                        datatype_sel_o<=4'b1100; 
                    end

                    default: begin
                        wdata_o<=`ZeroWord;
                    end
                endcase            
            end
            `EXE_OP_LD_HU:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;
                case (mem_addr_i[1:0])
                    2'b00:begin
                        wdata_o <={16'b0,mem_data_i[15:0]};//小端
                        datatype_sel_o<=4'b0011; 

                    end

                    2'b10:begin
                        wdata_o <={16'b0,mem_data_i[31:16]};//小端
                        datatype_sel_o<=4'b1100; 
                    end

                    default: begin
                        wdata_o<=`ZeroWord;
                    end
                endcase
            end
            `EXE_OP_LD_W:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;              
                wdata_o <=mem_data_i;//小端
                datatype_sel_o<=4'b1111; 
            end
            `EXE_OP_ST_B:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;
                mem_we_reg<=`WriteEnable;
                mem_data_o<={reg1_i[7:0],reg1_i[7:0],reg1_i[7:0],reg1_i[7:0]};
                case (mem_addr_i[1:0])

                   2'b00:begin

                        datatype_sel_o<=4'b0001; 

                    end
                    2'b01:begin

                        datatype_sel_o<=4'b0010; 
                        
                    end
                    2'b10:begin

                        datatype_sel_o<=4'b0100; 
                    end
                    2'b11:begin

                        datatype_sel_o<=4'b1000; 
                    end
                    default: begin
                        datatype_sel_o <=4'b0000;
                    end
                endcase
            end
            `EXE_OP_ST_H:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;
                mem_we_reg<=`WriteEnable;
                mem_data_o<={reg1_i[15:0],reg1_i[15:0]};
                case (mem_addr_i[1:0])
                
                   2'b00:begin

                        datatype_sel_o<=4'b0011; 

                    end

                    
                    2'b10:begin

                        datatype_sel_o<=4'b1100; 
                    end

                    default: begin
                        datatype_sel_o <=4'b0000;
                    end
                endcase
            end
            `EXE_OP_ST_W:begin
                mem_addr_o<=mem_addr_i;
                mem_ce_o <=`ChipEnable;
                mem_we_reg<=`WriteEnable;
                mem_data_o<=reg1_i;
                datatype_sel_o <=4'b1111;
            end

            default:begin
                
            end 
        endcase
    end
end
endmodule