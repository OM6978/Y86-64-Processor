module fetch(clk, PC, icode, ifun, rA, rB, valC, valP, memory_error, halt, invalid_instr);

input clk;
input [63:0] PC; //program counter

output reg [3:0] icode, ifun, rA, rB;
output reg [63:0] valC, valP;
// output [63:0] updated_PC;
output reg memory_error, halt,invalid_instr;

reg [7:0] instruction_memory [0:255];
  initial begin
    $readmemb("data.txt", instruction_memory);   
    halt=0;
end
always @(*)
begin
      memory_error = 0;
      invalid_instr=0;
        if(PC > 255) 
        begin
            memory_error = 1;
        end

    ifun = instruction_memory[PC][3:0];
    icode = instruction_memory[PC][7:4];

    if(icode >= 4'b1100 || icode< 4'b0000)
    begin
        invalid_instr = 1;

    end
    else
    begin
        invalid_instr = 0;
    if(icode == 4'b0000) //  halt 
    begin
        halt=1;
        valP=PC+64'd1;
        
    end
    
    else if(icode == 4'b0110) //OPq
    begin
               
        valP = PC + 64'd2;
        rA = instruction_memory[PC+1][7:4]; 
        rB = instruction_memory[PC+1][3:0]; 
    end

    else if(icode == 4'b0111) //jXX
    begin
        valP = PC + 64'd9;
        valC[7:0] = instruction_memory[PC+1];
        valC[15:8] = instruction_memory[PC+2];
        valC[23:16] = instruction_memory[PC+3];
        valC[31:24] = instruction_memory[PC+4];
        valC[39:32] = instruction_memory[PC+5];
        valC[47:40] = instruction_memory[PC+6];
        valC[55:48] = instruction_memory[PC+7];
        valC[63:56] = instruction_memory[PC+8];
        

       
    end

    else if(icode == 4'b0001) // no operation(nop)
    begin
        valP = PC + 64'd1;
    end

    else if(icode == 4'b0100)   //rmmovq
    begin
        valP = PC + 64'd10;
           valC[7:0] = instruction_memory[PC+2];
        valC[15:8] = instruction_memory[PC+3];
        valC[23:16] = instruction_memory[PC+4];
        valC[31:24] = instruction_memory[PC+5];
        valC[39:32] = instruction_memory[PC+6];
        valC[47:40] = instruction_memory[PC+7];
        valC[55:48] = instruction_memory[PC+8];
        valC[63:56] = instruction_memory[PC+9];
       

        rA=instruction_memory[PC+1][7:4];
        rB=instruction_memory[PC+1][3:0];

    end

    else if(icode == 4'b0101)   //mrmovq
    begin
         valP = PC + 64'd10;
         
             valC[7:0] = instruction_memory[PC+2];
        valC[15:8] = instruction_memory[PC+3];
        valC[23:16] = instruction_memory[PC+4];
        valC[31:24] = instruction_memory[PC+5];
        valC[39:32] = instruction_memory[PC+6];
        valC[47:40] = instruction_memory[PC+7];
        valC[55:48] = instruction_memory[PC+8];
        valC[63:56] = instruction_memory[PC+9];
       
       

        rA = instruction_memory[PC+1][7:4];
        rB = instruction_memory[PC+1][3:0];
    end
    


    else if(icode == 4'b0010) // conditional move
    begin
        valP = PC + 64'd2;
        rA = instruction_memory[PC+1][7:4];
        rB = instruction_memory[PC+1][3:0];
    end
    else if(icode == 4'b0011) //  irmovq
    begin
          valP = PC + 64'd10;
        rA = instruction_memory[PC+1][7:4];
        rB = instruction_memory[PC+1][3:0];
              valC[7:0] = instruction_memory[PC+2];
        valC[15:8] = instruction_memory[PC+3];
        valC[23:16] = instruction_memory[PC+4];
        valC[31:24] = instruction_memory[PC+5];
        valC[39:32] = instruction_memory[PC+6];
        valC[47:40] = instruction_memory[PC+7];
        valC[55:48] = instruction_memory[PC+8];
        valC[63:56] = instruction_memory[PC+9];
       

      
    end

    else if(icode == 4'b1000) //call
    begin
        
        valP = PC + 64'd9;
        valC[7:0] = instruction_memory[PC+1];
        valC[15:8] = instruction_memory[PC+2];
        valC[23:16] = instruction_memory[PC+3];
        valC[31:24] = instruction_memory[PC+4];
        valC[39:32] = instruction_memory[PC+5];
        valC[47:40] = instruction_memory[PC+6];
        valC[55:48] = instruction_memory[PC+7];
        valC[63:56] = instruction_memory[PC+8];
       

    end

    else if(icode == 4'b1001) //ret
    begin
        valP = PC + 64'd1;
    end

    else if(icode == 4'b1010) //pushq
    begin
        valP = PC + 64'd2;
        rA = instruction_memory[PC+1][7:4]; 
        rB = instruction_memory[PC+1][3:0]; 
    end

    else if(icode == 4'b1011) //popq
    begin
        valP = PC + 64'd2;
        rA = instruction_memory[PC+1][7:4]; 
        rB = instruction_memory[PC+1][3:0]; 
    end

end
end




endmodule