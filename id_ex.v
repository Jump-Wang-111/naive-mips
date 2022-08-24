`include "defines.v"

module id_ex(

	input wire						clk,
	input wire						rst,

	
	//从译码阶段传递的信息
	input wire[`AluOpBus]         	id_aluop,		//运算的类�?
	input wire[`AluSelBus]        	id_alusel,		//运算的子类型
	input wire[`RegBus]           	id_reg1,		
	input wire[`RegBus]           	id_reg2,
	input wire[`RegAddrBus]       	id_wd,
	input wire[`WriteBus]           id_wreg,
	input wire[`RegBus]				id_return_addr,	
	input wire[`RegBus]				id_inst,
	input wire[`InstAddrBus]	    id_pc,
	

	
	//传�?�到执行阶段的信�?
	output reg[`AluOpBus]         	ex_aluop,
	output reg[`AluSelBus]        	ex_alusel,
	output reg[`RegBus]           	ex_reg1,
	output reg[`RegBus]           	ex_reg2,
	output reg[`RegAddrBus]       	ex_wd,
	output reg[`WriteBus]           ex_wreg,
	output reg[`RegBus]				ex_return_addr,
	output reg[`RegBus]				ex_inst,
	output reg[`RegBus]				ex_pc
);

endmodule