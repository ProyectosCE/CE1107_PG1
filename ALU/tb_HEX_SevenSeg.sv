// ============================================================================
// Testbench: tb_hex_sevenseg
// Descripción:
//     Verifica la salida del módulo HEX_SevenSeg para todos los valores de 0 a 15.
//     Se puede observar cómo cambia la codificación de los segmentos.
// ============================================================================

`timescale 1ns/1ps

module tb_hex_sevenseg;

    // Señales
    logic [3:0] a;
    logic [6:0] seg0;

    // DUT
    HEX_SevenSeg dut (
        .a(a),
        .seg0(seg0)
    );

    // Simulación principal
    initial begin

        // Recorrer valores del 0 al 15
        integer i;
        for (i = 0; i < 16; i = i + 1) begin
            a = i[3:0];
            #20;
        end

    end

endmodule
