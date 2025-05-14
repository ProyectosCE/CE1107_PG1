module mul_op(
    input  logic [3:0] A,
    input  logic [1:0] B,
    output logic [3:0] Y,
    output logic C_out
);
    // Productos parciales
    logic pp0, pp1_0, pp1_1, pp2_0, pp2_1, pp3_0, pp3_1, pp4_1;

    // Carries
    logic c1, c2, c3, c4, c5;

    // Productos parciales (bit a bit)
    assign pp0    = A[0] & B[0];
    assign pp1_0  = A[1] & B[0];
    assign pp2_0  = A[2] & B[0];
    assign pp3_0  = A[3] & B[0];

    assign pp1_1  = A[0] & B[1];
    assign pp2_1  = A[1] & B[1];
    assign pp3_1  = A[2] & B[1];
    assign pp4_1  = A[3] & B[1];

    // Y[0]
    assign Y[0] = pp0;

    // Y[1] = pp1_0 ^ pp1_1
    assign Y[1] = pp1_0 ^ pp1_1;
    assign c1   = pp1_0 & pp1_1;

    // Y[2] = pp2_0 ^ pp2_1 ^ c1
    assign Y[2] = pp2_0 ^ pp2_1 ^ c1;
    assign c2 = (pp2_0 & pp2_1) | (pp2_0 & c1) | (pp2_1 & c1);

    // Y[3] = pp3_0 ^ pp3_1 ^ c2
    assign Y[3] = pp3_0 ^ pp3_1 ^ c2;
    assign c3 = (pp3_0 & pp3_1) | (pp3_0 & c2) | (pp3_1 & c2);

    // C_out = pp4_1 ^ c3 (podés hacer más lógica si querés más precisión)
    assign C_out = pp4_1 | c3;

endmodule
