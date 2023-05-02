/////////////////////////////////////////////////////////////
// Module:  Ram
// File:    Ram.v
// Author:  Qilin FU
// Description:
//
//
////////////////////////////////////////////////////////////



`include "defines.v"

module data_ram(

	input	wire										clk,
	input wire										ce_i,
	input wire										we_i,
input wire[`DataAddrBus]			addr_i,
	input wire[3:0]								datatype_sel_i,
	input wire[`DataBus]						data_i,
	output reg[`DataBus]					data_o
	
);

	reg[`ByteWidth]  data_mem0[0:`DataMemNum-1];
	reg[`ByteWidth]  data_mem1[0:`DataMemNum-1];
	reg[`ByteWidth]  data_mem2[0:`DataMemNum-1];
	reg[`ByteWidth]  data_mem3[0:`DataMemNum-1];

	always @ (posedge clk) begin
		if (ce_i == `ChipDisable) begin
			//data_o <= ZeroWord;
		end else if(we_i == `WriteEnable) begin
			  if (datatype_sel_i[3] == 1'b1) begin
		      data_mem3[addr_i[`DataMemNumLog2+1:2]] <= data_i[31:24];
		    end
			  if (datatype_sel_i[2] == 1'b1) begin
		      data_mem2[addr_i[`DataMemNumLog2+1:2]] <= data_i[23:16];
		    end
		    if (datatype_sel_i[1] == 1'b1) begin
		      data_mem1[addr_i[`DataMemNumLog2+1:2]] <= data_i[15:8];
		    end
			  if (datatype_sel_i[0] == 1'b1) begin
		      data_mem0[addr_i[`DataMemNumLog2+1:2]] <= data_i[7:0];
		    end			   	    
		end
	end
	
	always @ (*) begin
		if (ce_i == `ChipDisable) begin
			data_o <= `ZeroWord;
	  end else if(we_i == `WriteDisable) begin
		    data_o <= {data_mem3[addr_i[`DataMemNumLog2+1:2]],
		               data_mem2[addr_i[`DataMemNumLog2+1:2]],
		               data_mem1[addr_i[`DataMemNumLog2+1:2]],
		               data_mem0[addr_i[`DataMemNumLog2+1:2]]};
		end else begin
				data_o <= `ZeroWord;
		end
	end		

endmodule