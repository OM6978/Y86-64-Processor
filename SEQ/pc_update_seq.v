module pc_update_seq( clk, icode, condition, valC, valM, valP,  updated_PC);

input clk;
input [3:0] icode;
input condition;
input [63:0] valC, valM, valP;
output reg [63:0] updated_PC;

always@(*)
    begin
    if(icode == 4'b1000)// call
    begin 
       updated_PC = valC; 
    end

    else if(icode == 4'b1001) // ret
    begin 
     updated_PC = valM; 
    end

     else if(icode == 4'b0111)  // jXX instruction
    begin 
     if(condition==1)
     begin
                updated_PC = valC;
     end
     else
     begin
        updated_PC = valP;  //default value given if that condition is not met
     end

    end
    else
    begin
        updated_PC = valP;  //default value given if none of the icode values match
    end
       
    end

endmodule