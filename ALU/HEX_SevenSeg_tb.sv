// ========================================================================
// Testbench: HEX_SevenSeg_tb
// Descripción:
//     Verifica el módulo HEX_SevenSeg, que convierte un número de 4 bits en código para display
// ========================================================================

module HEX_SevenSeg_tb();

    logic [3:0] a;
    logic [6:0] seg0;

    HEX_SevenSeg dut(
        .a(a),
        .seg0(seg0)
    );

    initial begin
        a = 4'h0; #10;
        a = 4'h1; #10;
        a = 4'h2; #10;
        a = 4'h3; #10;
        a = 4'h4; #10;
        a = 4'h5; #10;
        a = 4'h6; #10;
        a = 4'h7; #10;
        a = 4'h8; #10;
        a = 4'h9; #10;
        a = 4'hA; #10;
        a = 4'hB; #10;
        a = 4'hC; #10;
        a = 4'hD; #10;
        a = 4'hE; #10;
        a = 4'hF; #10;
    end

endmodule