module decode(
            clk, 
            icode, 
            rA, rB, 
            valE, valM,valA, valB, 
            reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14
            );
 
input clk; 
input [3:0] icode, rA,rB;
input [63:0] valE, valM;
output reg [63:0] valA, valB;
output reg [63:0] reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14;


reg [63:0] reg_memory [0:14];

initial begin
    reg_memory[0] = 64'd0;        //rax
    reg_memory[1] = 64'd1;        //rcx
    reg_memory[2] = 64'd2;        //rdx
    reg_memory[3] = 64'd3;        //rbx
    reg_memory[4] = 64'd4;        //rsp
    reg_memory[5] = 64'd5;        //rbp
    reg_memory[6] = 64'd6;        //rsi
    reg_memory[7] = 64'd7;        //rdi
    reg_memory[8] = 64'd8;        //r8
    reg_memory[9] = 64'd9;        //r9
    reg_memory[10] = 64'd10;      //r10
    reg_memory[11] = 64'd11;      //r11
    reg_memory[12] = 64'd12;      //r12
    reg_memory[13] = 64'd13;      //r13
    reg_memory[14] = 64'd14;      //r14

  end


always @ (*)  
    begin
        // cmovxx rA, rB
        if(icode==4'b0010) 
        begin 
            valA = reg_memory[rA];
        end

        // rmmovq rA, D(rB)
        else if(icode==4'b0100) 
        begin 
            valA = reg_memory[rA];
            valB = reg_memory[rB];
        end
    
        // call Dest
        else if(icode==4'b1000) 
        begin 
            valB = reg_memory[4'b0100];
        end

        // ret
        else if(icode==4'b1001) 
        begin 
            valA = reg_memory[4'b0100];
            valB = reg_memory[4'b0100];
        end

        // pushq rA
        else if(icode==4'b1010) 
        begin 
            valA = reg_memory[rA];
            valB = reg_memory[4'b0100];
        end

        // mrmovq D(rB), rA
        else if(icode==4'b0101) 
        begin 
            valB = reg_memory[rB];
        end

        // Opq rA, rB
        else if(icode==4'b0110) 
        begin 
            valA = reg_memory[rA];
            valB = reg_memory[rB];
        end

        // popq rA
        else if(icode==4'b1011) 
        begin 
            valA = reg_memory[4'b0100];
            valB = reg_memory[4'b0100];
        end
     
    end

    //write back stage is also written here

always@(posedge clk)
    begin
        // cmovxx rA, rB
        if(icode==4'b0010) 
        begin 
        reg_memory[rB] = valE; 
        end

        // Opq rA, rB
        else if(icode==4'b0110) 
        begin 
            reg_memory[rB] = valE; 
        end

        // call 
        else if(icode==4'b1000) 
        begin 
            reg_memory[4'b0100] = valE; 
        end

        // ret
        else if(icode==4'b1001) 
        begin 
            reg_memory[4'b0100] = valE; 
        end

        // irmovq V, rB
        else if(icode==4'b0011) 
        begin 
            reg_memory[rB] = valE; 
        end

        // mrmovq D(rB), rA
        else if(icode==4'b0101) 
        begin 
            reg_memory[rA] = valM; 
        end

        // pushq rA
        else if(icode==4'b1010) 
        begin 
            reg_memory[4'b0100] = valE; 
        end

        // popq rA
        else if(icode==4'b1011) 
        begin 
            reg_memory[4'b0100] = valE;
            reg_memory[rA] = valM;
        end
        
    end

    always @(*) begin
        reg_file0 = reg_memory[0];
        reg_file1 = reg_memory[1];
        reg_file2 = reg_memory[2];
        reg_file3 = reg_memory[3];
        reg_file4 = reg_memory[4];
        reg_file5 = reg_memory[5];
        reg_file6 = reg_memory[6];
        reg_file7 = reg_memory[7];
        reg_file8 = reg_memory[8];
        reg_file9 = reg_memory[9];
        reg_file10 = reg_memory[10];
        reg_file11 = reg_memory[11];
        reg_file12 = reg_memory[12];
        reg_file13 = reg_memory[13];
        reg_file14 = reg_memory[14];      
    end
endmodule