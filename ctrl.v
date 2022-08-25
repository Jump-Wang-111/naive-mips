`include "defines.v"

module ctrl (
    
    input wire              rst,
    input wire              stallreq_from_id,   // id阶段发出的流水线暂停信号
    input wire              stallreq_from_ex,   // ex阶段发出的流水线暂停信号
    input wire              stallreq_from_mem,  // mem阶段发出的流水线暂停信号

    output reg              stall               // 控制流水线暂停的信号

);
endmodule