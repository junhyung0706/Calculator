module tb_alu();

reg clk, reset;
reg [7:0] A, B;
reg [1:0] OP_CODE;
wire [15:0] RESULT;
wire NEG;

// Calculator 모듈 인스턴스화
ALU ALU_0(
    .A(A),
    .B(B),
    .OP_CODE(OP_CODE),
    .RESULT(RESULT),
    .NEG(NEG)
);

// 클럭 생성
initial clk = 0;
always #5 clk = ~clk;

initial begin
    reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    OP_CODE <= 2'b00;
    A <= 8'b00000000;
    B <= 8'b00000000;
    
    #10
    OP_CODE <= 2'b00;
    A <= 8'b00000000;
    B <= 8'b01011101;
    
    #10
    OP_CODE <= 2'b00;
    A <= 8'b11000010;
    B <= 8'b11110110;

    #10
    OP_CODE <= 2'b01;
    A <= 8'b11001100;
    B <= 8'b00000000;

    #10
    OP_CODE <= 2'b10;
    A <= 8'b10000110;
    B <= 8'b01011001;

    #10
    OP_CODE <= 2'b01;
    A <= 8'b00110110;
    B <= 8'b10011011;
    
    #10
    OP_CODE <= 2'b10;
    A <= 8'b00010010;
    B <= 8'b00000111;
    
    #10
    OP_CODE <= 2'b10;
    A <= 8'b11010000;
    B <= 8'b00000000;
    
    #10
    OP_CODE <= 2'b00;
    A <= 8'b01010101;
    B <= 8'b10101010;
    
    #10
    OP_CODE <= 2'b10;
    A <= 8'b00000000;
    B <= 8'b00000000;
    
    #10
    OP_CODE <= 2'b00;
    A <= 8'b00000000;
    B <= 8'b00000000;

    #300 $stop;
end

endmodule
