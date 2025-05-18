// ========================================================================
// Testbench: alu_tb
// Descripción:
//     Verifica el módulo alu, que integra todas las operaciones y genera las banderas
// ========================================================================

module alu_tb();

    logic [3:0] A;
    logic [1:0] B;
    logic [1:0] sel;
    logic [3:0] Y;
    logic Z, N, C, V;

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

    initial begin
        A = 4'b0101; B = 2'b01;

        sel = 2'b00; #10; // MUL
        sel = 2'b01; #10; // SUB
        sel = 2'b10; #10; // AND
        sel = 2'b11; #10; // XOR

        A = 4'b1111; B = 2'b11;

        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;
    end

endmodule