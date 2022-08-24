`include "defines.v"

module ex_mem(

	input wire						clk,
	input wire						rst,
	
	
	//来自执行阶段的信�?
	input wire[`RegAddrBus]       	ex_wd,
	input wire[`WriteBus]           ex_wreg,
	input wire[`RegBus]				ex_wdata, 	

	input wire[`AluOpBus]			ex_aluop,
	input wire[`RegBus]				ex_mem_addr,
	input wire[`RegBus]				ex_reg2,
	input wire[`InstAddrBus]		ex_pc,

	//送到访存阶段的信�?
	output reg[`RegAddrBus]      	mem_wd,
	output reg[`WriteBus]           mem_wreg,
	output reg[`RegBus]				mem_wdata,

	output reg[`AluOpBus]			mem_aluop,
	output reg[`RegBus]				mem_mem_addr,
	output reg[`RegBus]				mem_reg2,
	output reg[`InstAddrBus]		mem_pc
	
	
);

endmodule