module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,
    output reg [15:0] RESULT, // reg 타입으로 선언된 출력 포트
    output reg NEG            // reg 타입으로 선언된 출력 포트
);
    reg [17:0] instruction_memory [0:15]; // 16개 메모리 슬롯
    reg [3:0] mem_index = 0;              // 메모리 쓰기 인덱스
    reg [3:0] execution_index = 0;        // 연산 실행 인덱스
    reg [1:0] op_code;                    // ALU 연산 코드
    reg [7:0] operand_a, operand_b;       // ALU 연산 피연산자

    // ALU 모듈 인스턴스화
    ALU ALU_0(
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(RESULT), // ALU 결과는 RESULT에 직접 연결
        .NEG(NEG)       // ALU 부정 플래그는 NEG에 직접 연결
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RESULT <= 16'b0;              // RESULT를 0으로 초기화
            NEG <= 1'b0;                  // NEG를 0으로 초기화
            mem_index <= 4'b0;            // 메모리 인덱스를 0으로 초기화
            execution_index <= 4'b0;      // 실행 인덱스를 0으로 초기화
        end else if (mem_index < 16) begin
            instruction_memory[mem_index] = DIN; // 메모리에 명령어 저장
            mem_index = mem_index + 1;           // 메모리 인덱스 증가
        end else if (execution_index < 16) begin
            // 메모리에서 ALU 명령어를 가져옴
            op_code <= instruction_memory[execution_index][17:16];
            operand_a <= instruction_memory[execution_index][15:8];
            operand_b <= instruction_memory[execution_index][7:0];
            // ALU 연산 실행을 위해 인덱스 증가
            execution_index = execution_index + 1;
        end
        // ALU의 연산 결과는 이미 RESULT와 NEG에 연결되어 있음
    end
endmodule
