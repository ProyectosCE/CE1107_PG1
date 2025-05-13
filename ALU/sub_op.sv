module sub_op(
    input  logic [3:0] A,
    input  logic [1:0] B,
    output logic [3:0] Y,
    output logic C_out,
    output logic V_out
);
    logic [3:0] B_ext, B_inv;
    logic C0, C1, C2, C3, C4;

    assign B_ext = {2'b00, B};
    assign B_inv = ~B_ext;
    assign C0 = 1'b1;

    assign Y[0] = A[0] ^ B_inv[0] ^ C0;
    assign C1 = (A[0] & B_inv[0]) | (A[0] & C0) | (B_inv[0] & C0);

    assign Y[1] = A[1] ^ B_inv[1] ^ C1;
    assign C2 = (A[1] & B_inv[1]) | (A[1] & C1) | (B_inv[1] & C1);

    assign Y[2] = A[2] ^ B_inv[2] ^ C2;
    assign C3 = (A[2] & B_inv[2]) | (A[2] & C2) | (B_inv[2] & C2);

    assign Y[3] = A[3] ^ B_inv[3] ^ C3;
    assign C4 = (A[3] & B_inv[3]) | (A[3] & C3) | (B_inv[3] & C3);

    assign C_out = C4;
    assign V_out = C3 ^ C4;
endmodule
