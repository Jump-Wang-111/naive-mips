`include "defines.v"

module ctrl (
    
    input wire              rst,
    input wire              stallreq_from_id,
    input wire              stallreq_from_ex,
    input wire              stallreq_from_mem,

    output reg              stall

);
endmodule