module Calculator(
    input clk,
    input reset,
    input [17:0] DIN,	                    // 18비트 데이터 입력
    output reg [15:0] RESULT,	            // 연산 결과를 저장하는 16비트 출력
    output reg NEG		            // 연산 결과가 음수일 경우 1을 출력하는 플래그
);
    reg [17:0] instruction_memory [0:15];     // 16개의 18비트 명령어를 저장할 수 있는 메모리
    reg [3:0] mem_index = 0;                  // 메모리 쓰기를 위한 인덱스
    reg [3:0] execution_index = 0;            // 명령어 실행을 위한 인덱스
    reg execution_phase = 0;                  // 실행 단계 플래그, 명령어 저장 후 실행 단계로 전환하는데 사용

// 현재 실행 중인 명령어에서 연산 코드와 피연산자를 추출
    wire [1:0] op_code = instruction_memory[execution_index][17:16];	// 연산 코드 추출
    wire [7:0] operand_a = instruction_memory[execution_index][15:8];	// 첫 번째 피연산자 추출
    wire [7:0] operand_b = instruction_memory[execution_index][7:0];	// 두 번째 피연산자 추출
    wire [15:0] alu_result;	                                        // ALU로부터의 연산 결과
    wire alu_neg;		                                        // ALU 연산 결과가 음수인 경우를 나타내는 신호

// ALU 모듈 인스턴스화, 연산 코드와 피연산자를 기반으로 연산 수행
    ALU ALU_0(
        .OP_CODE(op_code),
        .A(operand_a),
        .B(operand_b),
        .RESULT(alu_result),	// ALU로부터의 결과값
        .NEG(alu_neg)	        // ALU로부터의 음수 플래그
    );

// 클럭의 상승 에지나 리셋 신호가 활성화될 때 동작
    always @(posedge clk or posedge reset) begin
        if (reset) begin
	        // 리셋 시 모든 상태 초기화
            mem_index <= 0;
            execution_index <= 0;
            execution_phase <= 0;
            RESULT <= 0;
            NEG <= 0;
        end else if (!execution_phase) begin
	        // 명령어 저장 단계
            if (mem_index < 15) begin
	            // 메모리가 다 차기 전까지 DIN 값을 메모리에 저장
                instruction_memory[mem_index] <= DIN;
                mem_index <= mem_index + 1;
            end else begin
                // 마지막 메모리 위치에 DIN 값을 저장하고 실행 단계로 전환
                instruction_memory[mem_index] <= DIN;
                execution_phase <= 1; // 실행 단계 플래그 설정
            end
        end
    end

// 명령어 실행 단계
    always @(posedge clk) begin
        if (execution_phase && execution_index < 16) begin
	        // 실행 단계가 활성화되고 실행 인덱스가 유효한 범위 내에 있을 때
            RESULT <= alu_result;	                                // ALU의 결과를 RESULT에 저장
            NEG <= alu_neg;		                                    // ALU의 음수 플래그를 NEG에 저장
            execution_index <= execution_index + 1;	// 실행 인덱스 증가
            if (execution_index == 15) begin 
	            // 모든 명령어 실행 완료 후 초기화
                execution_phase <= 0; 	                            // 실행 단계 플래그 초기화
                execution_index <= 0; 	                            // 실행 인덱스 초기화
            end
        end
    end
endmodule
