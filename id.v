
`include "defines.v"

module id(

	input wire					  rst,
	input wire[`InstAddrBus]	  pc_i,         // id阶段指令对应的pc
	input wire[`InstBus]          inst_i,       // id阶段指令

	// ex阶段运算结果
	input wire					  ex_wreg_i,    // ex阶段指令是否写寄存器
	input wire[`RegBus]			  ex_wdata_i,   // ex阶段指令写寄存器数据
	input wire[`RegAddrBus]       ex_wd_i,      // ex阶段指令写寄存器号
	
	// mem阶段结果
	input wire					  mem_wreg_i,   // mem阶段指令是否写寄存器
	input wire[`RegBus]			  mem_wdata_i,  // mem阶段指令写寄存器数据
	input wire[`RegAddrBus]       mem_wd_i,     // mem阶段指令写寄存器号
	
	// 读到的regfile数据
	input wire[`RegBus]           reg1_data_i,  // 读regfile得到的第1个数据
	input wire[`RegBus]           reg2_data_i,  // 读regfile得到的第2个数据

	// 输出到regfile的读信号
	output reg                    reg1_read_o,  // regfile第1个读使能
	output reg                    reg2_read_o,  // regfile第2个读使能
	output reg[`RegAddrBus]       reg1_addr_o,  // regfile第1个读寄存器号
	output reg[`RegAddrBus]       reg2_addr_o, 	// regfile第2个读寄存器号
	
	// 输出到ex阶段的信号
	output reg[`AluOpBus]         aluop_o,      // id阶段指令要进行的运算子类
	output reg[`AluSelBus]        alusel_o,     // id阶段指令要进行的运算类型
	output reg[`RegBus]           reg1_o,       // id阶段指令要进行运算的操作数1
	output reg[`RegBus]           reg2_o,       // id阶段指令要进行运算的操作数2
	output reg[`RegAddrBus]       wd_o,         // id阶段指令要写入的目的寄存器号
	output reg[`WriteBus]         wreg_o,       // id阶段指令是否写入寄存器
/* 疑惑 */
	output reg[`RegBus] 		  return_addr_o, // 保存的返回地址

	// 输出到pc_reg模块的信号
	output reg                    branch_flag_o,          // 是否要跳转
	output reg[`InstAddrBus]	  branch_target_address_o,  // 跳转的pc值

	output wire[`RegBus]		  inst_o,
	output wire[`InstAddrBus]	  pc_o,
	output reg 			      	  stallreq
			
);

endmodule