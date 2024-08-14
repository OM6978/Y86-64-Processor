`timescale 1ns / 1ps

`include "control.v"
`include "fetch_pc.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"

module pipeline;
    
    


    wire F_stall, D_bubble, D_stall, E_bubble, M_bubble, W_stall;
    reg [63:0] F_predPC;
    wire [63:0] f_predPC;
    wire [1:0] f_stat;
    wire [3:0] f_icode, f_ifun;
    wire [3:0] f_rA, f_rB;
    wire [63:0] f_valC, f_valP, f_pc;
    reg [3:0] W_icode, M_icode;
    reg [63:0] W_valM, M_valA;
    reg  M_cnd;
    reg [1:0] D_stat;
    reg [3:0] D_icode, D_ifun,D_rA, D_rB;
    reg [63:0] D_valC, D_valP;
    wire [1:0] d_stat;
    wire[3:0] d_icode, d_ifun;
    wire[63:0] d_valC, d_valB, d_valA;
    wire[3:0] d_srcA, d_srcB, d_dstE, d_dstM;
    reg [1:0] E_stat;
    reg [3:0] E_icode;
    reg [3:0] E_ifun;
    reg [63:0] E_valC, E_valB, E_valA;
    reg [3:0] E_srcA, E_srcB, E_dstE, E_dstM;
    wire [3:0] e_icode;
    wire [1:0] e_stat;
    wire [3:0] e_dstE, e_dstM;
    wire [63:0] e_valA, e_valE;
    reg [1:0] M_stat;
    reg[63:0] M_valE;
    reg[3:0] M_dstE; 
    reg[3:0] M_dstM;
    wire [1:0] m_stat;
    wire [3:0] m_icode;
    wire [3:0] m_dstE;
    wire [3:0] m_dstM;
    wire [63:0] m_valE;
    wire [63:0] m_valM;
    reg [63:0] W_valE;
    reg [1:0] W_stat;
    reg [3:0] W_dstE;
    reg [3:0] W_dstM;
    wire  e_cnd, ZF, SF, OF;
    reg clk;
    reg stat;
    wire [63:0] reg0,reg1,reg2, reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14;

  
   control c( clk, d_srcA, d_srcB, D_icode, E_dstM, E_icode,   e_cnd,  M_icode, W_stat, m_stat,  F_stall, D_bubble, D_stall,
    E_bubble,  condition, M_bubble, W_stall); 



fetch f(f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,clk,f_pc,f_predPC,f_stat,M_icode,W_icode,M_valA,W_valM, F_predPC, M_cnd);

 
decode df(clk,D_stat, D_icode,D_ifun,D_rA,  D_rB,D_valC, D_valP, e_dstE,e_valE,M_dstE,M_valE, M_dstM,m_valM,W_stat, W_icode,
             W_valE,W_valM,W_dstE,W_dstM, d_stat,d_icode,d_ifun,d_valC, d_valA,d_valB,d_dstE,d_dstM,d_srcA,d_srcB,
            reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14);

 execute wr(e_valE,e_cnd, ZF, SF, OF,e_valA,e_dstE, e_dstM,e_icode,e_stat,clk,E_icode,E_ifun, E_valA,E_valB,E_valC,E_dstE, E_dstM,E_stat,condition);



memory mg(clk,M_stat,M_icode,M_valA,M_valE,M_dstE,M_dstM,m_icode, m_valM,m_stat,m_valE,m_dstE,m_dstM);





    always @(posedge clk) 
    begin
   
    if(F_stall==0)
    begin
     F_predPC = f_predPC; 
    end
    end


      always @(posedge clk )
       begin
        
        if(D_stall == 0) 
        begin
            
        

        if(D_bubble == 1) 
        begin
            D_stat <= 0;
            D_icode <= 1;
            D_ifun <= 0;
            D_rA <= 15;
            D_rB <= 15;
            D_valC <= 0;
            D_valP <= 0;
          
        end

        else if(f_stat != 0) begin
            D_stat <= f_stat;
            D_icode <= 0;
            D_ifun <= 0;
            D_rA <= 15;
            D_rB <= 15;
            D_valC <= 0;
            D_valP <= 0;
            
        end

        else begin
            D_stat <= f_stat;
            D_icode <= f_icode;
            D_ifun <= f_ifun;
            D_rA <= f_rA;
            D_rB <= f_rB;
            D_valC <= f_valC;
            D_valP <= f_valP;
           
        end
       end
    end

    
always @ (posedge clk) begin
    
    if(E_bubble==1)
    begin
       
        E_stat <= 0;
        E_valC <= 0;
        E_valB <= 0;
        E_valA <= 0;
        E_icode <= 1;
        E_dstE <= 15;
        E_dstM <= 15;
        E_srcA <= 15;
        E_srcB <= 15;

    end

    else 
    begin
         E_stat <= d_stat;
        E_valC <= d_valC;
        E_valB <= d_valB;
        E_valA <= d_valA;
        E_icode <= d_icode;
        E_ifun <= d_ifun;
        E_dstE <= d_dstE;
        E_dstM <= d_dstM;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB;
        
    end

end


always @(posedge clk) begin
    
    if(M_bubble==0)
     begin
        M_stat <= e_stat;
        M_cnd <= e_cnd;
        M_valE <= e_valE;
        M_valA <= e_valA;
        M_icode <= e_icode;
        M_dstE <= e_dstE;
        M_dstM <= e_dstM;
    end
    
    else begin
        M_stat <= 0;
        M_cnd <= 0;
        M_valE <= 0;
        M_valA <= 0;
        M_icode <= 1;
        M_dstE <= 15;
        M_dstM <= 15;
    end
end


always @(posedge clk ) begin
    
    if(W_stall==0) 
    begin
        W_stat <= m_stat;
        W_icode <= m_icode;
        W_valE <= m_valE;
        W_valM <= m_valM;
        W_dstE <= m_dstE;
        W_dstM <= m_dstM;
    end
end



    initial begin
        clk = 0;
        forever 
        begin
            #10;
            clk = ~clk;
        end
    end

    always @(*) 
    begin
        stat = W_stat;
        if(stat == 1 || stat == 2 || stat == 3) $finish;
    
    end


    initial begin
    
        $monitor("clk = %b, f_pc = %d, f_icode = %d, f_ifun = %d, f_rA = %d, f_rB = %d, D_icode = %d, D_ifun = %d, D_rA = %d, D_rB = %d, D_valP = %d, d_icode = %d, d_ifun = %d, d_valA = %d, d_valB = %d, d_valC = %d, d_srcA = %d, d_srcB = %d, d_dstM = %d, d_dstE = %d, E_icode = %d, E_ifun = %d, E_valA = %d, E_valB = %d, E_valC = %d, E_srcA = %d, E_srcB = %d, E_dstM = %d, E_dstE = %d, e_valE = %d , reg[0] = %d, reg[1] = %d, reg[2] = %d, reg[3] = %d, reg[4] = %d, reg[6] = %d, reg[7] = %d", 
        clk, f_pc, f_icode, f_ifun, f_rA, f_rB, D_icode, D_ifun, D_rA, D_rB, D_valP, d_icode, d_ifun, d_valA, d_valB, d_valC, d_srcA, d_srcB, d_dstM, d_dstE, E_icode, E_ifun, E_valA, E_valB, E_valC, E_srcA, E_srcB, E_dstM, E_dstE, e_valE,
        reg0, reg1, reg2, reg3, reg4, reg6, reg7);
    

    
    end

endmodule