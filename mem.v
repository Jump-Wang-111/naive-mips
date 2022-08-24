`include "defines.v"

module mem(

	input wire						rst,
	
	//来自执行阶段的信�???
	input wire[`RegAddrBus]       	wd_i,
	input wire[`RegBus]             wreg_i,
	input wire[`RegBus]				wdata_i,
	
	input wire[`AluOpBus]			aluop_i,	//访存阶段的指令要进行的运算的子类�???
	input wire[`RegBus]				mem_addr_i,	//访存阶段的加载�?�存储指令对应的存储器地�???
	input wire[`RegBus]				reg2_i,		//访存阶段的存储指令要存储的数�???
	input wire[`InstAddrBus]		pc_i,
	
	//送到写回阶段的信�???
	output reg[`RegAddrBus]     	wd_o,
	output reg[`RegBus]             wreg_o,
	output reg[`RegBus]				wdata_o,

	output reg[`RegBus]				mem_addr_o,	//要访问的数据存储器的地址
	output reg[3:0]					mem_we_o,	//是否写操�???
	output reg[`RegBus]				mem_data_o, //要写入数据存储器的数�???
	output reg						mem_ce_o,	//数据存储器使能信�???
	output wire[`InstAddrBus]		pc_o,
	output wire[`AluOpBus]			aluop_o,
	output reg 						stallreq

);

endmodule