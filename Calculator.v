module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,
    output reg [15:0] RESULT,
    output reg NEG
);
    reg [17:0] instruction_memory [0:15];
    reg [3:0] mem_index = 0;
    reg [4:0] execution_index = 0; // 0-15의 값을 가질 수 있도록 5비트 필요
    wire [1:0] op_code;
    wire [7:0] operand_a, operand_b;
    wire [15:0] alu_result;
    wire alu_neg;

    // ALU 모듈 인스턴스화
    ALU ALU_0 (
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(alu_result),
        .NEG(alu_neg)
    );

    // 메모리에서 명령어를 추출하여 ALU 입력에 할당
    assign op_code = instruction_memory[execution_index][17:16];
    assign operand_a = instruction_memory[execution_index][15:8];
    assign operand_b = instruction_memory[execution_index][7:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_index <= 0;
            execution_index <= 0; // 리셋 상태에서는 실행 인덱스도 리셋
            RESULT <= 0;
            NEG <= 0;
        end else if (mem_index < 16 && execution_index == 0) begin
            // 명령어 쓰기 모드
            instruction_memory[mem_index] <= DIN;
            mem_index <= mem_index + 1;
        end
    end

    // 실행 인덱스 관리 및 ALU 결과 업데이트
    always @(posedge clk) begin
        if (mem_index == 16 && execution_index < 16) begin
            // 모든 명령어가 메모리에 로드된 후, 실행 모드
            execution_index <= execution_index + 1; // 실행 인덱스 증가
        end
        if (execution_index > 0 && execution_index <= 16) begin
            // 결과 업데이트
            RESULT <= alu_result; // 실행 중 ALU 결과를 RESULT로 업데이트
            NEG <= alu_neg; // 실행 중 ALU NEG 상태를 NEG로 업데이트
        end
    end
endmodule
