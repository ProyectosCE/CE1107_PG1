// ========================================================================
// Testbench: xor_op_tb
// Descripción:
//     Verifica el módulo xor_op, que realiza una operación XOR bit a bit
//     entre un operando de 4 bits (A) y un operando de 2 bits (B) replicado
// ========================================================================

module xor_op_tb();

    // Entradas
    logic [3:0] A;
    logic [1:0] B;

    // Salida
    logic [3:0] Y;

    // Instancia del módulo bajo prueba
    xor_op dut(
        .A(A),
        .B(B),
        .Y(Y)
    );

    // Secuencia de prueba
    initial begin
        // Caso 1: A = 0000, B = 00
        A = 4'b0000; B = 2'b00; #10;

        // Caso 2: A = 1111, B = 00
        A = 4'b1111; B = 2'b00; #10;

        // Caso 3: A = 1111, B = 01
        A = 4'b1111; B = 2'b01; #10;

        // Caso 4: A = 1111, B = 10
        A = 4'b1111; B = 2'b10; #10;

        // Caso 5: A = 1010, B = 01
        A = 4'b1010; B = 2'b01; #10;

        // Caso 6: A = 1100, B = 10
        A = 4'b1100; B = 2'b10; #10;
    end

endmodule