// ========================================================================
// Testbench: Topmodule_tb
// Descripción:
//     Verifica el módulo topmodule completo: entradas A, B, sel; salida a display y LEDs
// ========================================================================

module Topmodule_tb();

    logic [9:0] switches;
    logic [6:0] seg0;
    logic [9:0] leds;

    topmodule dut(
        .switches(switches),
        .seg0(seg0),
        .leds(leds)
    );

    initial begin
        // A = 0101, B = 01, sel = 00 (MUL)
        switches = 10'b00_01_0101; #10;

        // sel = 01 (SUB)
        switches = 10'b01_01_0101; #10;

        // sel = 10 (AND)
        switches = 10'b10_01_0101; #10;

        // sel = 11 (XOR)
        switches = 10'b11_01_0101; #10;

        // A = 1111, B = 11
        switches = 10'b00_11_1111; #10;
        switches = 10'b01_11_1111; #10;
        switches = 10'b10_11_1111; #10;
        switches = 10'b11_11_1111; #10;
    end

endmodule