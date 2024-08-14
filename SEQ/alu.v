module full_adder(S,Co,A,B,C);
    input A,B,C;
    
    output S,Co;
    //O1 means A and B are euqal, O2 means A is greater than B, and O3 means B is greater than A
    wire x3,x2,x1,x0;
    wire nB1,nB2,nB3,nB0;
    not t12(nB0,B0);
    not t23(nB1,B1);
    not t34(nB2,B2);
    not t45(nB3,B3);

    wire t1,t2,t3,t4;

    xor z1(t1,A,B);
    xor z2(S,t1,C);

    and z3(t2,A,B);
    and z4(t3,t1,C);
    or z5(Co,t2,t3);

endmodule

module xormodule(A1,O1,B1);

 input wire [63:0]A1;
 input wire [63:0]B1;
 output wire[63:0]O1;
genvar i;
generate
    for (i=0 ;i<64 ;i=i+1 ) begin
        xor z6(O1[i],A1[i],B1[i]);

        
        
    end
endgenerate





endmodule


module andmodule(A1,O1,B1);

 input wire [63:0]A1;
 input wire [63:0]B1;
 output wire[63:0]O1;
 genvar i;
 generate
    for (i=0 ;i<64 ;i=i+1 ) begin
        and z7(O1[i],A1[i],B1[i]);

        
        
    end
 endgenerate
endmodule



module add_submodule(A1,S1,B1,C1,M);

    // input A3,A2,A1,A0;
    // input B3,B2,B1,B0;
    // output S0,S1,S2,S3,C4;
    // input M;
    //O1 means A and B are euqal, O2 means A is greater than B, and O3 means B is greater than A
    // wire C1,C2,C3;
    // full_adder(S0,C1,A0,B0,M);

    // full_adder(S1,C2,A1,B1,C1);

    // full_adder(S2,C3,A2,B2,C2);

    // full_adder(S3,C4,A3,B3,C3);
        

 input M;
 input wire [63:0]A1;
 input wire [63:0]B1;
 output wire[63:0]S1;
 output wire[64:1]C1;
 full_adder f1(S1[0],C1[1],A1[0],B1[0],M);
 genvar i;
 generate
    for (i=1 ;i<64 ;i=i+1 ) begin
    full_adder f2(S1[i],C1[i+1],A1[i],B1[i],C1[i]);

        
        
    end
endgenerate





endmodule

module alu(A,B,out,S1,S0,overflow);
input  S0;
input  S1;
    // output reg O0[4:0];
    // output reg O1[4:0];
    // output reg O2[2:0];
    // output reg O3[3:0];
    
 input [63:0]A;
 input [63:0]B;
 output wire [63:0]B2;
//  output wire[63:0]S1;
//  output wire[64:1]O;
    //O0 is addition O1 is subtraction O2 is comp and O3 is anding
    
    wire nS1,nS0;
    not z8(nS0,S0);
     not z9(nS1,S1);

    wire D0,D1,D2,D3;

    and z10(D0,nS0,nS1);
      and z11(D1,S0,nS1);
      and z12(D2,nS0,S1);
      and z15(D3,S0,S1);
      //add
      output wire [63:0]Oand;
      output wire [63:0]Oxor;
      output wire [63:0]OaddS;
      output wire [63:0]OsubS;
      output wire [64:1]OaddC;
      output wire [64:1]OsubC;
add_submodule  add(A,OaddS,B,OaddC,1'b0);

  genvar k;
generate
    for (k=0 ;k<64 ;k=k+1 ) begin

   xor z203(B2[k],B[k],1'b1);     
 
    end
endgenerate



add_submodule add1(A,OsubS,B2,OsubC,1'b1);

output overflow;
wire carry1;
wire carry11;
wire carry22;
wire carry2;
xor z153(carry11,OaddC[64],OaddC[63]);
xor z133(carry22,OsubC[64],OsubC[63]);
and z17(carry1, D0,carry11);
and z18(carry2, D1,carry22);
or z19(overflow,carry1,carry2);

andmodule add3(A,Oand,B);
xormodule add4(A,Oxor,B);

      output wire [63:0]Oand1;
      output wire [63:0]Oxor1;
      output wire [63:0]OaddS1;
      output wire [63:0]OsubS1;
      output wire [63:0]out;

      genvar i;
generate
    for (i=0 ;i<64 ;i=i+1 ) begin

   and z20(Oand1[i],Oand[i],D2);     
   and z21(Oxor1[i],Oxor[i],D3);     
   and z22(OaddS1[i],OaddS[i],D0);     
   and z23(OsubS1[i],OsubS[i],D1);
   or z24(out[i],Oand1[i],OaddS1[i],OsubS1[i],Oxor1[i]);     
        
    end
endgenerate


      
  endmodule