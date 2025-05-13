// ========================================================================
// Testbench: mux4_1_tb
// Descripción:
//     Verifica el módulo mux4_1, que selecciona una de cuatro entradas según sel
// ========================================================================

module mux4_1_tb();

    logic [3:0] D0, D1, D2, D3;
    logic [1:0] sel;
    logic [3:0] Y;

    mux4_1 dut(
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .sel(sel),
        .Y(Y)
    );

    initial begin
        D0 = 4'b0001;
        D1 = 4'b0010;
        D2 = 4'b0100;
        D3 = 4'b1000;

        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;
    end

endmodule