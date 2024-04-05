module ALU(
    input [7:0] A, B,		                        // 8비트 크기의 입력
    input [1:0] OP_CODE,                            // 연산코드. 00 : 합, 01 : 차, 10 : 곱
    output [15:0] RESULT,	                        // 16비트의 곱셈의 연산결과를 저장하는 변수
    output NEG		                                // 1비트의 연산 결과가 음수인지 확인하는 플래그
);

wire [15:0] add_result;	                            // 덧셈 연산의 결과를 저장하는 16비트 와이어
wire [7:0] sub_result;	                            // 뺄셈 연산의 결과를 저장하는 8비트 와이어
wire sub_neg;		                                // 뺄셈 연산의 결과가 음수인지 나타내는 플래그
wire [15:0] mul_result;	                            // 곱셈 연산의 결과를 저장하는 16비트 와이어.

//각 연산 모듈의 인스턴스화
Adder Adder_0(.A(A), .B(B), .RESULT(add_result));			                    // 덧셈 연산 모듈
Subtractor Subtractor_0(.A(A), .B(B), .RESULT(sub_result), .NEG(sub_neg));	    // 뺄셈 연산 모듈
Multiplier Multiplier_0(.A(A), .B(B), .RESULT(mul_result));			            // 곱셈 연산 모듈

reg [15:0] result_reg;	                            // 최종 연산 결과를 저장하기 위한 16비트 레지스터
reg neg_reg;		                                // 최종 연산 결과의 음수 플래그를 저장하기 위한 레지스터

assign RESULT = result_reg;	                        // 최종 연산 결과를 출력(RESULT)에 할당
assign NEG = neg_reg;	                            // 최종 연산 결과의 음수 플래그를 출력(NEG)에 할당

//OP_CODE의 값에 따라 적절한 연산 모듈의 결과를 선택하고, 결과와 음수 플래그를 업데이트 한다
always @(OP_CODE or add_result or sub_result or sub_neg or mul_result) begin
    case (OP_CODE)
        2'b00: begin	
            result_reg = add_result;	            // OP_CODE가 00일 때 덧셈 결과 할당
            neg_reg = 0;		                    // 덧셈 결과는 음수가 될 수 없기에 NEG 플래그는 0
        end
        2'b01: begin
            result_reg = { {8'b0}, sub_result };	// OP_CODE가 01일 때 뺄셈 결과 할당
            neg_reg = sub_neg;	                    // 뺄셈 연산의 음수 플래그 상태를 NEG에 할당
        end
        2'b10: begin
            result_reg = mul_result;	            // OP_CODE가 10일 때 곱셈 결과 할당
            neg_reg = 0;		                    // 곱셈 결과는 음수가 될 수 없으므로 NEG 플래그는 0
        end
        default: begin
            result_reg = 16'b0;		                // 유효하지 않은 OP_CODE일 때 0으로 결과를 초기화
            neg_reg = 0;		                    // NEG 플래그도 0으로 초기화
        end
    endcase
end


endmodule
