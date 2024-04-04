module Subtractor(
    input [7:0] A, B,
    output reg [7:0] RESULT,
    output reg NEG
);

always @(A or B) begin
	if (A > B) begin
		RESULT = A - B;
		NEG = 0;
	end
	else begin
		RESULT = B - A;
		NEG = 1;
	end
end

endmodule
