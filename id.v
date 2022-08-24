
`include "defines.v"

module id(

	input wire					  rst,
	input wire[`InstAddrBus]	  pc_i,         // 译码阶段的指令对应的地址
	input wire[`InstBus]          inst_i,       // 译码阶段的指�??

	// 处于执行阶段的指令的运算结果
	input wire					  ex_wreg_i,    // 处于执行阶段的的指令是否要写目的寄存�???
	input wire[`RegBus]			  ex_wdata_i,   // 处于执行阶段的指令要写的目的寄存器的数据
	input wire[`RegAddrBus]       ex_wd_i,      // 处于执行阶段的指令要写入的目的寄存器的地�???
	
	// 处于访存阶段的指令的运算结果
	input wire					  mem_wreg_i,   // 处于访存阶段的指令是否要写目的寄存器
	input wire[`RegBus]			  mem_wdata_i,  // 处于访存阶段的指令要写的目的寄存器的数据
	input wire[`RegAddrBus]       mem_wd_i,     // 处于访存阶段的指令要写入的目的寄存器的地�???
	
	// 读取的regfile模块的�??
	input wire[`RegBus]           reg1_data_i,  // regfile模块输入的第�???????个读寄存器端口的输入
	input wire[`RegBus]           reg2_data_i,  // regfile模块输入的第二个读寄存器端口的输�???????

	// 输出到regfile模块的�??
	output reg                    reg1_read_o,  // regfile模块的第�???????个读寄存器端口的读使能信�???????
	output reg                    reg2_read_o,  // regfile模块的第二个读寄存器端口的读使能信号
	output reg[`RegAddrBus]       reg1_addr_o,  // regfile模块的第�???????个读寄存器端口的读地�???????信号 5bit
	output reg[`RegAddrBus]       reg2_addr_o, 	// regfile模块的第二个读寄存器端口的读地址信号 5bit
	
	// 输出到执行阶段的�???????
	output reg[`AluOpBus]         aluop_o,      // 译码阶段的指令要进行的运算的子类�??????? 8bit
	output reg[`AluSelBus]        alusel_o,     // 译码阶段的指令要进行的运算的类型 3bit
	output reg[`RegBus]           reg1_o,       // 译码阶段的指令要进行的运算的源操作数1 32bit
	output reg[`RegBus]           reg2_o,       // 译码阶段的指令要进行的运算的源操作数2 32bit
	output reg[`RegAddrBus]       wd_o,         // 译码阶段的指令要写入的目的寄存器的地�??????? 5bit
	output reg[`WriteBus]         wreg_o,       // 译码阶段的指令是否有要写入的目的寄存�??????? 
	output reg[`RegBus] 		  return_addr_o,  // �?????要保存的返回地址 

	// 输出到pc_reg模块的�??
	output reg                    branch_flag_o,          // 是否要跳�???????
	output reg[`InstAddrBus]	  branch_target_address_o,  // 跳转到的地址

	output wire[`RegBus]		  inst_o,
	output wire[`InstAddrBus]	  pc_o,
	output reg 			      	  stallreq
			
);

endmodule