`include "defines.v"

module ex(

	input wire						rst,
	
	//送到执行阶段的信�?
	input wire[`AluOpBus]         	aluop_i,		//运算的子类型
	input wire[`AluSelBus]        	alusel_i,		//运算的类�?
	input wire[`RegBus]           	reg1_i,
	input wire[`RegBus]           	reg2_i,
	input wire[`RegAddrBus]       	wd_i,			//目的寄存器地�?
	input wire[`WriteBus]           wreg_i,			//目的寄存器写使能
	input wire[`RegBus] 			return_addr_i,
	input wire[`RegBus]				inst_i,
	input wire[`InstAddrBus]		pc_i,
	
	output reg[`RegAddrBus]       	wd_o,
	output reg[`WriteBus]           wreg_o,
	output reg[`RegBus]				wdata_o,		//写入目的寄存器的数据

	output wire[`AluOpBus]			aluop_o,
	output wire[`RegBus]			mem_addr_o,
	output wire[`RegBus]			reg2_o,

	output wire[`InstAddrBus]		pc_o,
	output reg 						stallreq
	
);

endmodule