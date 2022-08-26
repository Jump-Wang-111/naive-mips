
`include "defines.v"

module id(

	input wire					  rst,
	input wire[`InstAddrBus]	  pc_i,         // id�׶�ָ���Ӧ��pc
	input wire[`InstBus]          inst_i,       // id�׶�ָ��

	// ex�׶�������
	input wire					  ex_wreg_i,    // ex�׶�ָ���Ƿ�д�Ĵ���
	input wire[`RegBus]			  ex_wdata_i,   // ex�׶�ָ��д�Ĵ�������
	input wire[`RegAddrBus]       ex_wd_i,      // ex�׶�ָ��д�Ĵ�����
	
	// mem�׶ν��
	input wire					  mem_wreg_i,   // mem�׶�ָ���Ƿ�д�Ĵ���
	input wire[`RegBus]			  mem_wdata_i,  // mem�׶�ָ��д�Ĵ�������
	input wire[`RegAddrBus]       mem_wd_i,     // mem�׶�ָ��д�Ĵ�����
	
	// ������regfile����
	input wire[`RegBus]           reg1_data_i,  // ��regfile�õ��ĵ�1������
	input wire[`RegBus]           reg2_data_i,  // ��regfile�õ��ĵ�2������

	// �����regfile�Ķ��ź�
	output reg                    reg1_read_o,  // regfile��1����ʹ��
	output reg                    reg2_read_o,  // regfile��2����ʹ��
	output reg[`RegAddrBus]       reg1_addr_o,  // regfile��1�����Ĵ�����
	output reg[`RegAddrBus]       reg2_addr_o, 	// regfile��2�����Ĵ�����
	
	// �����ex�׶ε��ź�
	output reg[`AluOpBus]         aluop_o,      // id�׶�ָ��Ҫ���е���������
	output reg[`AluSelBus]        alusel_o,     // id�׶�ָ��Ҫ���е���������
	output reg[`RegBus]           reg1_o,       // id�׶�ָ��Ҫ��������Ĳ�����1
	output reg[`RegBus]           reg2_o,       // id�׶�ָ��Ҫ��������Ĳ�����2
	output reg[`RegAddrBus]       wd_o,         // id�׶�ָ��Ҫд���Ŀ�ļĴ�����
	output reg[`WriteBus]         wreg_o,       // id�׶�ָ���Ƿ�д��Ĵ���
/* �ɻ� */
	output reg[`RegBus] 		  return_addr_o, // ����ķ��ص�ַ

	// �����pc_regģ����ź�
	output reg                    branch_flag_o,           	// �Ƿ�Ҫ��ת
	output reg[`InstAddrBus]	  branch_target_address_o,  // ��ת��pcֵ

	output reg[`RegBus]		  	  inst_o,
	output wire[`InstAddrBus]	  pc_o,
	output reg 			      	  stallreq
			
);

	wire [5:0] opcode = inst_i[31:26];
	wire [4:0] rs = inst_i[25:21];
	wire [4:0] rt = inst_i[20:16];
	wire [4:0] rd = inst_i[15:11];
	wire [4:0] sa = inst_i[10:6];
	wire [5:0] func = inst_i[5:0];
	wire [15:0] imm16 = inst_i[15:0];
	wire [25:0] imm26 = inst_i[25:0];
	wire [31:0] imm16_signe = {{16{imm16[15]}}, imm16};
	wire [31:0] imm16_unsigne = {16'b0, imm16};
	wire [31:0] imm26_signe = {{6{imm16[25]}}, imm26};
	wire [31:0] imm26_unsigne = {6'b0, imm26};

	reg [1:0]		reg1_conflict_flag;
	reg [1:0]		reg2_conflict_flag;
	
	assign pc_o = pc_i;

	always @(*) begin
		if(rst == `RstDisable) begin
			reg1_read_o <= `ReadDisable;
			reg2_read_o <= `ReadDisable;
			reg1_addr_o <= `ZeroRegAddr;
			reg2_addr_o <= `ZeroRegAddr;
			aluop_o <= `ALU_OP_NOP;
			alusel_o <= `ALU_RES_NOP;
			reg1_o <= `ZeroWord;
			reg2_o <= `ZeroWord;
			wd_o <= `ZeroRegAddr;
			wreg_o <= `WriteDisable;
			return_addr_o <= `ZeroRegAddr;
			branch_flag_o <= `NotBranch;
			branch_target_address_o <= `InitialPc;
			inst_o <= `ZeroWord;
			stallreq <= `NoStop;
			reg1_conflict_flag <= `NoConflict;
			reg2_conflict_flag <= `NoConflict;
		end else begin

			if(reg1_read_o == `ReadEnable && ex_wreg_i == `WriteEnable && reg1_addr_o == ex_wd_i) begin
				reg1_conflict_flag <= `ExConflict;
			end
			else if(reg1_read_o == `ReadEnable && mem_wreg_i == `WriteEnable && reg1_addr_o == mem_wd_i) begin
				reg1_conflict_flag <= `MemConflict;
			end

			if(reg2_read_o == `ReadEnable && ex_wreg_i == `WriteEnable && reg2_addr_o == ex_wd_i) begin
				reg2_conflict_flag <= `ExConflict;
			end
			else if(reg2_read_o == `ReadEnable && mem_wreg_i == `WriteEnable && reg2_addr_o == mem_wd_i) begin
				reg2_conflict_flag <= `MemConflict;
			end

			reg1_read_o <= `ReadDisable;
			reg2_read_o <= `ReadDisable;
			reg1_addr_o <= `ZeroRegAddr;
			reg2_addr_o <= `ZeroRegAddr;
			aluop_o <= `ALU_OP_NOP;
			alusel_o <= `ALU_RES_NOP;
			reg1_o <= `ZeroWord;
			reg2_o <= `ZeroWord;
			wd_o <= `ZeroRegAddr;
			wreg_o <= `WriteDisable;
			/* */return_addr_o <= `ZeroRegAddr;
			/* */branch_flag_o <= `NotBranch;
			/* */branch_target_address_o <= `InitialPc;
			inst_o <= inst_i;
			stallreq <= `NoStop;
			case(opcode)
				`INST_ORI :	begin
					reg1_read_o <= `ReadEnable;
					// reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					// reg2_addr_o <= rt;
					aluop_o <= `ALU_OP_ORI;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_unsigne;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_ANDI :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= rt;
					aluop_o <= `ALU_OP_ANDI;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_unsigne;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_XORI :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= rt;
					aluop_o <= `ALU_OP_XORI;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_unsigne;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_LUI :	begin
					//reg1_read_o <= `ReadDisable;
					//reg2_read_o <= `ReadDisable;
					//reg1_addr_o <= `ZeroRegAddr;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_LUI;
					reg1_o <= `ZeroWord;
					reg2_o <= imm16_unsigne;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_ADDI :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_ADDI;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_ADDIU :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_ADDIU;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_SLTI :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_ADDI;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_SLTIU :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_ADDI;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_J :	begin
					//reg1_read_o <= `ReadDisable;
					//reg2_read_o <= `ReadDisable;
					//reg1_addr_o <= `ZeroRegAddr;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_J;
					//reg1_o <= `ZeroWord;
					//reg2_o <= `ZeroWord;
					//wd_o <= ZeroRegAddr;
					//wreg_o <= `WriteDisable;
				end
				`INST_JAL :	begin
					//reg1_read_o <= `ReadDisable;
					//reg2_read_o <= `ReadDisable;
					//reg1_addr_o <= `ZeroRegAddr;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_JAL;
					//reg1_o <= `ZeroWord;
					//reg2_o <= `ZeroWord;
					wd_o <= 31;
					wreg_o <= `WriteEnable;
				end
				`INST_BEQ_B :	begin
					if(rs == `RS_B && rt == `RT_B) begin
						//reg1_read_o <= `ReadDisable;
						//reg2_read_o <= `ReadDisable;
						//reg1_addr_o <= `ZeroRegAddr;
						//reg2_addr_o <= `ZeroRegAddr;
						aluop_o <= `ALU_OP_B;
						//reg1_o <= `ZeroWord;
						//reg2_o <= `ZeroWord;
						//wd_o <= ZeroRegAddr;
						//wreg_o <= `WriteDisable;
					end else begin // BEQ
						reg1_read_o <= `ReadEnable;
						reg2_read_o <= `ReadEnable;
						reg1_addr_o <= rs;
						reg2_addr_o <= rt;
						aluop_o <= `ALU_OP_BEQ;
						//reg1_o <= `ZeroWord;
						//reg2_o <= `ZeroWord;
						//wd_o <= ZeroRegAddr;
						//wreg_o <= `WriteDisable;
					end
				end
				`INST_BGTZ :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_BGTZ;
					//reg1_o <= `ZeroWord;
					//reg2_o <= `ZeroWord;
					//wd_o <= ZeroRegAddr;
					//wreg_o <= `WriteDisable;
				end
				`INST_BLEZ :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_BLEZ;
					//reg1_o <= `ZeroWord;
					//reg2_o <= `ZeroWord;
					//wd_o <= ZeroRegAddr;
					//wreg_o <= `WriteDisable;
				end
				`INST_BNE :	begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
					reg1_addr_o <= rs;
					reg2_addr_o <= rt;
					aluop_o <= `ALU_OP_BNE;
					//reg1_o <= `ZeroWord;
					//reg2_o <= `ZeroWord;
					//wd_o <= `ZeroRegAddr;
					//wreg_o <= `WriteDisable;
				end
				`INST_BLTZ_BLTZAL_BGEZ_BGEZAL_BAL :	begin
					if(rt == `RT_BLTZ) begin
						reg1_read_o <= `ReadEnable;
						//reg2_read_o <= `ReadDisable;
						reg1_addr_o <= rs;
						//reg2_addr_o <= `ZeroRegAddr;
						aluop_o <= `ALU_OP_BLTZ;
						//reg1_o <= `ZeroWord;
						//reg2_o <= `ZeroWord;
						//wd_o <= ZeroRegAddr;
						//wreg_o <= `WriteDisable;
					end else if(rt == `RT_BLTZAL) begin
						reg1_read_o <= `ReadEnable;
						//reg2_read_o <= `ReadDisable;
						reg1_addr_o <= rs;
						//reg2_addr_o <= `ZeroRegAddr;
						aluop_o <= `ALU_OP_BLTZAL;
						//reg1_o <= `ZeroWord;
						//reg2_o <= `ZeroWord;
						wd_o <= 31;
						wreg_o <= `WriteEnable;
					end else if (rt == `RT_BGEZ) begin
						reg1_read_o <= `ReadEnable;
						//reg2_read_o <= `ReadDisable;
						reg1_addr_o <= rs;
						//reg2_addr_o <= `ZeroRegAddr;
						aluop_o <= `ALU_OP_BGEZ;
						//reg1_o <= `ZeroWord;
						//reg2_o <= `ZeroWord;
						//wd_o <= ZeroRegAddr;
						//wreg_o <= `WriteDisable;
					end else begin // if (rt == `RT_BGEZAL_BAL) 
						if(rs == `RS_BAL) begin // BAL
							//reg1_read_o <= `ReadDisable;
							//reg2_read_o <= `ReadDisable;
							//reg1_addr_o <= `ZeroRegAddr;
							//reg2_addr_o <= `ZeroRegAddr;
							aluop_o <= `ALU_OP_BAL;
							//reg1_o <= `ZeroWord;
							//reg2_o <= `ZeroWord;
							wd_o <= 31;
							wreg_o <= `WriteEnable;
						end else begin // BGEZAL
							reg1_read_o <= `ReadEnable;
							//reg2_read_o <= `ReadDisable;
							reg1_addr_o <= rs;
							//reg2_addr_o <= `ZeroRegAddr;
							aluop_o <= `ALU_OP_BGEZAL;
							//reg1_o <= `ZeroWord;
							//reg2_o <= `ZeroWord;
							wd_o <= 31;
							wreg_o <= `WriteEnable;
						end
					end
				end
				`INST_LW :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_LW;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_SW :	begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
					reg1_addr_o <= rs;
					reg2_addr_o <= rt;
					aluop_o <= `ALU_OP_SW;
					reg1_o <= reg1_data_i + imm16_signe;
					reg2_o <= reg2_data_i;
					//wd_o <= `ZeroRegAddr;
					//wreg_o <= `WriteDisable;
				end
				`INST_LB :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_LB;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_SB :	begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
					reg1_addr_o <= rs;
					reg2_addr_o <= rt;
					aluop_o <= `ALU_OP_SB;
					reg1_o <= reg1_data_i + imm16_signe;
					reg2_o <= reg2_data_i;
					//wd_o <= `ZeroRegAddr;
					//wreg_o <= `WriteDisable;
				end
				`INST_LH :	begin
					reg1_read_o <= `ReadEnable;
					//reg2_read_o <= `ReadDisable;
					reg1_addr_o <= rs;
					//reg2_addr_o <= `ZeroRegAddr;
					aluop_o <= `ALU_OP_LH;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <= rt;
					wreg_o <= `WriteEnable;
				end
				`INST_SH :	begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
					reg1_addr_o <= rs;
					reg2_addr_o <= rt;
					aluop_o <= `ALU_OP_SH;
					reg1_o <= reg1_data_i + imm16_signe;
					reg2_o <= reg2_data_i;
					//wd_o <= `ZeroRegAddr;
					//wreg_o <= `WriteDisable;
				end
				`INST_SPECIAL : begin
					case (func) 
						`FUNC_AND : begin

						end
						`FUNC_NOR : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_NOR;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_OR : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_OR;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_XOR : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_XOR;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SLL : begin

						end
						`FUNC_SLLV : begin

						end
						`FUNC_SRL : begin

						end
						`FUNC_SRLV : begin

						end
						`FUNC_SRA : begin

						end
						`FUNC_SRAV : begin

						end
						`FUNC_NOP : begin

						end
						`FUNC_SSNOP : begin

						end
						`FUNC_SYNC : begin

						end
						`FUNC_MOVN : begin

						end
						`FUNC_MOVZ : begin

						end
						`FUNC_ADD : begin

						end
						`FUNC_ADDU : begin

						end
						`FUNC_SUB : begin

						end
						`FUNC_SUBU : begin

						end
						`FUNC_SLT : begin

						end
						`FUNC_SLTU : begin

						end
						`FUNC_JR : begin

						end
						`FUNC_JALR : begin

						end
						default : begin

						end
					endcase
				end
				default : begin

				end
			endcase

			if(reg1_conflict_flag == `ExConflict) begin
				reg1_o <= ex_wdata_i;
				reg1_conflict_flag <= `NoConflict;
			end
			else if(reg1_conflict_flag == `MemConflict) begin
				reg1_o <= mem_wdata_i;
				reg1_conflict_flag <= `NoConflict;
			end

			if(reg2_conflict_flag == `ExConflict) begin
				reg2_o <= ex_wdata_i;
				reg2_conflict_flag <= `NoConflict;
			end
			else if(reg2_conflict_flag == `MemConflict) begin
				reg2_o <= mem_wdata_i;
				reg2_conflict_flag <= `NoConflict;
			end
		end
	end

endmodule