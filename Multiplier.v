module Multiplier(
    input [7:0] A, B,		//8비트 크기의 A, B 입력
    output [15:0] RESULT	//16비트 크기의 RESULT 출력
);

assign RESULT = A * B;	//A와 B가 8비트 이므로 최대 값은 255 * 255 = 65025이고 이는 16비트에 저장 할 수 있다.

endmodule
