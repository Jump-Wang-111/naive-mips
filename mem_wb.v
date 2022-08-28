`include "defines.v"

module mem_wb(

	input wire						clk,
	input wire						rst,
	
	
	input wire[`RegAddrBus]       	mem_wd,
	input wire[`WriteBus]           mem_wreg,
	input wire[`RegBus]				mem_wdata,
	input wire[`InstAddrBus]		mem_pc,
	input wire[`AluOpBus]			mem_aluop,
	input wire[`StopBus]            stall,


	output reg[`RegAddrBus]      	wb_wd,
	output reg[`WriteBus]           wb_wreg,
	output reg[`RegBus]				wb_wdata,
	output reg[`InstAddrBus]		wb_pc,
	output reg[`AluOpBus]			wb_aluop    
	
);
    
//    assign wb_pc = mem_pc;

    always @(posedge clk) begin
        if(rst == `RstDisable) begin
            wb_wd       <= `ZeroRegAddr;
            wb_wreg     <= `WriteDisable;
            wb_wdata    <= `ZeroWord;
            wb_pc       <= `InitialPc;
            wb_aluop    <= `ALU_OP_NOP;
        end 
        else if(stall[4] == `Stop && stall[5] == `NoStop) begin
            wb_wd       <= `ZeroRegAddr;
            wb_wreg     <= `WriteDisable;
            wb_wdata    <= `ZeroWord;
            wb_pc       <= `InitialPc;
            wb_aluop    <= `ALU_OP_NOP;
        end 
        else if(stall[4] == `NoStop) begin
            wb_wd       <= mem_wd;
            wb_wreg     <= mem_wreg;
            wb_wdata    <= mem_wdata;
            wb_pc       <= mem_pc;
            wb_aluop    <= mem_aluop;
        end
    end

endmodule