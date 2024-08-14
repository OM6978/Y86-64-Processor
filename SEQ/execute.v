
`include "alu.v"
module execute(clk, icode, ifun, valA, valB, valC, valE, condition, ZF, SF, OF);
 
input clk;
input [3:0] icode, ifun;
input [63:0] valA, valB, valC;
output reg [63:0] valE;
output reg condition, ZF, SF, OF;
reg S1,S0;
reg [1:0] control;
output reg signed [63:0] A, B, ans;

wire signed [63:0] out;
wire overflow;

alu m(A,B,out,S1,S0,overflow);
        // this is done so that whenever one of out, A or B changes we update the flags
always @(A || B || out)
    begin
        if(out==64'b0)
        begin
            ZF=1; // zero flag when the output is zero 
        end
        else
        begin
            ZF=0;
        end
        if(out[63]==1)
        begin
            SF=1; // sign flag when the output is negative
        end
        else
        begin
            SF=0;
        end
         if((A[63] == B[63]) && (A[63] != out[63]))
        begin
            OF=1; // overflow flag when overflow is detected in the output
        end
        else
        begin
            OF=0;
        end
    end

always @(*)
    begin
        condition=0;
        if(icode==4'b0011)  // irmovq V, rB
        begin
             A = valC;
            B = 64'd0;
            S0 = 0;
            S1 = 0;
        end

        else if(icode==4'b0100)   // rmmovq rA, D(rB)
        begin
            A = valC;
            B = valB;
            S0 = 0;
            S1 = 0;
        end
        else if(icode==4'b0010)    // cmovXX rA, rB
        begin
              condition = 0; 

            if(ifun==4'b0000)    // normal cmove
            begin
            condition = 1; // unconditional move instruction, and if called, we have to execute it
            end
            else if(ifun==4'b0001)   // cmovle
            begin
            if((SF^OF)|ZF)
                    condition = 1;
            end
            else if(ifun==4'b0010)   // cmovl
            begin
             if(SF^OF)
                    condition = 1;
            end
            
            else if(ifun==4'b0011)   // cmove
            begin
             if(ZF)
                    condition = 1;
            end
             else if(ifun==4'b0100)   // cmovne
            begin
             if(!ZF)
                    condition = 1;
            end
             else if(ifun==4'b0101)   // cmovge
            begin
             if(!(SF^OF))
                    condition = 1;
            end
           else if(ifun==4'b0110)   // cmovg
            begin
              if(!(SF^OF))
                begin
                    if(!ZF)
                        condition = 1;
                end
            end

            A = valA;
            B = 64'd0;
            S0 = 0;
            S1 = 0; 
        end
        else if(icode==4'b0101)    // mrmovq D(rB), rA
        begin
           A = valC;
            B = valB;
            S0 = 0;
            S1 = 0;
        end
        else if(icode==4'b0110)     // Opq rA, rB
        begin
            A = valB;
            B = valA;
            
            S1=ifun[1];
            S0=ifun[0];
        end
        else if(icode==4'b0111)    // jXX Dest
        begin
           condition = 0;
           if(ifun==4'b0000)     // jmp
        begin
              condition = 1; // unconditional jump
        end
        if(ifun==4'b0001)     // jle
        begin
               
                if((SF^OF)|ZF)
                    condition = 1;
            

        end
        if(ifun==4'b0010)     // jl
        begin
               
                if(SF^OF)
                    condition = 1;
            

        end
         if(ifun==4'b0011)     // je
        begin
               if(ZF)
                    condition = 1;
                else
                    condition = 0;
        end
        if(ifun==4'b0100)     // jne
        begin
                
                if(!ZF)
                    condition = 1;
            
        end
        if(ifun==4'b0101)     // jge
        begin
               
                if(!(SF^OF))
                    condition = 1;
            
        end
         if(ifun==4'b0110)     // jg
        begin
              
                if(!(SF^OF)&(!ZF))
                    condition = 1;
        end

        end
        else if(icode==4'b1000)    // call 
        begin
            A = -64'd8;
            B = valB;
            S0 = 0;
            S1 = 0;
            // to decrement the stack pointer by 8 on call
        end
        else if(icode==4'b1001)    // ret
        begin
             A = 64'd8;
            B = valB;
            S0 = 0;
            S1 = 0; 
            // to increment the stack pointer by 8 on ret
        end
        else if(icode==4'b1010)     // pushq rA
        begin
           A = -64'd8;
            B = valB;
            S0 = 0;
            S1 = 0; 
            // to decrement the stack pointer by 8 on pushq
        end
        else if(icode==4'b1011)     // popq rA
        begin
           A = 64'd8;
            B = valB;
            S0 = 0;
            S1 = 0; 
            // to increment the stack pointer by 8 on popq
        end

      
        valE = out;
    end
endmodule
