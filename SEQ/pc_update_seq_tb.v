
module pc_update_seq_tb;


    reg clk;
    reg [3:0] icode;
    reg condition;
    reg [63:0] valC, valM, valP;

    wire [63:0] updated_PC;
 
    pc_update_seq d (
        .clk(clk),
        .icode(icode),
        .condition(condition),
        .valC(valC),
        .valM(valM),
        .valP(valP),
        .updated_PC(updated_PC)
    );

  always #5 clk = ~clk;

    initial begin
        clk = 0;
        icode = 4'b0000; // Default value
        condition = 1'b0; // Default value
        valC = 64'd0;
        valM = 64'd0;
        valP = 64'd0;

        #10;
        icode = 4'b1000; // call
        valC = 64'd4460; // Set valC for call
        #10;
        icode = 4'b1001; // ret
        valM = 64'd22136; // Set valM for ret
        #10;
        icode = 4'b0111; // jXX instruction
        condition = 1'b1; // Set condition to true
        valC = 64'd39612; // Set valC for jXX
        valP = 64'd52719; // Set valP for jXX
        #10;

        $finish;
    end

 
    initial 
		$monitor("updated_PC=%d\n",updated_PC);

endmodule
