`include "defines.v"

module mem(

	input wire						rst,
	
	// 来自执行阶段的信号
	input wire[`RegAddrBus]       	wd_i,       // mem阶段指令写目的寄存器号
	input wire[`WriteBus]           wreg_i,    // mem阶段指令写寄存器使能
	input wire[`RegBus]				wdata_i,    // mem阶段指令写入目的寄存器数据
	
	input wire[`AluOpBus]			aluop_i,	// mem阶段指令要进行的运算子类型
	input wire[`RegBus]				mem_addr_i,	// mem阶段指令访存address
	input wire[`RegBus]				reg2_i,		// mem阶段访存数据
	input wire[`InstAddrBus]		pc_i,
	
	// data from ram
	input wire[`RegBus]          	mem_data_i,
	
	// 送到wb阶段的信号
	output reg[`RegAddrBus]     	wd_o,          // mem阶段指令写目的寄存器号
	output reg[`WriteBus]           wreg_o,       // mem阶段指令写寄存器使能
	output reg[`RegBus]				wdata_o,      // mem阶段指令写入目的寄存器数据

    // 送到ram
	output reg[`RegBus]				mem_addr_o,	// 访存address
	output reg[3:0]					mem_we_o,	// 访存写使能
	output reg[`RegBus]				mem_data_o, // 访存写数据
	output reg						mem_ce_o,	// ram使能信号
	
	
	output wire[`InstAddrBus]		pc_o,       // mem阶段指令pc
	output reg[`AluOpBus]			aluop_o,    // mem阶段指令运算子类型
	output reg 						stallreq    // mem阶段暂停流水线控制信号

);
    
	assign pc_o = pc_i;

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
					// mem_we_o <= 4'b1111;
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