module ALU(
    input [7:0] A, B,
    input [1:0] OP_CODE,    //00:덧셈, 01:뺄셈, 10:곱셈
    output [15:0] RESULT,
    output NEG
);

wire [15:0] add_result;
wire [7:0] sub_result;
wire sub_neg;
wire [15:0] mul_result;

Adder Adder_0(.A(A), .B(B), .RESULT(add_result));
Subtractor Subtractor_0(.A(A), .B(B), .RESULT(sub_result), .NEG(sub_neg));
Multiplier Multiplier_0(.A(A), .B(B), .RESULT(mul_result));

reg [15:0] result_reg;
reg neg_reg;

assign RESULT = result_reg;
assign NEG = neg_reg;

always @(OP_CODE or add_result or sub_result or sub_neg or mul_result) begin
    case (OP_CODE)
        2'b00: begin
            result_reg = add_result;
            neg_reg = 0;
        end
        2'b01: begin
            result_reg = { {8{sub_result[7]}}, sub_result };
            neg_reg = sub_neg;
        end
        2'b10: begin
            result_reg = mul_result;
            neg_reg = 0;
        end
        default: begin
            result_reg = 16'b0;
            neg_reg = 0;
        end
    endcase
end


endmodule
