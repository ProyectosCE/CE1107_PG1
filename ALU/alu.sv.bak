// ----------------------
// Módulo ALU
// ----------------------

module alu(
    input  logic [3:0] A,
    input  logic [1:0] B,
    input  logic [1:0] sel,
    output logic [3:0] Y
);
    logic [3:0] and_result, xor_result, sub_result, mul_result;

    and_op u_and(.A(A), .B(B), .Y(and_result));
    xor_op u_xor(.A(A), .B(B), .Y(xor_result));
    sub_op u_sub(.A(A), .B(B), .Y(sub_result));
    mul_op u_mul(.A(A), .B(B), .Y(mul_result));

    mux4_1 u_mux(
        .D0(mul_result),
        .D1(sub_result),
        .D2(and_result),
        .D3(xor_result),
        .sel(sel),
        .Y(Y)
    );
endmodule