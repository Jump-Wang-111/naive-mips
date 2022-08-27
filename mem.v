`include "defines.v"

module mem(

	input wire						rst,
	
	// ����ִ�н׶ε��ź�
	input wire[`RegAddrBus]       	wd_i,       // mem�׶�ָ��дĿ�ļĴ�����
	input wire[`WriteBus]           wreg_i,    // mem�׶�ָ��д�Ĵ���ʹ��
	input wire[`RegBus]				wdata_i,    // mem�׶�ָ��д��Ŀ�ļĴ�������
	
	input wire[`AluOpBus]			aluop_i,	// mem�׶�ָ��Ҫ���е�����������
	input wire[`RegBus]				mem_addr_i,	// mem�׶�ָ��ô�address
	input wire[`RegBus]				reg2_i,		// mem�׶ηô�����
	input wire[`InstAddrBus]		pc_i,
	
	// �͵�wb�׶ε��ź�
	output reg[`RegAddrBus]     	wd_o,          // mem�׶�ָ��дĿ�ļĴ�����
	output reg[`WriteBus]           wreg_o,       // mem�׶�ָ��д�Ĵ���ʹ��
	output reg[`RegBus]				wdata_o,      // mem�׶�ָ��д��Ŀ�ļĴ�������

    // �͵�ram
	output reg[`RegBus]				mem_addr_o,	// �ô�address
	output reg[3:0]					mem_we_o,	// �ô�дʹ��
`2	q3	output reg[`RegBus]				mem_data_o, // �ô�д����
	output reg						mem_ce_o,	// ramʹ���ź�
	
	
	output wire[`InstAddrBus]		pc_o,       // mem�׶�ָ��pc
	output reg[`AluOpBus]			aluop_o,    // mem�׶�ָ������������
	output reg 						stallreq    // mem�׶���ͣ��ˮ�߿����ź�

);
    
	assign pc_o = pc_i;

    always @(*) begin
        if(rst == `RstDisable) begin
            wd_o <= `ZeroRegAddr;
            wreg_o <= `WriteDisable;
            wdata_o <= `ZeroWord;
            aluop_o <= `ALU_OP_NOP;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
            aluop_o <= aluop_i;
        end
       
    end
    
endmodule