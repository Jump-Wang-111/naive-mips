
`include "defines.v"

module regfile(

	input wire				 	  clk,
	input wire					  rst,
	
	
	input wire[`WriteBus]		  we,       
	input wire[`RegAddrBus]		  waddr,    
		
	input wire[`RegBus]			  wdata,    
		
//	input wire[`RegBus]			  wdata_from_ram,
	
	input wire					  re1,      
	input wire[`RegAddrBus]		  raddr1,   
	output reg[`RegBus]           rdata1,   
	
	
	input wire					  re2,
	input wire[`RegAddrBus]		  raddr2,
	output reg[`RegBus]           rdata2
	
);
    reg [`RegBus] regs[`RegNum:0];
    
    integer i;
    always @(posedge clk) begin
        if(rst == `RstDisable) begin
            for(i = 0; i < `RegNum; i = i + 1) regs[i] <= `ZeroWord;
        end
        else begin
            if(we == `WriteEnable && waddr != 0) regs[waddr] <= wdata;
        end
    end
    
    always @(*) begin
        if(rst == `RstDisable) begin
            rdata1 <= `ZeroWord;
        end
        else if(raddr1 == 0) begin
            rdata1 <= `ZeroWord;
        end
        else if(raddr1 == waddr && we == `WriteEnable && re1 == `ReadEnable) begin
            rdata1 <= wdata;
        end
        else if(re1 == `ReadEnable) begin
            rdata1 <= regs[raddr1];
        end
        else begin
            rdata1 <= `ZeroWord;
        end
    end
    
    always @(*) begin
        if(rst == `RstDisable) begin
            rdata2 <= `ZeroWord;
        end
        else if(raddr2 == 0) begin
            rdata2 <= `ZeroWord;
        end
        else if(raddr2 == waddr && we == `WriteEnable && re2 == `ReadEnable) begin
            rdata2 <= wdata;
        end
        else if(re2 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
        end
        else begin
            rdata2 <= `ZeroWord;
        end
    end
    
endmodule
