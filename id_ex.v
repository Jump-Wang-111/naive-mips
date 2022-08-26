`include "defines.v"

module id_ex(

	input wire						clk,
	input wire						rst,

	
	
	input wire[`AluOpBus]         	id_aluop,		
	input wire[`AluSelBus]        	id_alusel,		
	input wire[`RegBus]           	id_reg1,		
	input wire[`RegBus]           	id_reg2,
	input wire[`RegAddrBus]       	id_wd,
	input wire[`WriteBus]           id_wreg,
	input wire[`RegBus]				id_return_addr,	
	input wire[`RegBus]				id_inst,
	input wire[`InstAddrBus]	    id_pc,
	

	
	
	output reg[`AluOpBus]         	ex_aluop,
	output reg[`AluSelBus]        	ex_alusel,
	output reg[`RegBus]           	ex_reg1,
	output reg[`RegBus]           	ex_reg2,
	output reg[`RegAddrBus]       	ex_wd,
	output reg[`WriteBus]           ex_wreg,
	output reg[`RegBus]				ex_return_addr,
	output reg[`RegBus]				ex_inst,
	output wire[`RegBus]			ex_pc
);

	assign ex_pc = id_pc;

    always @(posedge clk) begin
        if(rst == `RstDisable) begin
            ex_aluop <= `ALU_OP_NOP;
	        ex_alusel <= `ALU_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `ZeroRegAddr;
            ex_wreg <= `WriteDisable;
            ex_return_addr <= `ZeroWord;
            ex_inst <= `ZeroWord;
        end else begin
            ex_aluop <= id_aluop;
	        ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
            ex_return_addr <= id_return_addr;
            ex_inst <= id_inst;
        end
    end

endmodule