
`include "defines.v"

module if_id(

	input  wire                     clk,
	input  wire                     rst,
	
	input  wire [`InstAddrBus]      if_pc,
	input  wire [`InstBus]          if_inst,
	input  wire                     stall,
	input  wire                     stall_aluop,
    
	output wire  [`InstAddrBus]     id_pc,
	output wire  [`InstBus]         id_inst
	
    );
    assign id_inst  = if_inst;
    assign id_pc    = if_pc;
	always @(posedge clk) begin
        if(rst == `RstDisable) begin
            // id_pc   <= `InitialPc;
        end
        else begin
            // id_pc   <= if_pc;
        end
    end

endmodule