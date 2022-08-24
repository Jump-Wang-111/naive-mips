
`include "defines.v"

module if_id(

	input wire			      	  clk,
	input wire					  rst,
	

	input wire[`InstAddrBus]	  if_pc,    // 取指阶段取得的指令对应的地址 32bit
	input wire[`InstBus]          if_inst,  // 取指阶段取得的指�? 32bit
	input wire					  stall,
	input wire   				  stall_aluop,
	output reg[`InstAddrBus]      id_pc,    // 译码阶段的指令对应的地址 32bit
	output reg[`InstBus]          id_inst   // 译码阶段的指�? 32bit
	
);

	

endmodule