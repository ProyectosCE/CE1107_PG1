// ----------------------
// Módulo ALU con flags
// ----------------------
module alu(
    input  logic [3:0] A,
    input  logic [1:0] B,
    input  logic [1:0] sel,
    output logic [3:0] Y,
    output logic Z, N, C, V
);
    logic [3:0] and_result, xor_result, sub_result, mul_result;
    logic sub_C, sub_V, mul_C;
    logic sel0n, sel1n;
    logic C0, C1;

    and_op u_and(.A(A), .B(B), .Y(and_result));
    xor_op u_xor(.A(A), .B(B), .Y(xor_result));
    sub_op u_sub(.A(A), .B(B), .Y(sub_result), .C_out(sub_C), .V_out(sub_V));
    mul_op u_mul(.A(A), .B(B), .Y(mul_result), .C_out(mul_C));

    mux4_1 u_mux(
        .D0(mul_result),
        .D1(sub_result),
        .D2(and_result),
        .D3(xor_result),
        .sel(sel),
        .Y(Y)
    );

    assign Z = ~(Y[3] | Y[2] | Y[1] | Y[0]);
    assign N = Y[3];

    assign sel0n = ~sel[0];
    assign sel1n = ~sel[1];

    assign C0 = sel1n & sel0n & mul_C;
    assign C1 = sel1n & sel[0] & sub_C;
    assign C = C0 | C1;

    assign V = sel1n & sel[0] & sub_V;
endmodule