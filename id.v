
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
	output reg                    branch_flag_o,          // �Ƿ�Ҫ��ת
	output reg[`InstAddrBus]	  branch_target_address_o,  // ��ת��pcֵ

	output wire[`RegBus]		  inst_o,
	output wire[`InstAddrBus]	  pc_o,
	output reg 			      	  stallreq
			
);

endmodule