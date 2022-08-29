`include "defines.v"

module ctrl (
    
    input wire              rst,
    input wire              stallreq_from_id,   // id�׶η�������ˮ����ͣ�ź�
    input wire              stallreq_from_ex,   // ex�׶η�������ˮ����ͣ�ź�
    input wire              stallreq_from_mem,  // mem�׶η�������ˮ����ͣ�ź�

    output reg[`StopBus]    stall               // ������ˮ����ͣ���ź�

);


    always @(*) begin
        if(rst == `RstDisable) begin
            stall <= 6'b000000;
        end else if(stallreq_from_id == `Stop) begin
            stall <= 6'b000111;
        end else if(stallreq_from_ex == `Stop) begin
            stall <= 6'b001111;
        end else if (stallreq_from_mem == `Stop) begin
//            stall <= 6'b011111;
            stall <= 6'b000111;
        end else begin
            stall <= 6'b000000;
        end
    end
endmodule