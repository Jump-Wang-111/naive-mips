`include "defines.v"

module ctrl (
    
    input wire              rst,
    input wire              stallreq_from_id,   // id�׶η�������ˮ����ͣ�ź�
    input wire              stallreq_from_ex,   // ex�׶η�������ˮ����ͣ�ź�
    input wire              stallreq_from_mem,  // mem�׶η�������ˮ����ͣ�ź�

    output reg              stall               // ������ˮ����ͣ���ź�

);
endmodule