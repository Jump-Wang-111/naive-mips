`include "defines.v"

module ex(

	input wire						rst,
	
	// 输入ex阶段的信号
	input wire[`AluOpBus]         	aluop_i,		// ex阶段指令运算子类型
	input wire[`AluSelBus]        	alusel_i,		// ex阶段指令运算类型
	input wire[`RegBus]           	reg1_i,         // 第1个操作数
	input wire[`RegBus]           	reg2_i,         // 第2个操作数
	input wire[`RegAddrBus]       	wd_i,			// 写目的寄存器号
	input wire[`WriteBus]           wreg_i,			// 写目的寄存器使能
	input wire[`RegBus] 			return_addr_i,  // 返回地址
	input wire[`RegBus]				inst_i,         // ex阶段的指令
	input wire[`InstAddrBus]		pc_i,           // ex阶段指令的pc
	
	// 从ex阶段输出的信号
	output reg[`RegAddrBus]         wd_o,          // ex阶段写目的寄存器号
	output reg[`WriteBus]           wreg_o,        // ex阶段指令写寄存器使能
	output reg[`RegBus]			    wdata_o,	   // ex阶段指令写入目的寄存器数据

	output reg[`AluOpBus]			aluop_o,       // ex??????????????????
	output reg[`RegBus]			    mem_addr_o,    // ???address
	output reg[`RegBus]			    reg2_o,        // ex??ε?2????????

	output wire[`InstAddrBus]		pc_o,          // ex??????pc
	output reg 						stallreq       // ex??????????????????
	
);
	assign pc_o = pc_i;
	always @(*) begin

		if(rst == `RstDisable) begin
			wd_o 		<= `ZeroRegAddr;
			wreg_o 		<= `WriteDisable;
			wdata_o 	<= `ZeroWord;
			aluop_o 	<= `ALU_OP_NOP;
			mem_addr_o 	<= `ZeroWord;
			reg2_o 		<= `ZeroWord;
			stallreq 	<= `NoStop;
		end
		else begin
			wd_o 		<= wd_i;
			wreg_o 		<= wreg_i;
			wdata_o 	<= `ZeroWord;
			aluop_o 	<= aluop_i;
			mem_addr_o 	<= `ZeroWord;
			reg2_o 		<= reg2_i;
			stallreq 	<= `NoStop;

			case(aluop_i)
				`ALU_OP_ORI :	begin
					wdata_o <= reg1_i | reg2_i;
				end
				`ALU_OP_ANDI :	begin
					wdata_o <= reg1_i & reg2_i;
				end
				`ALU_OP_XORI :	begin
					wdata_o <= reg1_i ^ reg2_i;
				end
				`ALU_OP_LUI :	begin

				end
				`ALU_OP_ADDI :	begin

				end
				`ALU_OP_ADDIU :	begin

				end
				`ALU_OP_SLTI :	begin

				end
				`ALU_OP_SLTIU :	begin

				end
				`ALU_OP_J :	begin

				end
				`ALU_OP_JAL :	begin

				end
				`ALU_OP_BEQ :	begin
					
				end
				`ALU_OP_B :	begin

				end
				`ALU_OP_BGTZ :	begin

				end
				`ALU_OP_BLEZ :	begin

				end
				`ALU_OP_BNE :	begin

				end
				`ALU_OP_BLTZ :	begin
					
				end
				`ALU_OP_BLTZAL :	begin

				end
				`ALU_OP_BGEZ :	begin

				end
				`ALU_OP_BGEZAL :	begin

				end
				`ALU_OP_BAL :	begin

				end
				`ALU_OP_LW :	begin

				end
				`ALU_OP_SW :	begin

				end
				`ALU_OP_LB :	begin

				end
				`ALU_OP_SB :	begin

				end
				`ALU_OP_LH :	begin

				end
				`ALU_OP_SH :	begin

			end
			`ALU_OP_AND : begin

				end
				`ALU_OP_NOR : begin

				end
				`ALU_OP_OR : begin

				end
				`ALU_OP_XOR : begin

				end
				`ALU_OP_SLL : begin

				end
				`ALU_OP_SLLV : begin

				end
				`ALU_OP_SRL : begin

				end
				`ALU_OP_SRLV : begin

				end
				`ALU_OP_SRA : begin

				end
				`ALU_OP_SRAV : begin

				end
				`ALU_OP_NOP : begin

				end
				`ALU_OP_SSNOP : begin

				end
				`ALU_OP_SYNC : begin

				end
				`ALU_OP_MOVN : begin

				end
				`ALU_OP_MOVZ : begin

				end
				`ALU_OP_ADD : begin

				end
				`ALU_OP_ADDU : begin

				end
				`ALU_OP_SUB : begin

				end
				`ALU_OP_SUBU : begin

				end
				`ALU_OP_SLT : begin

				end
				`ALU_OP_SLTU : begin

				end
				`ALU_OP_JR : begin

				end
				`ALU_OP_JALR : begin

				end
				default : begin

				end
			endcase
		end
	end
endmodule