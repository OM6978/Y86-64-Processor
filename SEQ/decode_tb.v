

module decode_tb;
 
    reg clk;
    reg [3:0] icode;
    reg [3:0] rA;
    reg [3:0] rB;
    reg [63:0] valE;
    reg [63:0] valM;

    wire [63:0] valA;
    wire [63:0] valB;

    decode u (
        .clk(clk),
        .icode(icode),
        .rA(rA),
        .rB(rB),
        .valE(valE),
        .valM(valM),
        .valA(valA),
        .valB(valB)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        icode = 4'b0000;
        rA = 4'b0000;
        rB = 4'b0000;
        valE = 64'b0;
        valM = 64'b0;

        #10;

        // Test case 1: cmovxx rA, rB
        icode = 4'b0010;
        rA = 4'b0001;
        rB = 4'b0010;
        valE = 64'b1010101010101010;
        valM = 64'b0;
        #10;

        // Test case 2: Opq rA, rB
        icode = 4'b0110;
        rA = 4'b0011;
        rB = 4'b0100;
        valE = 64'b0101010101010101;
        valM = 64'b0;
        #10;
        $finish;

end
initial
	$monitor("clk=%d icode=%b rA=%b rB=%b valA=%d valB=%d valE=%d valM=%d\n", clk, icode, rA, rB, valA, valB, valE, valM);

    

endmodule
