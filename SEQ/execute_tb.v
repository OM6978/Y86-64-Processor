
module execute_tb;

    reg clk;
    reg [3:0] icode, ifun;
    reg [63:0] valA, valB, valC;
    
    wire [63:0] valE;
    wire condition, ZF, SF, OF;

    execute du (
        .clk(clk),
        .icode(icode),
        .ifun(ifun),
        .valA(valA),
        .valB(valB),
        .valC(valC),
        .valE(valE),
        .condition(condition),
        .ZF(ZF),
        .SF(SF),
        .OF(OF)
    );
 
  always #5 clk = ~clk;

    initial begin
        clk = 0;
        icode = 4'b0000;
        ifun = 4'b0000;
        valA = 64'd1;
        valB = 64'd2;
        valC = 64'd3;

        #10;
        icode = 4'b0110; // Opq rA, rB
        ifun = 2'b00; // Addition
        valA = 64'd1;
        valB = 64'd2;
        #10;

        icode = 4'b0110; // Opq rA, rB
        ifun = 2'b01; // Subtraction
        valA = 64'd1;
        valB = 64'd2;
        #10;

        $finish;
    end
initial
        $monitor("valE=%d, condition=%b, ZF=%b, SF=%b, OF=%b", valE, condition, ZF, SF, OF);
    

endmodule
