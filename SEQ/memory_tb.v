

module memory_tb;
 
    reg clk;
    reg [3:0] icode;
    reg [63:0] valA;
    reg [63:0] valB;
    reg [63:0] valP;
    reg [63:0] valE;

    wire [63:0] valM;

    memory mt (
        .clk(clk),
        .icode(icode),
        .valA(valA),
        .valB(valB),
        .valP(valP),
        .valE(valE),
        .valM(valM)
    );

    always #5 clk = ~clk;

    // Stimulus
    initial begin
        clk = 0;
        icode = 4'b0000;
        valA = 64'b0;
        valB = 64'b0;
        valP = 64'b0;
        valE = 64'b0;

        #10;

        // Test case 1: mrmovq
        icode = 4'b0101;
        valE = 8'b00000001;
        #10;

        // Test case 2: popq
        icode = 4'b1011;
        valA = 8'b00000010;
        #10;

        // Test case 3: rmmovq
        icode = 4'b0100;
        valE = 8'b00000011;
        valA = 64'b1010101010101010101010101010101010101010101010101010101010101;
        #10;

        // Test case 4: call
        icode = 4'b1000;
        valE = 64'b0101010101010101010101010101010101010101010101010101010101010;
        valP = 64'b0000000011111111111111111111111111111111111111111111111111111;
        #10;

        // Test case 5: pushq
        icode = 4'b1010;
        valE = 8'b00000100;
        valA = 64'b111100001111000011110000111100001111000011110000111100001111;
        #10;

        // Test case 6: ret
        icode = 4'b1001;
        valA = 64'b0101010101010101010101010101010101010101010101010101010101010;
        #10;

        $finish;
    end


    initial 
		$monitor("clk=%d icode=%b valM=%d\n",clk,icode,valM);

endmodule
