module Subtractor(
    input [7:0] A, B,		// 8비트 크기의 A, B
    output reg [7:0] RESULT,	// 8비트 크기의 RESULT
    output reg NEG		// 1비트 크기의 연산결과의 부호를 판단하는 변수. 음수일 때 1이 되고 그렇지 않으면 0이다.
);

always @(A or B) begin
	if (A > B) begin		// 연산 결과가 양수일 경우
		RESULT = A - B;
		NEG = 0;
	end
	else begin		// 연산 결과가 음수인 경우
		RESULT = B - A;	// 절대 값을 RESULT에 대입
		NEG = 1;
	end
end

endmodule
