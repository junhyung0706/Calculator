module testbench();

reg clk, reset;
reg [17:0] DIN;
wire [15:0] RESULT;
wire NEG;

// Calculator 모듈 인스턴스화
Calculator Calculator_0(
    .clk(clk),
    .reset(reset),
    .DIN(DIN),
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
    DIN = 18'b00_00000000_00000000;
    #10 DIN = 18'b00_00000000_01011101;
    #10 DIN = 18'b00_11000010_11110110;
    #10 DIN = 18'b01_11001100_00000000;
    #10 DIN = 18'b10_10000110_01011001;
    #10 DIN = 18'b01_00110110_10011011;
    #10 DIN = 18'b01_00010010_00000111;
    #10 DIN = 18'b10_11010000_00000000;
    #10 DIN = 18'b00_01010101_10101010;
    #10 DIN = 18'b10_00000000_00000000;
    #10 DIN = 18'b00_00000000_00000000;
    #300 $stop;
end

endmodule
