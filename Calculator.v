module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,
    output wire [15:0] RESULT, // wire 타입으로 선언된 출력 포트
    output wire NEG            // wire 타입으로 선언된 출력 포트
);
    reg [17:0] instruction_memory [0:15];
    reg [3:0] mem_index = 0;
    reg [3:0] execution_index = 0;
    reg [1:0] op_code;
    reg [7:0] operand_a, operand_b;

    // 임시 저장 변수를 제거하고 ALU 모듈의 출력을 직접 연결
    ALU ALU_0(
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(RESULT), // ALU 모듈의 결과를 직접 연결
        .NEG(NEG)       // ALU 모듈의 NEG 출력을 직접 연결
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_index <= 0;
            execution_index <= 0;
        end else if (mem_index < 16) begin
            instruction_memory[mem_index] <= DIN;
            mem_index <= mem_index + 1;
        end else if (execution_index < 16) begin
            op_code <= instruction_memory[execution_index][17:16];
            operand_a <= instruction_memory[execution_index][15:8];
            operand_b <= instruction_memory[execution_index][7:0];
            execution_index <= execution_index + 1;
        end else if (execution_index == 16) begin
            execution_index <= 0; // 실행 인덱스 리셋
        end
    end
endmodule
