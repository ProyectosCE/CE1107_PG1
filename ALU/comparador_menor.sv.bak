// ======================================================
// Comparador de 4 bits (A < B)
// ======================================================

module comparador_menor (
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic menor
);
    logic eq0, eq1, eq2;
    logic lt0, lt1, lt2, lt3;

    assign eq0 = ~(A[3] ^ B[3]);
    assign eq1 = ~(A[2] ^ B[2]);
    assign eq2 = ~(A[1] ^ B[1]);

    assign lt3 = ~A[3] & B[3];
    assign lt2 = eq0 & ~A[2] & B[2];
    assign lt1 = eq0 & eq1 & ~A[1] & B[1];
    assign lt0 = eq0 & eq1 & eq2 & ~A[0] & B[0];

    assign menor = lt3 | lt2 | lt1 | lt0;

endmodule