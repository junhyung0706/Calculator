module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,
    output [15:0] RESULT,
    output NEG
);
    reg [17:0] instruction_memory [0:15]; // 16개의 메모리 슬롯을 가지는 메모리
    reg [3:0] mem_index = 0; // 메모리 인덱스(0~15)
    reg [3:0] execution_index = 0; // 실행 인덱스(0~15)
    reg execute = 0; // 실행 플래그
    
    // ALU에 연결할 레지스터를 선언
    reg [1:0] op_code;
    reg [7:0] operand_a, operand_b;
    wire alu_neg; // ALU NEG 출력을 위한 와이어
    wire [15:0] alu_result; // ALU RESULT 출력을 위한 와이어

    // ALU 모듈 인스턴스화
    ALU ALU_0(
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(alu_result),
        .NEG(alu_neg)
    );
    
    // 결과와 NEG 플래그를 연결
    assign RESULT = alu_result;
    assign NEG = alu_neg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RESULT <= 0;
            NEG <= 0;
            mem_index <= 0;
            execution_index <= 0;
            execute <= 0;
        end else if (mem_index < 16) begin
            instruction_memory[mem_index] <= DIN;
            mem_index <= mem_index + 1;
        end else if (execution_index < 16) begin
            // 메모리 쓰기가 완료되면, 실행 플래그를 활성화하고 연산을 시작합니다.
            execute <= 1;
            op_code <= instruction_memory[execution_index][17:16];
            operand_a <= instruction_memory[execution_index][15:8];
            operand_b <= instruction_memory[execution_index][7:0];
            execution_index <= execution_index + 1;
        end else begin
            execute <= 0;
        end
    end

    // 결과와 NEG 플래그 업데이트
    always @(posedge clk) begin
        if (execute) begin
            RESULT <= alu_result;
            NEG <= alu_neg;
        end
    end
endmodule
