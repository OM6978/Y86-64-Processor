
module predict_pc( f_pc,  M_icode, W_icode,  M_valA, W_valM, F_predPC,  M_cnd, clk);

  
    input clk, M_cnd;
    input[3:0] W_icode, M_icode;
    input[63:0] F_predPC,W_valM, M_valA;

    output reg [63:0] f_pc;


initial begin
    f_pc = 0;
end
always @(*)begin 
    if(M_icode == 7)begin
        if(M_cnd==0)
        begin
        f_pc = M_valA;
        end
    end
    else if(W_icode == 9)
    begin
         f_pc = W_valM;
    end
    else 
    begin
        f_pc = F_predPC;
    end
end

endmodule 