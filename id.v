
`include "defines.v"

module id(

	input wire					  rst,
	input wire[`InstAddrBus]	  pc_i,         // id??????????pc
	input wire[`InstBus]          inst_i,       // id??????

	// ex?????????
	input wire					  ex_wreg_i,    // ex?????????§Õ?????
	input wire[`RegBus]			  ex_wdata_i,   // ex??????§Õ?????????
	input wire[`RegAddrBus]       ex_wd_i,      // ex??????§Õ???????
	
	// mem??¦Í??
	input wire					  mem_wreg_i,   // mem?????????§Õ?????
	input wire[`RegBus]			  mem_wdata_i,  // mem??????§Õ?????????
	input wire[`RegAddrBus]       mem_wd_i,     // mem??????§Õ???????
	
	// ??????regfile????
	input wire[`RegBus]           reg1_data_i,  // ??regfile??????1??????
	input wire[`RegBus]           reg2_data_i,  // ??regfile??????2??????

	// ?????regfile??????
	output reg                    reg1_read_o,  // regfile??1???????
	output reg                    reg2_read_o,  // regfile??2???????
	output reg[`RegAddrBus]       reg1_addr_o,  // regfile??1???????????
	output reg[`RegAddrBus]       reg2_addr_o, 	// regfile??2???????????
	
	// ?????ex??¦Å????
	output reg[`AluOpBus]         aluop_o,      // id??????????§Ö?????????
	output reg[`AluSelBus]        alusel_o,     // id??????????§Ö?????????
	output reg[`RegBus]           reg1_o,       // id?????????????????????1
	output reg[`RegBus]           reg2_o,       // id?????????????????????2
	output reg[`RegAddrBus]       wd_o,         // id???????§Õ????????????
	output reg[`WriteBus]         wreg_o,       // id?????????§Õ??????
/* ??? */
	output reg[`RegBus] 		  return_addr_o, // ??????????

	// ?????pc_reg???????
	output reg                    branch_flag_o,           	// ???????
	output reg[`InstAddrBus]	  branch_target_address_o,  // ?????pc?

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
	wire [`InstAddrBus] pc_plus_4 = pc_i + 4;
	wire [`InstAddrBus] pc_plus_8 = pc_i + 8;
	wire [`RegBus]		imm_sll2_sign = {imm16_signe[29:0], 2'b00};

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
					aluop_o <= `ALU_OP_SLTI;
					reg1_o <= reg1_data_i;
					reg2_o <= imm16_signe;
					wd_o <=rt;
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
						    reg1_read_o <= `ReadEnable;
						    reg2_read_o <= `ReadEnable;
						    reg1_addr_o <= rs;
						    reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_AND;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
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
							//reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							// reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLL;
							reg1_o <= imm16_unsigne;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SLLV : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLLV;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SRL : begin
							// reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							// reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SRL;
							reg1_o <= imm16_unsigne;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SRLV : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SRLV;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SRA : begin
							// reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							// reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SRA;
							reg1_o <= imm16_unsigne;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SRAV : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLLV;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_NOP : begin
							//reg1_read_o <= `ReadEnable;
							//reg2_read_o <= `ReadEnable;
							//reg1_addr_o <= rs;
							//reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLL;
							// reg1_o <= reg1_data_i;
							// reg2_o <= reg2_data_i;
							// wd_o <= rd;
							// wreg_o <= `WriteEnable;
						end
						`FUNC_SSNOP : begin
							//reg1_read_o <= `ReadEnable;
							//reg2_read_o <= `ReadEnable;
							//reg1_addr_o <= rs;
							//reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLL;
							// reg1_o <= reg1_data_i;
							// reg2_o <= reg2_data_i;
							// wd_o <= rd;
							// wreg_o <= `WriteEnable;
						end
						`FUNC_SYNC : begin
							//reg1_read_o <= `ReadEnable;
							//reg2_read_o <= `ReadEnable;
							//reg1_addr_o <= rs;
							//reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLL;
							// reg1_o <= reg1_data_i;
							// reg2_o <= reg2_data_i;
							// wd_o <= rd;
							// wreg_o <= `WriteEnable;
						end
						`FUNC_MOVN : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_MOVN;
							if(reg2_data_i != 0) begin
								reg1_o <= reg1_data_i;
								reg2_o <= reg2_data_i;
								wd_o <= rd;
								wreg_o <= `WriteEnable;
							end
							
						end
						`FUNC_MOVZ : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_MOVZ;
							if(reg2_data_i == 0) begin
								reg1_o <= reg1_data_i;
								reg2_o <= reg2_data_i;
								wd_o <= rd;
								wreg_o <= `WriteEnable;
							end
						end
						`FUNC_ADD : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_ADD;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_ADDU : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_ADDU;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SUB : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SUB;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SUBU : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SUBU;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SLT : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLT;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_SLTU : begin
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_SLTU;
							reg1_o <= reg1_data_i;
							reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
						end
						`FUNC_JR : begin
							reg1_read_o <= `ReadEnable;
							// reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							// reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_JR;
							// reg1_o <= reg1_data_i;
							// reg2_o <= reg2_data_i;
							// wd_o <= rd;
							// wreg_o <= `WriteEnable;
						end
						`FUNC_JALR : begin
							reg1_read_o <= `ReadEnable;
							// reg2_read_o <= `ReadEnable;
							reg1_addr_o <= rs;
							// reg2_addr_o <= rt;
							aluop_o <= `ALU_OP_JALR;
							// reg1_o <= reg1_data_i;
							// reg2_o <= reg2_data_i;
							wd_o <= rd;
							wreg_o <= `WriteEnable;
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

	always @(*) begin
		if(rst == `RstDisable) begin
			return_addr_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			branch_target_address_o <= `InitialPc;
		end
		else begin
			return_addr_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			branch_target_address_o <= `InitialPc;
			case(opcode) 
				`INST_J :	begin
					// return_addr_o <= `ZeroWord;
					branch_flag_o <= `Branch;
					branch_target_address_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
				end
				`INST_JAL :	begin
					// return_addr_o <= `ZeroWord;
					branch_flag_o <= `Branch;
					branch_target_address_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
				end
				`INST_BEQ_B :	begin
					if(rs == `RS_B && rt == `RT_B) begin
						// return_addr_o <= `ZeroWord;
						branch_flag_o <= `Branch;
						branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
					end else begin // BEQ
						if(reg1_o == reg2_o) begin
							// return_addr_o <= `ZeroWord;
							branch_flag_o <= `Branch;
							branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
						end
					end
				end
				`INST_BGTZ :	begin
					if(reg1_o > 0) begin
						branch_flag_o <= `Branch;
						branch_target_address_o <= pc + imm_sll2_sign;
					end
				end
				`INST_BLEZ :	begin
					// return_addr_o <= `ZeroWord;
					if(reg1_o <= 0) begin
						branch_flag_o <= `Branch;
						branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
					end
				end
				`INST_BNE :	begin
					if(reg1_o != reg2_o) begin
						// return_addr_o <= `ZeroWord;
						branch_flag_o <= `Branch;
						branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
					end
				end
				`INST_BLTZ_BLTZAL_BGEZ_BGEZAL_BAL :	begin
					if(rt == `RT_BLTZ) begin
						if(reg1_o[31] == 1'b1) begin
							// return_addr_o <= `ZeroWord;
							branch_flag_o <= `Branch;
							branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
						end
					end else if(rt == `RT_BLTZAL) begin
						if(reg1_o[31] == 1'b1) begin
							return_addr_o <= pc_plus_8;
							branch_flag_o <= `Branch;
							branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
						end
					end else if (rt == `RT_BGEZ) begin
						if(reg1_o[31] == 1'b0) begin
							// return_addr_o <= `ZeroWord;
							branch_flag_o <= `Branch;
							branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
						end
					end else begin // if (rt == `RT_BGEZAL_BAL) 
						if(rs == `RS_BAL) begin // BAL
							return_addr_o <= pc_plus_8;
							branch_flag_o <= `Branch;
							branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
						end else begin // BGEZAL
							if(reg1_o[31] == 1'b0) begin
								return_addr_o <= pc_plus_8;
								branch_flag_o <= `Branch;
								branch_target_address_o <= pc_plus_4 + imm_sll2_sign;
							end
						end
					end
				end
			endcase
		end // else
	end // always

endmodule