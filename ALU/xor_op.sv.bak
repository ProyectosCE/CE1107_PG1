// ----------------------
// Módulo XOR (4 bits A, 2 bits B con replicación)
// ----------------------

module xor_op(
    input  logic [3:0] A,
    input  logic [1:0] B,
    output logic [3:0] Y
);
    assign Y[3] = A[3] ^ B[1];
    assign Y[2] = A[2] ^ B[1];
    assign Y[1] = A[1] ^ B[0];
    assign Y[0] = A[0] ^ B[0];
endmodule