
`include "defines.v"

module if_id(

	input  wire                     clk,
	input  wire                     rst,
	
	input  wire [`InstAddrBus]      if_pc,
	input  wire [`InstBus]          if_inst,
	input  wire                     stall,
	input  wire                     stall_aluop,
    
	output wire  [`InstAddrBus]     id_pc,
	output reg   [`InstBus]         id_inst
	
    );
   
    assign id_pc    = if_pc;
	always @(posedge clk) begin
        if(rst == `RstDisable) begin
            // id_pc   <= `InitialPc;
            id_inst <= `ZeroWord;
        end
        else begin
            // id_pc   <= if_pc;
            id_inst <= if_inst
        end
    end

endmodule