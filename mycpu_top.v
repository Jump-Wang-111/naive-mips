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
	
	wire rst = resetn;

	// declare part
	// pc
	wire 					pc_branch_flag;            		// 
	wire[`InstAddrBus]		pc_branch_target_address;  		// 
	wire					pc_stall;

	wire[`InstAddrBus]		pc_pc;                         	//
	wire[`InstAddrBus]   	pc_three;                  		//
	wire                  	pc_ce;                       	// inst memory enable

	// if_id 
	wire [`InstAddrBus]      if_pc;
	wire [`InstBus]          if_inst;
	wire                     if_id_stall;
	wire                     if_id_stall_aluop;

	// id
	wire[`InstAddrBus]		id_pc_i;
	wire[`InstBus]      	id_inst_i;
	wire[`RegBus]           id_reg1_data_i;
	wire[`RegBus]           id_reg2_data_i;
	wire                    id_reg1_read_o;
	wire                    id_reg2_read_o;
	wire[`RegAddrBus]       id_reg1_addr_o;  
	wire[`RegAddrBus] 		id_reg2_addr_o;
	
	wire[`AluOpBus]         id_aluop_o;
	wire[`AluSelBus]        id_alusel_o;
	wire[`RegBus]           id_reg1_o;
	wire[`RegBus]           id_reg2_o;
	wire[`RegAddrBus]       id_wd_o;
	wire[`WriteBus]         id_wreg_o;
	wire[`RegBus] 		  	id_return_addr_o;

	wire                    id_branch_flag_o;
	wire[`InstAddrBus]	  	id_branch_target_address_o;

	wire[`RegBus]		  	id_inst_o;
	wire[`InstAddrBus]	  	id_pc_o;
	wire 			      	id_stallreq;

	// regfile
	wire[`WriteBus]		  	regfile_we;       
	wire[`RegAddrBus]		regfile_waddr;    
	wire[`RegBus]			regfile_wdata;   
	
	wire					regfile_re1;      
	wire[`RegAddrBus]		regfile_raddr1;   
	wire[`RegBus]           regfile_rdata1;   
	
	
	wire					regfile_re2;
	wire[`RegAddrBus]		regfile_raddr2;
	wire[`RegBus]           regfile_rdata2;

	// ex
	wire[`AluOpBus]         	ex_aluop_i;
	wire[`AluSelBus]        	ex_alusel_i;
	wire[`RegBus]           	ex_reg1_i;
	wire[`RegBus]           	ex_reg2_i;
	wire[`RegAddrBus]       	ex_wd_i;
	wire[`WriteBus]           	ex_wreg_i;
	wire[`RegBus] 				ex_return_addr_i; 
	wire[`RegBus]				ex_inst_i;
	wire[`InstAddrBus]			ex_pc_i;

	wire[`RegAddrBus]        	ex_wd_o;
	wire[`WriteBus]          	ex_wreg_o;
	wire[`RegBus]			    ex_wdata_o;
	
	wire[`AluOpBus]				ex_aluop_o;
	wire[`RegBus]				ex_mem_addr_o;
	wire[`RegBus]				ex_reg2_o;
	wire[`InstAddrBus]			ex_pc_o;
	wire 						ex_stallreq;

	//mem
	wire[`RegAddrBus]       	mem_wd_i;
	wire[`WriteBus]             mem_wreg_i;
	wire[`RegBus]				mem_wdata_i;
	
	wire[`AluOpBus]				mem_aluop_i;
	wire[`RegBus]				mem_addr_i;
	wire[`RegBus]				mem_reg2_i;
	wire[`InstAddrBus]			mem_pc_i;

	wire[`RegAddrBus]     		mem_wd_o;
    wire[`WriteBus]             mem_wreg_o;
	wire[`RegBus]				mem_wdata_o;

	wire[`RegBus]				mem_data_addr_o;
	
	wire[`InstAddrBus]			mem_pc_o;
	wire[`AluOpBus]				mem_aluop_o;
	wire 						mem_stallreq;

    // ctrl
    wire[`StopBus]              stall;
	// example part
	// pc
	
	assign pc_branch_flag = id_branch_flag_o;
    assign pc_branch_target_address = id_branch_target_address_o;	
    
	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
			
		.branch_flag_i(pc_branch_flag),							//input
		.branch_target_address_i(pc_branch_target_address),		//input
		.stall(stall),

		.pc(pc_pc),
		.pc_three(pc_three),
		.ce(inst_sram_en)
	);

	assign inst_sram_addr = pc_pc;
	assign if_pc = pc_pc;
	assign if_inst = inst_sram_rdata;

	//if_id
	if_id if_id0(
		.clk(clk),
		.rst(rst),

		.if_pc(if_pc),
		.if_inst(if_inst),
		.stall(stall),
//		.stall_aluop(if_id_stall_aluop),

		.id_pc(id_pc_i),
		.id_inst(id_inst_i)      	
	);
    
    assign id_reg1_data_i = regfile_rdata1;
    assign id_reg2_data_i = regfile_rdata2;

	// id
	id id0(
		.rst(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),

		// solve data conflict
		.ex_wreg_i(ex_wreg_o),
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),
		.ex_aluop_i(ex_aluop_o),

		// solve data conflict
		.mem_wreg_i(mem_wreg_o),
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),

		.reg1_data_i(id_reg1_data_i),
		.reg2_data_i(id_reg2_data_i),

		.reg1_read_o(id_reg1_read_o),
		.reg2_read_o(id_reg2_read_o), 	  
		.reg1_addr_o(id_reg1_addr_o),
		.reg2_addr_o(id_reg2_addr_o), 
	  
		.aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),
		.reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),
		.wd_o(id_wd_o),
		.wreg_o(id_wreg_o),
		.return_addr_o(id_return_addr_o),

		.branch_flag_o(id_branch_flag_o),			
		.branch_target_address_o(id_branch_target_address_o),		
	
		.inst_o(id_inst_o),
		.pc_o(id_pc_o),
		.stallreq(id_stallreq)
	);

	assign regfile_re1 = id_reg1_read_o;
	assign regfile_re2 = id_reg2_read_o;
	assign regfile_raddr1 = id_reg1_addr_o;
	assign regfile_raddr2 = id_reg2_addr_o;

	// regfile
	regfile regfile1(
		.clk (clk),
		.rst (rst),

		.we	(regfile_we),
		.waddr (regfile_waddr),
		.wdata (regfile_wdata),
		// .wdata_from_ram(data_sram_rdata),


		.re1 (regfile_re1),
		.raddr1 (regfile_raddr1),
		.rdata1 (regfile_rdata1),

		.re2 (regfile_re2),
		.raddr2 (regfile_raddr2),
		.rdata2 (regfile_rdata2)

	);

	// id_ex
	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		
		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_return_addr(id_return_addr_o),
		.id_inst(id_inst_o),
		.id_pc(id_pc_o),
		.stall(stall),
	
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.ex_return_addr(ex_return_addr_i),
		.ex_inst(ex_inst_i),
		.ex_pc(ex_pc_i)
	);	

	// ex
	ex ex0(
		.rst(rst),
	
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		.return_addr_i(ex_return_addr_i),
		.inst_i(ex_inst_i),
		.pc_i(ex_pc_i),
	  
		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),

		.aluop_o(ex_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(ex_reg2_o),
		.pc_o(ex_pc_o),
		.stallreq(ex_stallreq)
	);

	// ex_mem
	ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
	  
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
		.ex_aluop(ex_aluop_o),
		.ex_mem_addr(ex_mem_addr_o),
		.ex_reg2(ex_reg2_o),
		.ex_pc(ex_pc_o),
		.stall(stall),

		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),
		.mem_aluop(mem_aluop_i),
		.mem_mem_addr(mem_addr_i),
		.mem_reg2(mem_reg2_i),
		.mem_pc(mem_pc_i)				       	
	);

	// mem
	assign data_sram_addr = {3'b0,mem_data_addr_o[28:0]};

	mem mem0(
		.rst(rst),
	
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
		.aluop_i(mem_aluop_i),
		.mem_addr_i(mem_addr_i),
		.reg2_i(mem_reg2_i),
		.pc_i(mem_pc_i),

		.mem_data_i(data_sram_rdata),

		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),

		.mem_addr_o(mem_data_addr_o),
		.mem_we_o(data_sram_wen),
		.mem_data_o(data_sram_wdata),
		.mem_ce_o(data_sram_en),
		.aluop_o(mem_aluop_o),
		.pc_o(mem_pc_o),
		.stallreq(mem_stallreq)
	);

	// mem_wb
	wire[`RegAddrBus]      		wb_wd_i;
	wire[`WriteBus]          	wb_wreg_i;
	wire[`RegBus]				wb_wdata_i;
	wire[`InstAddrBus]			wb_pc_i;
	wire[`AluOpBus]				wb_aluop_i;  

	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),

		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_i),
		.mem_pc(mem_pc_o),
		.mem_aluop(mem_aluop_o),
		.stall(stall),
	
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i),
		.wb_pc(wb_pc_i),
		.wb_aluop(wb_aluop_i)
									       	
	);

	// wb
	assign regfile_we 		= wb_wreg_i;
	assign regfile_waddr 	= wb_wd_i;
//	assign regfile_wdata 	= wb_wdata_i;
    
    // ctrl
    ctrl ctrl0(
        .rst(rst),
        .stallreq_from_id(id_stallreq),   // id�׶η�������ˮ����ͣ�ź�
        .stallreq_from_ex(ex_stallreq),   // ex�׶η�������ˮ����ͣ�ź�
        .stallreq_from_mem(mem_stallreq),  // mem�׶η�������ˮ����ͣ�ź�

        .stall(stall)               // ������ˮ����ͣ���ź�
    );
    
	// debug
	assign debug_wb_pc 		= wb_pc_i;
	assign debug_wb_rf_wen 	= 4'b1111; //wb_wreg_i;
	assign debug_wb_rf_wnum = wb_wd_i;
//	assign debug_wb_rf_wdata= wb_wdata_i;
	assign debug_wb_rf_wdata= regfile_wdata;
    
    assign regfile_wdata = ((wb_aluop_i == `ALU_OP_LW) || (wb_aluop_i == `ALU_OP_LH) || (wb_aluop_i == `ALU_OP_LB) || (wb_aluop_i == `ALU_OP_NOP)) ? data_sram_rdata : wb_wdata_i;
    
endmodule