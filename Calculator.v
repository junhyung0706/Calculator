module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,
    output reg [15:0] RESULT,
    output reg NEG
);
    reg [17:0] instruction_memory [0:15]; // 16개 메모리 슬롯
    reg [3:0] mem_index = 0;              // 메모리 쓰기 인덱스
    reg [3:0] execution_index = 0;        // 연산 실행 인덱스
    reg execution_phase = 0;              // 실행 단계 플래그

    wire [1:0] op_code = instruction_memory[execution_index][17:16];
    wire [7:0] operand_a = instruction_memory[execution_index][15:8];
    wire [7:0] operand_b = instruction_memory[execution_index][7:0];
    wire [15:0] alu_result;
    wire alu_neg;

    // ALU 모듈 인스턴스화
    ALU ALU_0(
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(alu_result),
        .NEG(alu_neg)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_index <= 0;
            execution_index <= 0;
            execution_phase <= 0;
            RESULT <= 0;
            NEG <= 0;
        end else if (!execution_phase) begin
            if (mem_index < 15) begin
                instruction_memory[mem_index] <= DIN;
                mem_index <= mem_index + 1;
            end else begin
                // 마지막 메모리 슬롯에 데이터 저장 후, 실행 단계로 전환
                instruction_memory[mem_index] <= DIN;
                execution_phase <= 1; // 실행 단계로 전환
            end
        end
    end

    // 실행 단계에서 ALU 결과 처리
    always @(posedge clk) begin
        if (execution_phase && execution_index < 16) begin
            RESULT <= alu_result;
            NEG <= alu_neg;
            execution_index <= execution_index + 1;
            if (execution_index == 15) begin // 마지막 연산 완료
                execution_phase <= 0; // 필요한 경우 실행 단계 초기화
                execution_index <= 0; // 실행 인덱스 초기화
            end
        end
    end
endmodule
