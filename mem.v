`include "defines.v"

module mem(

	input wire						rst,
	
	// ����ִ�н׶ε��ź�
	input wire[`RegAddrBus]       	wd_i,       // mem�׶�ָ��дĿ�ļĴ�����
	input wire[`RegBus]             wreg_i,    // mem�׶�ָ��д�Ĵ���ʹ��
	input wire[`RegBus]				wdata_i,    // mem�׶�ָ��д��Ŀ�ļĴ�������
	
	input wire[`AluOpBus]			aluop_i,	// mem�׶�ָ��Ҫ���е�����������
	input wire[`RegBus]				mem_addr_i,	// mem�׶�ָ��ô�address
	input wire[`RegBus]				reg2_i,		// mem�׶ηô�����
	input wire[`InstAddrBus]		pc_i,
	
	// �͵�wb�׶ε��ź�
	output reg[`RegAddrBus]     	wd_o,          // mem�׶�ָ��дĿ�ļĴ�����
	output reg[`RegBus]             wreg_o,       // mem�׶�ָ��д�Ĵ���ʹ��
	output reg[`RegBus]				wdata_o,      // mem�׶�ָ��д��Ŀ�ļĴ�������

    // �͵�ram
	output reg[`RegBus]				mem_addr_o,	// �ô�address
	output reg[3:0]					mem_we_o,	// �ô�дʹ��
	output reg[`RegBus]				mem_data_o, // �ô�д����
	output reg						mem_ce_o,	// ramʹ���ź�
	
	
	output wire[`InstAddrBus]		pc_o,       // mem�׶�ָ��pc
	output wire[`AluOpBus]			aluop_o,    // mem�׶�ָ������������
	output reg 						stallreq    // mem�׶���ͣ��ˮ�߿����ź�

);

endmodule