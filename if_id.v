
`include "defines.v"

module if_id(

	input  wire                     clk,
	input  wire                     rst,
	
	input  wire [`InstAddrBus]      if_pc,
	input  wire [`InstBus]          if_inst,
	input  wire [`StopBus]          stall,
//	input  wire                     stall_aluop,
    
	output reg  [`InstAddrBus]      id_pc,
	output wire  [`InstBus]         id_inst
	
    );
   
//    assign id_pc    = if_pc;
    assign id_inst  = if_inst;
	always @(posedge clk) begin
        if(rst == `RstDisable) begin
            id_pc   <= `InitialPc;
//            id_inst <= `ZeroWord;
        end
        else if(stall[1] == `Stop && stall[2] == `NoStop) begin
            id_pc   <= `InitialPc;
//            id_inst <= if_inst;
        end else if(stall[1] == `NoStop) begin
            id_pc   <= if_pc;
        end
    end

endmodule