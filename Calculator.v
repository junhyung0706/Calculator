module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,
    output reg [15:0] RESULT,
    output reg NEG
);
    reg [17:0] instruction_memory [0:15]; // 16개 메모리 슬롯
    reg [3:0] mem_index = 0;              // 메모리 쓰기 인덱스
    reg [4:0] execution_index = 0;        // 연산 실행 인덱스, 16까지 가야 하므로 4비트에서 5비트로 변경
    wire [1:0] op_code;                   // ALU 연산 코드
    wire [7:0] operand_a, operand_b;      // ALU 연산 피연산자
    wire [15:0] alu_result;               // ALU에서 계산된 결과
    wire alu_neg;                         // ALU에서 계산된 NEG 결과
    
    // ALU 모듈 인스턴스화
    ALU ALU_0(
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(alu_result),  // ALU 계산 결과
        .NEG(alu_neg)         // ALU NEG 결과
    );
    
    // instruction_memory에서 값을 읽어 ALU 입력에 할당
    assign op_code = instruction_memory[execution_index][17:16];
    assign operand_a = instruction_memory[execution_index][15:8];
    assign operand_b = instruction_memory[execution_index][7:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_index <= 0;
            execution_index <= 0;
            RESULT <= 0;
            NEG <= 0;
        end else if (mem_index < 16) begin
            instruction_memory[mem_index] <= DIN;
            mem_index <= mem_index + 1;
        end
    end
    
    // 실행 인덱스와 결과 처리 로직
    always @(posedge clk) begin
        if (execution_index < 16 && mem_index == 16) begin // 메모리가 다 채워진 후 실행
            // 실행 인덱스 증가는 ALU 연산 수행을 위해 별도의 조건을 검토
            execution_index <= execution_index + 1;
        end else if (execution_index == 16) begin // 모든 연산이 완료되면
            execution_index <= 0; // 실행 인덱스 리셋 (옵션: 필요에 따라 변경 가능)
        end
        // ALU 결과 업데이트
        if (execution_index > 0 && execution_index <= 16) begin
            RESULT <= alu_result;
            NEG <= alu_neg;
        end
    end
endmodule
