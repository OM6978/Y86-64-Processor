`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "pc_update_seq.v"
`include "memory.v"

module final_tb;
 
reg clk;
wire ZF;
wire OF;
wire SF;
wire halt;
wire [3:0]icode, ifun, rA, rB;
reg [63:0]PC;
wire [63:0]updated_PC;
wire signed [63:0] valC, valP, valE, valM, valA, valB;
wire [63:0] reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14;
wire condition, invalid_instr, memory_error;
wire data_error;
reg all_ok;

reg mem_error;
always@(*)
begin
mem_error<= memory_error | data_error;
all_ok<= ~(mem_error| halt | invalid_instr);
end


fetch m(clk, PC, icode, ifun, rA, rB, valC, valP, memory_error, halt, invalid_instr);

decode m1(
            clk, 
            icode, 
            rA, rB, 
            valE, valM,valA, valB, 
            reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14
            );

  execute m2(clk, icode, ifun, valA, valB, valC, valE, condition, ZF, SF, OF);

  memory m3(clk,icode, valA, valB, valP, valE, valM, data_error);

 pc_update_seq m4(clk, icode, condition, valC, valM, valP,  updated_PC);

  initial begin    

    clk = 0;
    PC = 64'd0;
    
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    // #10 clk = ~clk; 
    // #10 clk = ~clk; PC = updated_PC;
    
forever
begin
    #10; // Toggle clock every 5 time units
    clk = ~clk;
    PC = updated_PC;
end
end

always@(*)
begin
if(halt==1)
begin
$finish;
end


end


  
  initial 
	$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d\t valM=%d valP=%d SF=%d OF=%d ZF=%d condition=%d halt=%d\t invalid instruction=%d memory error=%d all ok=%d \n", clk, PC, icode, ifun, rA, rB, valA, valB, valC, valE, valM, valP, SF, OF, ZF, condition, halt,invalid_instr,mem_error,all_ok);
  
endmodule

