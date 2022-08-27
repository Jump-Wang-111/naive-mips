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
	output wire 					stallreq    // mem阶段暂停流水线控制信号

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