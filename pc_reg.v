`include "defines.v"

module pc_reg(

	input wire				    clk,
	input wire				    rst,
	
	input wire 					branch_flag_i,            // 是否要跳�????
	input wire[`InstAddrBus]	branch_target_address_i,  // 跳转到的地址
	input wire					stall,

	output reg[`InstAddrBus]	pc,     // 输出要读取的指令地址 32bit
	output wire[`InstAddrBus]   pc_three, //高三位抹�??
	output reg                  ce      // 指令存储器使能信�????
	
);
	
endmodule