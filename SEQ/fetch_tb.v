
module fetch_tb;

  reg clk;
  reg [63:0] PC;
  
  wire [3:0] ifun, icode, rA,rB;
  wire [63:0] valC, valP;
  wire memory_error, halt,invalid_instr;
  wire [63:0] valM;
  wire [63:0] updated_PC;
  wire condition;
  fetch dut(.clk(clk),.PC(PC),.icode(icode),.ifun(ifun),.rA(rA),
              .rB(rB),.valC(valC),.valP(valP), .memory_error(memory_error), .halt(halt), .invalid_instr(invalid_instr));

  pc_update_seq m(clk, icode, condition, valC, valM, valP,  updated_PC);            
  initial begin 
    clk=0;
    PC=64'd0;
    #10 clk=~clk;PC=updated_PC;
    #10 clk=~clk;
    #10 clk=~clk;PC=updated_PC;
    #10 clk=~clk;
    #10 clk=~clk;PC=updated_PC;
    #10 clk=~clk;
    #10 clk=~clk;PC=updated_PC;
    #10 clk=~clk;
    #10 clk=~clk;PC=updated_PC;
    #10 clk=~clk;
    #10 clk=~clk;PC=updated_PC;
    #10 clk=~clk;
    // #10 clk=~clk;PC=valP;
    // #10 clk=~clk;
    // #10 clk=~clk;PC=valP;
    // #10 clk=~clk;
    // #10 clk=~clk;PC=valP;
    // #10 clk=~clk;
    // #10 clk=~clk;PC=valP;
    // #10 clk=~clk;
    // #10 clk=~clk;PC=valP;
    // #10 clk=~clk;
    // #10 clk=~clk;PC=valP;
    // #10 clk=~clk;
    // #10 clk=~clk;PC=valP;
    // #10 clk=~clk;
     
  end 
  
  initial 
		$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d\n",clk,PC,icode,ifun,rA,rB,valC,valP);
endmodule