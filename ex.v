`include "defines.v"

module ex(

	input wire						rst,
	
	// ����ex�׶ε��ź�
	input wire[`AluOpBus]         	aluop_i,		// ex�׶�ָ������������
	input wire[`AluSelBus]        	alusel_i,		// ex�׶�ָ����������
	input wire[`RegBus]           	reg1_i,         // ��1��������
	input wire[`RegBus]           	reg2_i,         // ��2��������
	input wire[`RegAddrBus]       	wd_i,			// дĿ�ļĴ�����
	input wire[`WriteBus]           wreg_i,			// дĿ�ļĴ���ʹ��
	input wire[`RegBus] 			return_addr_i,  // ���ص�ַ
	input wire[`RegBus]				inst_i,         // ex�׶ε�ָ��
	input wire[`InstAddrBus]		pc_i,           // ex�׶�ָ���pc
	
	// ��ex�׶�������ź�
	output reg[`RegAddrBus]        wd_o,           // ex�׶�дĿ�ļĴ�����
	output reg[`WriteBus]          wreg_o,         // ex�׶�ָ��д�Ĵ���ʹ��
	output reg[`RegBus]			    wdata_o,	   // ex�׶�ָ��д��Ŀ�ļĴ�������

	output wire[`AluOpBus]			aluop_o,       // ex�׶�ָ��������������
	output wire[`RegBus]			mem_addr_o,    // �ô�address
	output wire[`RegBus]			reg2_o,        // ex�׶ε�2��������

	output wire[`InstAddrBus]		pc_o,          // ex�׶�ָ��pc
	output reg 						stallreq       // ex�׶���ˮ����ͣ�����ź�
	
);

endmodule