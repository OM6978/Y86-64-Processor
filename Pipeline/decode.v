`timescale 1ns / 1ps

module decode(
    clk,  D_stat,D_icode,D_ifun,D_rA, D_rB, D_valC,D_valP,  e_dstE,   e_valE,  M_dstE,  M_valE,M_dstM, m_valM, W_stat, W_icode, W_valE,  W_valM,
    W_dstE,W_dstM,d_stat,  d_icode,  d_ifun, d_valC,d_valA, d_valB,d_dstE, d_dstM,  d_srcA, d_srcB,
    reg0,reg1, reg2, reg3,reg4,reg5,  reg6, reg7,  reg8, reg9, reg10,  reg11, reg12, reg13, reg14
);

 input clk;

    input [1:0] D_stat;
    input [3:0] D_icode,D_ifun,D_rA,D_rB;
   
    input [63:0] D_valC,D_valP;
  
    
    input [3:0] e_dstE, M_dstE, M_dstM, W_icode,W_dstM,W_dstE;
    input [63:0] e_valE,M_valE, m_valM, W_valE,W_valM;

    input [1:0] W_stat;
    
  

    
    output reg [1:0] d_stat;
    output reg [3:0] d_ifun,d_icode;
   
    output reg [63:0] d_valA,d_valB, d_valC;
    reg [63:0]r_valE;
    reg  [63:0]r_valM;
    wire [63:0]r_valA;
    wire  [63:0]r_valB;
  
    output reg [3:0] d_dstE,d_dstM,d_srcA,d_srcB;
   
    output reg [63:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14;


    


    reg [63:0] registers[0:14];

        always @(*) begin
        reg0 = registers[0];
        reg1 = registers[1];
        reg2 = registers[2];
        reg3 = registers[3];
        reg4 = registers[4];
        reg5 = registers[5];
        reg6 = registers[6];
        reg7 = registers[7];
        reg8 = registers[8];
        reg9 = registers[9];
        reg10 = registers[10];
        reg11 = registers[11];
        reg12 = registers[12];
        reg13 = registers[13];
        reg14 = registers[14];
    end

    
    always @(*) begin
        d_stat = D_stat;
        d_icode = D_icode;
        d_ifun = D_ifun;
        d_valC = D_valC;

        if(d_icode==0) //halt
        begin
                d_srcA = 15;
                d_srcB = 15;
                d_dstE = 15;
                d_dstM = 15;
        end
        else if(d_icode==1) //nop
        begin
                d_srcA = 15;
                d_srcB = 15;
                d_dstE = 15;
                d_dstM = 15;
          
        end
        else if(d_icode==2) //cmovxx
        begin
                d_srcA = D_rA;
                d_srcB = D_rB;
                d_dstE = D_rB;
                d_dstM = 15;
          
        end
        else if(d_icode==3) //irmovq
        begin
                d_srcA = 15;
                d_srcB = D_rB;
                d_dstE = D_rB;
                d_dstM = 15;
          
        end
        else if(d_icode==4) //rmmovq
        begin
                d_srcA = D_rA;
                d_srcB = D_rB;
                d_dstE = 15;
                d_dstM = 15;
          
        end
        else if(d_icode==5) //mrmovq
        begin
                d_srcA = 15;
                d_srcB = D_rB;
                d_dstE = 15;
                d_dstM = D_rA;
          
        end
         else if(d_icode==6) //opq
        begin
                d_srcA = D_rA;
                d_srcB = D_rB;
                d_dstE = D_rB;
                d_dstM = 15;
          
        end
         else if(d_icode==7) //jxx
        begin
                d_srcA = 15;
                d_srcB = 15;
                d_dstE = 15;
                d_dstM = 15;
          
        end
        else if(d_icode==8) //call
        begin
                d_srcA = 15;
                d_srcB = 4;
                d_dstE = 4;
                d_dstM = 15;
          
        end
        else if(d_icode==9) //ret
        begin
                   d_srcA = 4;
                d_srcB = 4;
                d_dstE = 4;
                d_dstM = 15;
          
        end
        else if(d_icode==10) //push
        begin
               d_srcA = D_rA;
                d_srcB = 4;
                d_dstE = 4;
                d_dstM = 15;
          
        end
        else if(d_icode==11) //pop
        begin
                 d_srcA = 4;
                d_srcB = 4;
                d_dstE = 4;
                d_dstM = D_rA;
          
        end





        if(d_srcA==15) d_valA=0;
        else d_valA= registers[d_srcA];

        if(d_srcB==15) d_valB=0;
        else d_valB= registers[d_srcB];



        if(D_icode == 8 || D_icode == 7) d_valA = D_valP;
        
        if(d_srcA != 15) begin
            
            if(e_dstE == d_srcA) 
            begin
                d_valA = e_valE;
            end
            else if(M_dstM == d_srcA) begin 
                d_valA = m_valM;
            end
            else if(M_dstE == d_srcA) begin
                 d_valA = M_valE;
            end
            else if(W_dstE == d_srcA) begin 
                d_valA = W_valE;
                 end
            else if(W_dstM == d_srcA) begin 
                 d_valA = W_valM;
                  end
        end

        if(d_srcB != 15) begin
            
            if(e_dstE == d_srcB) 
            begin
                d_valB = e_valE;
            end
            else if(M_dstM == d_srcB) 
            begin
                d_valB = m_valM;
            end
            else if(M_dstE == d_srcB) begin
                d_valB = M_valE;
            end
            else if(W_dstE == d_srcB)
            begin
                 d_valB = W_valE;
            end
            else if(W_dstM == d_srcB)
            begin
                 d_valB = W_valM;
            end
        end

    end

    //writeback
    always @(posedge clk) begin
        if(W_stat==0 && W_dstM!=15)  registers[W_dstM] = W_valM;
        if(W_stat==0 && W_dstE!=15)  registers[W_dstE] = W_valE;

    end



endmodule