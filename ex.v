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
					wdata_o <= reg2_i << 16;
				end
				`ALU_OP_ADDI :	begin
					// overflow detect: ignore
					wdata_o <= reg1_i + reg2_i;
				end
				`ALU_OP_ADDIU :	begin
					wdata_o <= reg1_i + reg2_i;
				end
				`ALU_OP_SLTI :	begin
					// leave for little cute
				end
				`ALU_OP_SLTIU :	begin
					if(reg1_i < reg2_i) begin
						wdata_o <= 1;
					end
					else begin
						wdata_o <= 0;
					end
				end
				`ALU_OP_J :	begin

				end
				`ALU_OP_JAL :	begin
					wdata_o <= return_addr_i;
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
					// leave for little cute
				end
				`ALU_OP_BLTZAL :	begin
					wdata_o <= return_addr_i;
				end
				`ALU_OP_BGEZ :	begin

				end
				`ALU_OP_BGEZAL :	begin
					wdata_o <= return_addr_i;
				end
				`ALU_OP_BAL :	begin
					wdata_o <= return_addr_i;
				end
				`ALU_OP_LW :	begin
					mem_addr_o <= reg1_i + reg2_i;
				end
				`ALU_OP_SW :	begin
					mem_addr_o <= reg1_i + reg2_i;
				end
				`ALU_OP_LB :	begin
					mem_addr_o <= reg1_i + reg2_i;
				end
				`ALU_OP_SB :	begin
					mem_addr_o <= reg1_i;
				end
				`ALU_OP_LH :	begin
					// leave for little cute
				end
				`ALU_OP_SH :	begin
					mem_addr_o <= reg1_i;
			end
			`ALU_OP_AND : begin
				// leave for little cute
				end
				`ALU_OP_NOR : begin
					rd <= ~(reg1_o | reg2_o);
				end
				`ALU_OP_OR : begin
					rd <= reg1_o | reg2_o;
				end
				`ALU_OP_XOR : begin
					rd <= reg1_o ^ reg2_o;
				end
				`ALU_OP_SLL : begin
					wdata_o <= reg2_i << reg1_i[15:11];
				end
				`ALU_OP_SLLV : begin
					wdata_o <= reg2_i << reg1_i[4:0];
				end
				`ALU_OP_SRL : begin
					wdata_o <= reg2_i >> reg1_i[15:11];
				end
				`ALU_OP_SRLV : begin
					// leave for little cute
				end
				`ALU_OP_SRA : begin
					wdata_o <= ({32{reg2_i[31]}} << (6'd32 - {1'b0, reg1_i[15:11]})) | reg2_i >> reg1_i[15:11];
				end
				`ALU_OP_SRAV : begin
					wdata_o <= ({32{reg2_i[31]}} << (6'd32 - {1'b0, reg1_i[4:0]})) | reg2_i >> reg1_i[4:0];
				end
				`ALU_OP_NOP : begin

				end
				`ALU_OP_SSNOP : begin

				end
				`ALU_OP_SYNC : begin

				end
				`ALU_OP_MOVN : begin
					if(reg2_i != 0) begin
						wdata_o <= reg1_i;
					end
				end
				`ALU_OP_MOVZ : begin
					// leave for little cute
				end
				`ALU_OP_ADD : begin
					wdata_o <= reg1_i + reg2_i;
				end
				`ALU_OP_ADDU : begin
					wdata_o <= reg1_i + reg2_i;
				end
				`ALU_OP_SUB : begin
					wdata_o <= reg1_i - reg2_i;
				end
				`ALU_OP_SUBU : begin
					wdata_o <= reg1_i - reg2_i;
				end
				`ALU_OP_SLT : begin
					if(reg1_i[31] < reg2_i[31]) begin
						wdata_o <= 0;
					end
					else if(reg1_i[31] > reg2_i[31]) begin
						wdata_o <= 1;
					end
					else if(reg1_i[31] == 1'b0) begin
						if(reg1_i < reg2_i) begin
							wdata_o <= 1;
						end
						else begin
							wdata_o <= 0;
						end
					end
					else if(reg1_i[31] == 1'b1) begin
						if(reg1_i < reg2_i) begin
							wdata_o <= 0;
						end
						else begin
							wdata_o <= 1;
						end
					end
					
				end
				`ALU_OP_SLTU : begin
					if(reg1_i < reg2_i) begin
						wdata_o <= 1;
					end
					else begin
						wdata_o <= 0;
					end
				end
				`ALU_OP_JR : begin
				
				end
				`ALU_OP_JALR : begin
					wdata_o <= return_addr_i;
				end
				default : begin

				end
			endcase
		end
	end
endmodule