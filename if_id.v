
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
//    assign id_inst  = if_inst;
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
    
    reg [5:0] stall_lock;
    reg [31:0] inst_lock;
    
    always @(posedge clk) begin
        if(rst == `RstDisable) begin
            stall_lock <= 6'b000000;
            inst_lock  <= `ZeroWord;
        end
        else begin
            stall_lock <= stall;
            inst_lock <= if_inst;
        end
    end
    
    assign id_inst = (stall_lock[1] == `Stop) ? inst_lock : if_inst;

endmodule