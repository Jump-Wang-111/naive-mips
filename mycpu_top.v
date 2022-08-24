`include "defines.v"

module mycpu_top(

	input wire							clk,
	input wire							resetn,
	
	input [5:0]							int,				//interrupt,high active

	output 								inst_sram_en,		
	output [3:0]						inst_sram_wen,		
	output wire[`RegBus]          		inst_sram_addr,		
	output [31:0]						inst_sram_wdata,	
	input wire[`RegBus]           		inst_sram_rdata,	


	output 								data_sram_en,		
	output [3:0]						data_sram_wen,		// ��Ч�ֽ�
	output [31:0]						data_sram_addr, 	
	output [31:0]						data_sram_wdata,	
	input  [31:0]						data_sram_rdata,	

	output [31:0]						debug_wb_pc,		
	output [3:0]						debug_wb_rf_wen,	
	output [4:0]						debug_wb_rf_wnum,	
	output [31:0]						debug_wb_rf_wdata	

	
);

	wire rst;
	assign rst = ~resetn;

	assign inst_sram_wen = 4'b0000;

	wire[`InstAddrBus] pc;
	wire[`InstAddrBus] id_pc_i;
	wire[`InstBus] id_inst_i;
	

	wire[`AluOpBus] id_aluop_o;
	wire[`AluSelBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire[`WriteBus] id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	

	wire[`AluOpBus] ex_aluop_i;
	wire[`AluSelBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire[`WriteBus] ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;
	

	wire[`WriteBus] ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;


	wire[`WriteBus] mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;


	wire[`WriteBus] mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;
		

	wire[`WriteBus] wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;
	
	
	wire reg1_read;
	wire reg2_read;
	wire[`RegBus] reg1_data;
	wire[`RegBus] reg2_data;
	wire[`RegAddrBus] reg1_addr;
	wire[`RegAddrBus] reg2_addr;
	
  


	wire[`InstAddrBus] pc_three;

	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
			
		.branch_flag_i(branch_flag),				//input
		.branch_target_address_i(branch_target_address),		//input
		.stall(stall),

		.pc(pc),
		.ce(inst_sram_en),
		.pc_three(pc_three)
	);
	
  assign inst_sram_addr = pc_three;

	if_id if_id0(
		.clk(clk),
		.rst(rst),

		.if_pc(pc),
		.if_inst(inst_sram_rdata),
		.stall(stall),
		.stall_aluop(aluop4_stall),
		.id_pc(id_pc_i),
		.id_inst(id_inst_i)      	
	);
	

	wire branch_flag;
	wire [`InstAddrBus]	branch_target_address;
	wire[`RegBus] return_addr;
	wire[`RegBus] inst;
	wire[`InstAddrBus] pc1;
	wire stallreq_from_id;

	id id0(
		.rst(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),

		.ex_wreg_i(ex_wreg_o),
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),

		.mem_wreg_i(mem_wreg_o),
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),

		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

		.reg1_read_o(reg1_read),
		.reg2_read_o(reg2_read), 	  
		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr), 
	  
		.aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),
		.reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),
		.wd_o(id_wd_o),
		.wreg_o(id_wreg_o),
		.return_addr_o(return_addr),


		.branch_flag_o(branch_flag),			//output
		.branch_target_address_o(branch_target_address),		//output
	
		.inst_o(inst),
		.pc_o(pc1),
		.stallreq(stallreq_from_id)
	);


	regfile regfile1(
		.clk (clk),
		.rst (rst),

		.we	(we),
		.waddr (wd),
		.wdata (wdata),
		// .wdata_from_ram(data_sram_rdata),


		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),

		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data)
		

	);


	wire[`RegBus] inst1;
	wire[`InstAddrBus] pc2;

	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		
		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_return_addr(return_addr),
		.id_inst(inst),
		.id_pc(pc1),
	
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.ex_return_addr(return_addr_1),
		.ex_inst(inst1),
		.ex_pc(pc2)
	);		
	

	wire[`RegBus] return_addr_1;
	wire[`AluOpBus] aluop;
	wire[`RegBus] mem_addr;
	wire[`RegBus] reg2;
	wire[`InstAddrBus] pc3;
	wire stallreq_from_ex;

	ex ex0(
		.rst(rst),
	
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		.return_addr_i(return_addr_1),
		.inst_i(inst1),
		.pc_i(pc2),
	  
		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),

		.aluop_o(aluop),
		.mem_addr_o(mem_addr),
		.reg2_o(reg2),
		.pc_o(pc3),
		.stallreq(stallreq_from_ex)
	);


	wire[`AluOpBus] aluop1;
	wire[`RegBus] mem_addr1;
	wire[`RegBus] reg21;
	wire[`InstAddrBus] pc4;

  	ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
	  
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
		.ex_aluop(aluop),
		.ex_mem_addr(mem_addr),
		.ex_reg2(reg2),
		.ex_pc(pc3),

		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),
		.mem_aluop(aluop1),
		.mem_mem_addr(mem_addr1),
		.mem_reg2(reg21),
		.mem_pc(pc4)				       	
	);
	

	wire[`InstAddrBus] pc5;
	wire stallreq_from_mem;
	wire[31:0] data_addr;
	assign data_sram_addr = {3'b0,data_addr[28:0]};
	wire[`AluOpBus] aluop2;

	mem mem0(
		.rst(rst),
	
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
		.aluop_i(aluop1),
		.mem_addr_i(mem_addr1),
		.reg2_i(reg21),
		.pc_i(pc4),

		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),

		.mem_addr_o(data_addr),
		.mem_we_o(data_sram_wen),
		.mem_data_o(data_sram_wdata),
		.mem_ce_o(data_sram_en),
		.aluop_o(aluop2),
		.pc_o(pc5),
		.stallreq(stallreq_from_mem)
	);

	wire[`InstAddrBus] pc6;
	wire[`AluOpBus] aluop4_stall;
	
	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),

		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),
		.mem_pc(pc5),
		.mem_aluop(aluop2),
	
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i),
		.wb_pc(pc6),
		.wb_aluop_stall(aluop4_stall)
									       	
	);

	//从wb_ram模块直接送到寄存�?
	wire[`RegAddrBus] wd; 
	wire[`WriteBus] we;
	wire[`RegBus] wdata;

	assign debug_wb_rf_wdata = wdata;
	assign debug_wb_rf_wnum = wd;

	wb_ram wb_ram0(
		.pc_i(pc6),
		.wd_i(wb_wd_i),
		.wreg_i(wb_wreg_i),
		.wdata_i(wb_wdata_i),
		.wdata_from_ram_i(data_sram_rdata),

		.pc_o(debug_wb_pc),
		.wd_o(wd),
		.wreg_o(debug_wb_rf_wen),
		.we_o(we),
		.wdata_o(wdata)
	);
	

	wire stall;
	ctrl ctrl0(
		.rst(rst),
		.stallreq_from_id(stallreq_from_id),
		.stallreq_from_ex(stallreq_from_ex),
		.stallreq_from_mem(stallreq_from_mem),

		.stall(stall)

	);


endmodule