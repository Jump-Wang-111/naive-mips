`include "defines.v"

module ex(

	input wire						rst,
	
	// 输入ex阶段的信号
	input wire[`AluOpBus]         	aluop_i,		// ex阶段指令运算子类型
	input wire[`AluSelBus]        	alusel_i,		// ex阶段指令运算类型
	input wire[`RegBus]           	reg1_i,         // 第1个操作数
	input wire[`RegBus]           	reg2_i,         // 第2个操作数
	input wire[`RegAddrBus]       	wd_i,			// 写目的寄存器号
	input wire[`WriteBus]           wreg_i,			// 写目的寄存器使能
	input wire[`RegBus] 			return_addr_i,  // 返回地址
	input wire[`RegBus]				inst_i,         // ex阶段的指令
	input wire[`InstAddrBus]		pc_i,           // ex阶段指令的pc
	
	// 从ex阶段输出的信号
	output reg[`RegAddrBus]        wd_o,           // ex阶段写目的寄存器号
	output reg[`WriteBus]          wreg_o,         // ex阶段指令写寄存器使能
	output reg[`RegBus]			    wdata_o,	   // ex阶段指令写入目的寄存器数据

	output wire[`AluOpBus]			aluop_o,       // ex阶段指令运算种子类型
	output wire[`RegBus]			mem_addr_o,    // 访存address
	output wire[`RegBus]			reg2_o,        // ex阶段第2个操作数

	output wire[`InstAddrBus]		pc_o,          // ex阶段指令pc
	output reg 						stallreq       // ex阶段流水线暂停控制信号
	
);

endmodule