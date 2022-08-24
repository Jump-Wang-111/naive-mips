
`include "defines.v"

module regfile(

	input wire				 	  clk,
	input wire					  rst,
	
	
	input wire[`WriteBus]		  we,       
	input wire[`RegAddrBus]		  waddr,    
		
	input wire[`RegBus]			  wdata,    
		
	input wire[`RegBus]			  wdata_from_ram,


	
	input wire					  re1,      
	input wire[`RegAddrBus]		  raddr1,   
	output reg[`RegBus]           rdata1,   
	
	
	input wire					  re2,
	input wire[`RegAddrBus]		  raddr2,
	output reg[`RegBus]           rdata2
	
);

endmodule
