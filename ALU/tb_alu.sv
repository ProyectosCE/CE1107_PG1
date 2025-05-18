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
    logic [1:0] sel;

    // Salidas
    logic [3:0] Y;
    logic Z, N, C, V;

    // DUT
    alu dut(
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

    // Prueba principal
    initial begin

        // Prueba 1: A=0101, B=01 (MUL, SUB, AND, XOR)
        A = 4'b0101; B = 2'b01;
        sel = 2'b00; #20;  // MUL
        sel = 2'b01; #20;  // SUB
        sel = 2'b10; #20;  // AND
        sel = 2'b11; #20;  // XOR

        // Prueba 2: A=1111, B=11 (desbordamiento posible)
        A = 4'b1111; B = 2'b11;
        sel = 2'b00; #20;
        sel = 2'b01; #20;
        sel = 2'b10; #20;
        sel = 2'b11; #20;

        // Prueba 3: A=0000, B=00 (cero)
        A = 4'b0000; B = 2'b00;
        sel = 2'b00; #20;
        sel = 2'b01; #20;
        sel = 2'b10; #20;
        sel = 2'b11; #20;

    end

endmodule
