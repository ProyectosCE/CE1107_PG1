// ========================================================================
// Testbench: mul_op_tb
// Descripción:
//     Verifica el módulo mul_op, que realiza una multiplicación entre A (4 bits) y B (2 bits)
// ========================================================================

module mul_op_tb();

    // Entradas
    logic [3:0] A;
    logic [1:0] B;

    // Salidas
    logic [3:0] Y;
    logic C_out;

    // Instancia del módulo bajo prueba
    mul_op dut(
        .A(A),
        .B(B),
        .Y(Y),
        .C_out(C_out)
    );

    // Secuencia de prueba
    initial begin
        A = 4'b0000; B = 2'b00; #10;
        A = 4'b0001; B = 2'b01; #10;
        A = 4'b0011; B = 2'b01; #10;
        A = 4'b0101; B = 2'b10; #10;
        A = 4'b0111; B = 2'b11; #10;
        A = 4'b1111; B = 2'b11; #10;
    end

endmodule