module Subtractor(
    input [7:0] A, B,
    output reg [7:0] RESULT,
    output reg NEG
);

always @(A or B) begin
    RESULT = A - B;
    NEG = RESULT[7];
end


endmodule
