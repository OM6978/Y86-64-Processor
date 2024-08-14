`timescale 1ns / 1ps

module memory (clk, M_stat,M_icode, M_valA, M_valE,M_dstE, M_dstM, m_icode,  m_valM, m_stat, m_valE, m_dstE, m_dstM);

  

    input clk;
    input [1:0] M_stat;
    input wire [3:0] M_icode,M_dstE, M_dstM;
    input wire [63:0] M_valA, M_valE;


    output reg [1:0] m_stat;
    output reg [3:0] m_icode, m_dstE, m_dstM;
    output reg [63:0] m_valE, m_valM;



    // Memory block now stores 8-bit values
    reg mem_error;
    reg [7:0] memory_block [0:255];  

    initial begin
        mem_error = 0;
        m_valM = 0; 
    end


    always @(*) begin
        if(mem_error==0) m_stat = M_stat;
        
        m_icode = M_icode;
        m_valE = M_valE;
        m_dstE = M_dstE;
        m_dstM = M_dstM;
    end

    always @(*) begin
        mem_error = 0;
       

        if(M_icode==5) //mrmovq
        begin
            if(M_valE>255) 
            begin
              mem_error=1;
              m_stat=2;
            end
            else
            begin
                  m_valM = {memory_block[(M_valE)+7],
                            memory_block[(M_valE)+6], 
                            memory_block[(M_valE)+5],
                            memory_block[(M_valE)+4], 
                            memory_block[(M_valE)+3], 
                            memory_block[(M_valE)+2], 
                            memory_block[(M_valE)+1], 
                            memory_block[M_valE]};
              
            end
            if(M_icode==9 || M_icode==11) //ret or popq
            begin
              if(M_valA>255)
              begin
                mem_error=1;
                m_stat=2;
              end
            end
            else
            begin
                m_valM = {memory_block[(M_valA)+7],
                            memory_block[(M_valA)+6], 
                            memory_block[(M_valA)+5], 
                            memory_block[(M_valA)+4], 
                            memory_block[(M_valA)+3], 
                            memory_block[(M_valA)+2], 
                            memory_block[(M_valA)+1], 
                            memory_block[M_valA]};
            end
          
        end

      
    end

    always @(posedge clk) begin
        if(M_icode==4 || M_icode==10) //rmmovq or pushq
        begin
            if(M_valE>255) 
            begin
              mem_error=1;
              m_stat=2;
            end
            else
            begin
                  {memory_block[(M_valE)+7],
                    memory_block[(M_valE)+6], 
                    memory_block[(M_valE)+5], 
                    memory_block[(M_valE)+4], 
                    memory_block[(M_valE)+3], 
                    memory_block[(M_valE)+2], 
                    memory_block[(M_valE)+1], 
                    memory_block[M_valE]} = M_valA;

                            
              
            end
            if(M_icode==8) // call
            begin
              if(M_valE>255)
              begin
                mem_error=1;
                m_stat=2;
              end
            end
            else
            begin
                {memory_block[(M_valE)+7], 
                    memory_block[(M_valE)+6], 
                    memory_block[(M_valE)+5], 
                    memory_block[(M_valE)+4], 
                    memory_block[(M_valE)+3], 
                    memory_block[(M_valE)+2], 
                    memory_block[(M_valE)+1], 
                    memory_block[M_valE]} = M_valA;
            end
          
        end


    end



endmodule