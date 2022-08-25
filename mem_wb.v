`include "defines.v"

module mem_wb(

	input wire						clk,
	input wire						rst,
	
	
	input wire[`RegAddrBus]       	mem_wd,
	input wire[`WriteBus]           mem_wreg,
	input wire[`RegBus]				mem_wdata,
	input wire[`InstAddrBus]		mem_pc,
	input wire[`AluOpBus]			mem_aluop,


	output reg[`RegAddrBus]      	wb_wd,
	output reg[`WriteBus]           wb_wreg,
	output reg[`RegBus]				wb_wdata,
	output reg[`InstAddrBus]		wb_pc,
	output reg[`AluOpBus]			wb_aluop_stall    
	
);
    
    always @(posedge) begin
        if(rst == `RstDisable) begin
        
        end else begin
        
        end
    end

endmodule