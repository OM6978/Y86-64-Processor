`timescale 1ns / 1ps

module control( clk,d_srcA, d_srcB, D_icode, E_dstM, E_icode,  e_cnd,M_icode, W_stat, m_stat,F_stall, D_bubble, D_stall, E_bubble, condition, M_bubble,  W_stall); 


    input clk, e_cnd;
    input [3:0] d_srcA, d_srcB, D_icode, E_dstM, E_icode, M_icode;
    input [1:0] W_stat, m_stat;

    output reg F_stall, D_bubble, D_stall, E_bubble, condition, M_bubble, W_stall;
 

initial begin
    F_stall = 0;
    D_bubble = 0;
    D_stall = 0;
    E_bubble = 0;
    condition = 0;
    M_bubble = 0;
    W_stall = 0;
end

always @(*) begin
    //F_stall conditions 
    if((D_icode == 9 || E_icode == 9 || M_icode == 9) || ((E_icode == 5 || E_icode == 11) && (E_dstM == d_srcA || E_dstM == d_srcB)))   F_stall = 1;
    else F_stall=0;
   

    //D_stall conditions 
    if((E_icode == 5 || E_icode == 11) && (E_dstM == d_srcA || E_dstM == d_srcB)) D_stall = 1;
    else D_stall=0;

    //D_bubble conditions
    if((E_icode == 7 && !e_cnd) || (!((E_icode == 5 || E_icode == 11) && (E_dstM == d_srcA || E_dstM == d_srcB)) && (D_icode == 9 || E_icode == 9 || M_icode == 9)))  D_bubble = 1;
    else D_bubble=0;

    //E_bubble conditions
    if((E_icode == 7 && !e_cnd)|| ((E_icode == 5 || E_icode == 11)&& (E_dstM == d_srcA || E_dstM == d_srcB))) E_bubble = 1;
    else E_bubble = 0;
  

    //M_bubble conditions 
    if((m_stat == 1 || m_stat == 2 || m_stat == 3) || (W_stat == 1 || W_stat == 2 || W_stat == 3)) M_bubble = 1;
    else M_bubble = 0; 
    
    //W_stall conditions 
    if(W_stat == 1 || W_stat == 2 || W_stat == 3)  W_stall = 1;
    else W_stall=0;
   

    //condition's conditions 
    if((E_icode == 6) && !(m_stat!=0) && !(W_stat != 0)) condition = 1;
    else condition = 0; 
    
    
end
endmodule