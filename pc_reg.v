`include "defines.v"

module pc_reg(

	input wire				    clk,
	input wire				    rst,
	
	input wire 					branch_flag_i,            // 
	input wire[`InstAddrBus]	branch_target_address_i,  // 
	input wire					stall,

	output reg[`InstAddrBus]	pc,                         //
	output wire[`InstAddrBus]   pc_three,                  //
	output reg                  ce                       // inst memory enable
	
    );
	
	wire [31:0] pc_ds;  // delay slot
    assign pc_ds = pc + 32'h4;
	
	always @(posedge clk) begin
        if (rst == `RstDisable) pc <= 32'hbfc00000;
        else pc <= pc_ds;
    end
	
endmodule