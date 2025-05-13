// ========================================================================
// Testbench: sub_op_tb
// Descripción:
//     Verifica el módulo sub_op, que realiza una resta A - B con complemento a dos
// ========================================================================

module sub_op_tb();

    // Entradas
    logic [3:0] A;
    logic [1:0] B;

    // Salidas
    logic [3:0] Y;
    logic C_out, V_out;

    // Instancia del módulo bajo prueba
    sub_op dut(
        .A(A),
        .B(B),
        .Y(Y),
        .C_out(C_out),
        .V_out(V_out)
    );

    // Secuencia de prueba
    initial begin
        // Caso 1: A = 0000, B = 00
        A = 4'b0000; B = 2'b00; #10;

        // Caso 2: A = 0100, B = 01
        A = 4'b0100; B = 2'b01; #10;

        // Caso 3: A = 0100, B = 10
        A = 4'b0100; B = 2'b10; #10;

        // Caso 4: A = 0011, B = 01
        A = 4'b0011; B = 2'b01; #10;

        // Caso 5: A = 0010, B = 10
        A = 4'b0010; B = 2'b10; #10;

        // Caso 6: A = 0001, B = 01
        A = 4'b0001; B = 2'b01; #10;
    end

endmodule