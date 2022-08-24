`include "defines.v"

module wb_ram (

    input wire[`RegBus]             pc_i,
    input wire[`RegAddrBus]         wd_i,
    input wire[`WriteBus]           wreg_i,
    input wire[`RegBus]             wdata_i,                //来自执行结果的数�??
    input wire[`RegBus]             wdata_from_ram_i,       //来自数据存储器的数据

    output reg[`RegBus]             pc_o,
    output reg[`RegAddrBus]         wd_o,
    output reg[3:0]                 wreg_o,                 //给cpu的接�?
    output reg[`WriteBus]           we_o,                   //给寄存器的接�?
    output reg[`RegBus]             wdata_o


);
    
endmodule