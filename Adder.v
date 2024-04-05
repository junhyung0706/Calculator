module Adder(
    input [7:0] A, B,		// 8비트 크기의 A와 B
    output [15:0] RESULT	// 16비트 크기의 RESULT
);

assign RESULT = A + B;	    // A와 B가 8비트 이므로 최대 합은 255+255=510이고 16비트 변수에 저장 가능

endmodule
