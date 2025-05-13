
module HEX_SevenSeg(

	input [3:0] a, 
	output [6:0] seg0 

);

	logic D, C, B, A; 
	logic [6:0] seg0_internal;
	
	always_comb begin
	
		//Entrada separada en bits
		D = a[3];
		C = a[2];
		B = a[1];
		A = a[0];
		
		//Cada segmento
		seg0_internal[6] = (A & ~B & ~C) | (~A & B & D) | (A & ~D) | (~A & C) | (B & C) | (~B & ~D);  //a
		seg0_internal[5] = (~A & ~C & ~D) | (~A & C & D) | (A & ~C & D) | (~B & ~C) | (~B & ~D);      //b
		seg0_internal[4] = (~A & ~C) | (~A & D) | (~C & D) | (~A & B) | (A & ~B);                     //c
		seg0_internal[3] = (~A & ~B & ~D) | (~B & C & D) | (B & ~C & D) | (B & C & ~D) | (A & ~C);    //d 
		seg0_internal[2] = (~B & ~D) | (C & ~D) | (A & C) | (A & B);                                  //e
		seg0_internal[1] = (~A & B & ~C) | (~C & ~D) | (B & ~D) | (A & ~B) | (A & C);                 //f
		seg0_internal[0] = (~A & B & ~C) | (~B & C) | (C & ~D) | (A & ~B) | (A & D);                  //g
		
	end
		
	assign seg0 = ~seg0_internal;

endmodule 