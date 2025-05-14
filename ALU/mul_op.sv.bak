// ----------------------
// Módulo MUL (A x B) con 4 bits A, 2 bits B
// ----------------------

module mul_op(
    input  logic [3:0] A,
    input  logic [1:0] B,
    output logic [3:0] Y
);
    // Productos parciales
    logic p0, p1a, p1b, p2a, p2b, p2c, p3a, p3b, p3c;
    logic C2, C3;

    assign p0  = A[0] & B[0];
    assign p1a = A[1] & B[0];
    assign p1b = A[0] & B[1];

    assign p2a = A[2] & B[0];
    assign p2b = A[1] & B[1];
    assign p2c = p1a & p1b; // Carry de Y1

    assign p3a = A[3] & B[0];
    assign p3b = A[2] & B[1];
    assign p3c = p2a & p2b | p2a & p2c | p2b & p2c; // Carry de Y2

    // Y0
    assign Y[0] = p0;

    // Y1
    assign Y[1] = p1a ^ p1b;

    // Y2
    assign C2 = (p1a & p1b);
    assign Y[2] = p2a ^ p2b ^ C2;

    // Y3
    assign C3 = (p2a & p2b) | (p2a & C2) | (p2b & C2);
    assign Y[3] = p3a ^ p3b ^ C3;
endmodule