module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,
    output wire [15:0] RESULT,
    output wire NEG
);
    reg [17:0] instruction_memory [0:15]; // 16개 메모리 슬롯
    reg [3:0] mem_index = 0;              // 메모리 쓰기 인덱스
    reg [3:0] execution_index = 0;        // 연산 실행 인덱스
    reg [1:0] op_code;                    // ALU 연산 코드
    reg [7:0] operand_a, operand_b;       // ALU 연산 피연산자
    reg execute;                          // 연산 실행 트리거

    // ALU 결과와 NEG 신호를 임시 저장할 reg 타입 변수 선언
    reg [15:0] result_temp;
    reg neg_temp;

    // ALU 결과 및 NEG 신호를 Calculator 모듈의 출력에 연결
    assign RESULT = result_temp;
    assign NEG = neg_temp;

    // ALU 모듈 인스턴스화
    ALU ALU_0(
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(result_temp), // 임시 저장 변수에 연결
        .NEG(neg_temp)        // 임시 저장 변수에 연결
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_index <= 0;
            execution_index <= 0;
            execute <= 0;
            result_temp <= 0;
            neg_temp <= 0;
        end else if (mem_index < 16) begin
            instruction_memory[mem_index] <= DIN; // 메모리에 명령어 저장
            mem_index <= mem_index + 1;           // 메모리 인덱스 증가
        end else begin
            if (execution_index < 16) begin
                op_code <= instruction_memory[execution_index][17:16];
                operand_a <= instruction_memory[execution_index][15:8];
                operand_b <= instruction_memory[execution_index][7:0];
                execute <= 1; // 연산 실행
                execution_index <= execution_index + 1;
            end else if (execution_index == 16) begin
                execute <= 0; // 모든 명령어 처리 완료 후 연산 중지
                execution_index <= 0; // 선택적으로 실행 인덱스 리셋
            end
        end
    end
endmodule
