module Enco_Four_Two(
	input [3:0] A,
	output [1:0] B
);

	assign B[0] = A[3] | A[1]; 
	assign B[1] = A[3] | A[2];


endmodule 