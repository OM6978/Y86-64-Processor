`timescale 1ns / 1ps

`include "predict.v"


module fetch ( f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, clk, f_pc, f_predPC, f_stat,M_icode, W_icode,M_valA, W_valM, F_predPC, M_cnd);

    input clk;
 
    
    input [3:0] M_icode, W_icode;
    input[63:0] M_valA, W_valM, F_predPC, f_pc;
    input M_cnd;
    output reg [1:0] f_stat;
    output reg[3:0] f_icode, f_ifun,f_rA, f_rB;
    output reg[63:0] f_valC, f_valP,f_predPC;
    reg [7:0] instruction_memory[0:255];

    predict_pc ps(f_pc,M_icode,W_icode,M_valA,W_valM, F_predPC,  M_cnd, clk);

 
    initial begin
        $readmemb("data.txt", instruction_memory);
      
        f_icode = 0;
        f_ifun = 0;
        
        f_rA = 0;
        f_rB = 0;


        f_valC = 0;
        f_valP = 0;

        f_stat = 0; 
        f_predPC = 0;
    end

    always @(*) begin


        if(f_icode==7 || f_icode==8)  f_predPC = f_valC;
        else f_predPC = f_valP;

    
    end
    always @(negedge clk) begin
        
        if(f_pc > 255 || f_pc<0) f_stat = 2; 
           
       

        f_icode = instruction_memory[f_pc][7:4];
        f_ifun = instruction_memory[f_pc][3:0];

         
         if(f_icode >= 4'b1100 || f_icode< 4'b0000)  f_stat = 3;   // invalid_instr = 1;
           
           
        if(f_icode==0) //halt
        begin
             
             f_stat = 1;

        end

        else if(f_icode==1) //nop
        begin
           
                 f_valP = f_pc + 1;
        end

        else if(f_icode==2) //cmovxx
        begin
            f_rA = instruction_memory[f_pc + 1][7:4];
            f_rB = instruction_memory[f_pc + 1][3:0];
            f_valP = f_pc + 2;
        end
          else if(f_icode==3) //irmovq
        begin
          
            f_valC[7:0] = instruction_memory[f_pc+2];
            f_valC[15:8] = instruction_memory[f_pc+3];
            f_valC[23:16] = instruction_memory[f_pc+4];
            f_valC[31:24] = instruction_memory[f_pc+5];
            f_valC[39:32] = instruction_memory[f_pc+6];
            f_valC[47:40] = instruction_memory[f_pc+7];
            f_valC[55:48] = instruction_memory[f_pc+8];
            f_valC[63:56] = instruction_memory[f_pc+9];

           
            f_rA = instruction_memory[f_pc+1][7:4];
            f_rB = instruction_memory[f_pc + 1][3:0];
            f_valP = f_pc + 10;
        end
        else if(f_icode==4) //rmmovq
        begin
             f_valC[7:0] = instruction_memory[f_pc+2];
            f_valC[15:8] = instruction_memory[f_pc+3];
            f_valC[23:16] = instruction_memory[f_pc+4];
            f_valC[31:24] = instruction_memory[f_pc+5];
            f_valC[39:32] = instruction_memory[f_pc+6];
            f_valC[47:40] = instruction_memory[f_pc+7];
            f_valC[55:48] = instruction_memory[f_pc+8];
            f_valC[63:56] = instruction_memory[f_pc+9];


                f_rA = instruction_memory[f_pc+1][7:4];
                f_rB = instruction_memory[f_pc+1][3:0];
                f_valP = f_pc + 10;

        end

        else if(f_icode==5) //mrmovq
        begin
                       f_valC[7:0] = instruction_memory[f_pc+2];
            f_valC[15:8] = instruction_memory[f_pc+3];
            f_valC[23:16] = instruction_memory[f_pc+4];
            f_valC[31:24] = instruction_memory[f_pc+5];
            f_valC[39:32] = instruction_memory[f_pc+6];
            f_valC[47:40] = instruction_memory[f_pc+7];
            f_valC[55:48] = instruction_memory[f_pc+8];
            f_valC[63:56] = instruction_memory[f_pc+9];


                f_rA = instruction_memory[f_pc+1][7:4];
                f_rB = instruction_memory[f_pc+1][3:0];
                f_valP = f_pc + 10;
        end
        else if(f_icode==6) //opq
        begin
                f_rA = instruction_memory[f_pc+1][7:4]; 
                f_rB = instruction_memory[f_pc+1][3:0];
                f_valP = f_pc + 2;

        end
        else if(f_icode==7) //jxx
        begin
            
             f_valP = f_pc + 9;
            f_valC[7:0] = instruction_memory[f_pc+1];
            f_valC[15:8] = instruction_memory[f_pc+2];
            f_valC[23:16] = instruction_memory[f_pc+3];
            f_valC[31:24] = instruction_memory[f_pc+4];
            f_valC[39:32] = instruction_memory[f_pc+5];
            f_valC[47:40] = instruction_memory[f_pc+6];
            f_valC[55:48] = instruction_memory[f_pc+7];
            f_valC[63:56] = instruction_memory[f_pc+8];

        end
        else if(f_icode==8) //call
        begin
            f_valC[7:0] = instruction_memory[f_pc+1];
            f_valC[15:8] = instruction_memory[f_pc+2];
            f_valC[23:16] = instruction_memory[f_pc+3];
            f_valC[31:24] = instruction_memory[f_pc+4];
            f_valC[39:32] = instruction_memory[f_pc+5];
            f_valC[47:40] = instruction_memory[f_pc+6];
            f_valC[55:48] = instruction_memory[f_pc+7];
            f_valC[63:56] = instruction_memory[f_pc+8];
                f_valP = f_pc + 9;


        end
        else if(f_icode==10) //pushq
        begin
              f_rA = instruction_memory[f_pc+1][7:4]; 
                f_rB = instruction_memory[f_pc+1][3:0]; 
               
                f_valP = f_pc + 2;

        end

        else if(f_icode==11) //popq
          begin
              f_rA = instruction_memory[f_pc+1][7:4]; 
                f_rB = instruction_memory[f_pc+1][3:0]; 
               
                f_valP = f_pc + 2;

        end


    end
          // HLT=1
         // ADR=2
         //INS=3
         // AOK=4
    
    
    

    
endmodule 
