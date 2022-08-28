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
	
	// data from ram
	input wire[`RegBus]          	mem_data_i,
	
	// �͵�wb�׶ε��ź�
	output reg[`RegAddrBus]     	wd_o,          // mem�׶�ָ��дĿ�ļĴ�����
	output reg[`WriteBus]           wreg_o,       // mem�׶�ָ��д�Ĵ���ʹ��
	output reg[`RegBus]				wdata_o,      // mem�׶�ָ��д��Ŀ�ļĴ�������

    // �͵�ram
	output reg[`RegBus]				mem_addr_o,	// �ô�address
	output reg[3:0]					mem_we_o,	// �ô�дʹ��
	output reg[`RegBus]				mem_data_o, // �ô�д����
	output reg						mem_ce_o,	// ramʹ���ź�
	
	
	output wire[`InstAddrBus]		pc_o,       // mem�׶�ָ��pc
	output reg[`AluOpBus]			aluop_o,    // mem�׶�ָ������������
	output wire 					stallreq    // mem�׶���ͣ��ˮ�߿����ź�

);
    
	assign pc_o = pc_i;
	assign stallreq = `NoStop;

    always @(*) begin
        if(rst == `RstDisable) begin
            wd_o <= `ZeroRegAddr;
            wreg_o <= `WriteDisable;
            wdata_o <= `ZeroWord;
            aluop_o <= `ALU_OP_NOP;
			mem_addr_o <= `ZeroWord;
			mem_we_o <= `WriteDisable;
			mem_data_o <= `ZeroWord;
			mem_ce_o <= `WriteDisable;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
            aluop_o <= aluop_i;
			mem_addr_o <= `ZeroWord;
			mem_we_o <= 4'b1111;
			mem_data_o <= `ZeroWord;
			mem_ce_o <= `ReadDisable;
			case(aluop_i)
				`ALU_OP_LW : begin
					mem_addr_o <= mem_addr_i;
					mem_we_o <= 4'b0000;
					wdata_o <= mem_data_i;
					mem_ce_o <= `ReadEnable;
				end
				`ALU_OP_LB : begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ReadEnable;
					case(mem_addr_i[1:0]) 
						2'b00 : begin
							wdata_o <= {{24{mem_data_i[31]}}, mem_data_i[31:24]};
							mem_we_o <= 4'b1000;
						end
						2'b01 : begin
							wdata_o <= {{24{mem_data_i[23]}}, mem_data_i[23:16]};
							mem_we_o <= 4'b0100;
						end
						2'b10 : begin
							wdata_o <= {{24{mem_data_i[15]}}, mem_data_i[15:8]};
							mem_we_o <= 4'b0010;
						end
						2'b11 : begin
							wdata_o <= {{24{mem_data_i[7]}}, mem_data_i[7:0]};
							mem_we_o <= 4'b0001;
						end
						default : begin
							wdata_o <= `ZeroWord;
						end
					endcase
				end
				`ALU_OP_LH : begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ReadEnable;
					case(mem_addr_i[1:0]) 
						2'b00 : begin
							wdata_o <= {{24{mem_data_i[31]}}, mem_data_i[31:16]};
							mem_we_o <= 4'b1100;
						end
						2'b10 : begin
							wdata_o <= {{24{mem_data_i[15]}}, mem_data_i[15:0]};
							mem_we_o <= 4'b0011;
						end
						default : begin
							wdata_o <= `ZeroWord;
						end
					endcase
				end
				`ALU_OP_SW : begin
					mem_addr_o <= mem_addr_i;
					// mem_we_o <= 4'b1111;
					mem_data_o <= reg2_i;
					mem_ce_o <= `ReadEnable;
				end
				`ALU_OP_SB : begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ReadEnable;
					mem_data_o <= {reg2_i[7:0], reg2_i[7:0], reg2_i[7:0], reg2_i[7:0]};
					case(mem_addr_i[1:0])
						2'b00 : begin
							mem_we_o <= 4'b1000;
						end
						2'b01 : begin
							mem_we_o <= 4'b0100;
						end
						2'b10 : begin
							mem_we_o <= 4'b0010;
						end
						2'b11 : begin
							mem_we_o <= 4'b0001;
						end
					endcase
				end
				`ALU_OP_SH : begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ReadEnable;
					mem_data_o <= {reg2_i[15:0], reg2_i[15:0]};
					case(mem_addr_i[1:0])
						2'b00 : begin
							mem_we_o <= 4'b1100;
						end
						2'b10 : begin
							mem_we_o <= 4'b0011;
						end
					endcase
				end
				default : begin

				end
			endcase
        end
        
    end
    
endmodule