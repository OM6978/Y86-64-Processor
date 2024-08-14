module memory(clk,icode, valA, valB, valP, valE, valM, data_error);

input clk;
input wire [3:0] icode;
input wire [63:0] valA, valB, valP, valE;
output reg [63:0] valM;
output reg [63:0] memory [0:255];

output reg data_error=0;

always @(*)
begin   

    if(icode == 4'b0101) //mrmovq
    begin 
    if(valE>255) data_error=1;
    else valM = memory[valE]; 
    end

    else if(icode == 4'b1011) //popq
    begin 
    if(valA>255) data_error=1;
    else valM = memory[valA];
    end

    else if(icode == 4'b1001) //ret
    begin 
    if(valA>255) data_error=1;
    else valM = memory[valA]; 
    end
    else if(icode == 4'b0100) //rmmovq
    begin 
    if(valE>255) data_error=1;
    else memory[valE] = valA;
    end

    else if(icode == 4'b1000) //call
    begin 
    if(valE>255) data_error=1;
    else memory[valE] = valP; 
    end

    else if(icode ==  4'b1010) //pushq
    begin 
    if(valE>255) data_error=1;
    else memory[valE] = valA; 
    end

end

endmodule
