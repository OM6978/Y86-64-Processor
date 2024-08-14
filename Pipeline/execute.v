`include "ALU.v"
`timescale 1ns / 1ps

module execute ( e_valE,e_cnd, ZF, SF, OF, e_valA,  e_dstE, e_dstM,e_icode, e_stat, clk, E_icode, E_ifun, E_valA,E_valB,  E_valC, E_dstE,E_dstM,E_stat,condition);



    input clk;
    input [1:0] E_stat;
    input [63:0] E_valA, E_valB, E_valC;
    input [3:0] E_icode, E_ifun, E_dstE, E_dstM;
    input condition;

    output reg e_cnd, ZF, SF, OF;
    output reg[1:0] e_stat;
    output reg[3:0] e_dstE, e_dstM,e_icode;
    output reg[63:0] e_valA, e_valE;

    wire signed [63:0] alu_output;
    reg signed [63:0] A,B;
    reg S1,S0;
    wire overflow;



    initial begin
        e_valE = 0;
        e_cnd = 0;
        ZF = 0;
        SF = 0;
        OF = 0;
    end

    alu alu1(
        .A(A),
        .B(B),
        .out(alu_output),
        .S1(S1),
        .S0(S0),
        .overflow(overflow)
    );

   

    initial begin
        A = 0;
        B = 0;
      
        S1=0;
        S0=0;
    end


    always @(*)
    begin
         if(((e_icode == 6) && condition))
        begin

            if(alu_output==0) ZF=1;
            else ZF=0;

            if(alu_output[63] == 1) SF=1;
            else SF=0;

            if((A[63] == B[63]) && (alu_output[63] != A[63])) OF=1;
            else OF=0;
 
        end
       
    end


    always @(*)
     begin
        e_stat = E_stat;
        e_icode = E_icode;
        e_valA = E_valA;
        e_dstM = E_dstM;

        if(E_icode==2 && !e_cnd) e_dstE=15;
        else e_dstE=E_dstE;
        
        
    end
    always @(*) begin

        if(e_icode==2)//cmovxx
        begin
             A = E_valA;
            B = E_valB;
         
              S1=0;
            S0=0;
          

            if(E_ifun==0) e_cnd = 1; //uncondtional
            if(E_ifun==1)e_cnd = (SF ^ OF) | ZF;// cmovle
            if(E_ifun==2) e_cnd = SF ^ OF;// cmovl
            if(E_ifun==3) e_cnd = ZF;// cmove
            if(E_ifun==4)  e_cnd = ~ZF;// cmovne
            if(E_ifun==5) e_cnd = ~(SF ^ OF); // cmovge
            if(E_ifun==6) e_cnd = ~((SF ^ OF) | ZF);// cmovg
          
        end

        if(e_icode==3)   e_valE = E_valC; //irmovq

        if(e_icode==4) //rmmovq
        begin
           A = E_valB;
                    B = E_valC;
               
                     S1=0;
                    S0=0;
                   
        end
        if(e_icode==5)//mrmovq
        begin
           A = E_valB;
                    B = E_valC;
                   
                      S1=0;
                      S0=0;
                   
        end

        if(e_icode==6) //opq
        begin
            A = E_valB;
                    B = E_valA;
                  
                   
                     S1=E_ifun[1];
                     S0=E_ifun[0];
                  
        end

        if(e_icode==7) //jxx
        begin
          
          if(E_ifun==0)  e_cnd = 1; // unconditional
          if(E_ifun==1)  e_cnd= (SF ^ OF) | ZF;// jle
          if(E_ifun==2)  e_cnd = SF ^ OF;// jl
          if(E_ifun==3)  e_cnd = ZF;// je
          if(E_ifun==4)  e_cnd = ~ZF;// jne
          if(E_ifun==5)  e_cnd = ~(SF ^ OF); // jge
          if(E_ifun==6)  e_cnd = ~((SF ^ OF) | ZF);// jg

        end

        if(e_icode==8) //call
        begin
             A = E_valB;
                    B = -8;
                    
                     S1=0;
                    S0=0;
                   
          
        end

        if(e_icode==9)//ret
        begin
            A = E_valB;
            B = 8;
           
             S1=0;
            S0=0;
     

        end

        if(e_icode==10)//pushq
        begin
            
            A = E_valB;
            B = -8;
             S1=0;
            S0=0;
            
          
          
        end

        if(e_icode==11) //popq
        begin
              
                    A = E_valB;
                    B = 8;
                   
                     S1=0;
                    S0=0;
                    
                    
          
        end


        if(e_icode!=7 && e_icode!=3)
        begin
          e_valE = alu_output;
        end
        
    end



    
endmodule