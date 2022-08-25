
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

	output wire[`RegBus]		  inst_o,
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
	wire [31:0] imm16_singe = {16{imm16[15]}, imm16};
	wire [31:0] imm16_unsinge = {16'b0, imm16};
	wire [31:0] imm26_singe = {6{imm16[25]}, imm26};
	wire [31:0] imm26_unsinge = {6'b0, imm26};
	
	assign stallreq = `NoStop;

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
			branch_target_address_o <= `ZeroWord;
			inst_o <= `ZeroWord;
			pc_o <= `InitialPc;
		end else begin
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
			/* */branch_target_address_o <= `ZeroWord;
			inst_o <= inst_i;
			pc_o <= pc_i;
			case(opcode)
				`INST_ :	begin

				end
				default begin

				end
			endcase
		end
	end

endmodule