// ========================================================================
// Testbench: alu_tb
// Descripción:
//     Verifica el módulo ALU estructural con operaciones:
//     00: MUL, 01: SUB, 10: AND, 11: XOR
//     Además valida banderas: Z, N, C, V
// ========================================================================

`timescale 1ns/1ps

module alu_tb;

    // Entradas
    logic [3:0] A;
    logic [1:0] B;
    logic [1:0] S;

    // Salidas
    logic [3:0] Y;
    logic Z, N, C, V;

    // DUT
    alu dut(
        .A(A),
        .B(B),
        .sel(S),
        .Y(Y),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

    // Prueba principal
    initial begin

        // Prueba 1: A=0101, B=01 (MUL, SUB, AND, XOR)
        A = 4'b0101; B = 2'b01; S = 2'b00; #20;  // MUL
        S = 2'b01; #20;  // SUB
        S = 2'b10; #20;  // AND
        S = 2'b11; #20;  // XOR

        // Prueba 2: A=1111, B=11 (desbordamiento posible)
        A = 4'b1111; B = 2'b11;
        S = 2'b00; #20;
        S = 2'b01; #20;
        S = 2'b10; #20;
        S = 2'b11; #20;

        // Prueba 3: A=0000, B=00 (cero)
        A = 4'b0000; B = 2'b00;
        S = 2'b00; #20;
        S = 2'b01; #20;
        S = 2'b10; #20;
        S = 2'b11; #20;

    end

endmodule
