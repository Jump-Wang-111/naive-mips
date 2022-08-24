
`include "defines.v"

module regfile(

	input wire				 	  clk,
	input wire					  rst,
	
	//写端�?
		//扩充为两位，00表示不写�?01表示来自写回缓冲器，10表示来自数据存储�?
	input wire[`WriteBus]		  we,       // 写使能信�?
	input wire[`RegAddrBus]		  waddr,    // 写寄存器的地�?  5bit
		//来自写回缓冲器的数据
	input wire[`RegBus]			  wdata,    // 写寄存器的数�?  32bit
		//来自数据存储器的数据
	input wire[`RegBus]			  wdata_from_ram,


	//读端�?1
	input wire					  re1,      // 读使能信�?1
	input wire[`RegAddrBus]		  raddr1,   // 读寄存器的地�?1
	output reg[`RegBus]           rdata1,   // 读寄存器的数�?1
	
	//读端�?2
	input wire					  re2,
	input wire[`RegAddrBus]		  raddr2,
	output reg[`RegBus]           rdata2
	
);

endmodule
