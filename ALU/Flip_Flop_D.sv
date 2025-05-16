module Flip_Flop_D (
    input  logic D,
    input  logic clk,
    input  logic rst,  // Reset asincrónico activo en alto
    output logic Q
);
    // Señales internas
    logic not_clk, not_D;
    logic Sm, Rm, Se, Re;
    logic Qm, Qmn;  // Maestro
    logic Qs, Qsn;  // Esclavo (salida final)

    // Inversores
    assign not_clk = ~clk;
    assign not_D   = ~D;

    // Latch maestro (nivel bajo activo, con reset)
    assign Sm = D & not_clk;
    assign Rm = (not_D & not_clk) | rst;  // reset fuerza R
    assign Qm  = ~(Rm | Qmn);
    assign Qmn = ~(Sm | Qm);

    // Latch esclavo (nivel alto activo, con reset)
    assign Se = Qm & clk;
    assign Re = (~Qm & clk) | rst;  // reset fuerza R
    assign Qs  = ~(Re | Qsn);
    assign Qsn = ~(Se | Qs);

    assign Q = Qs;

endmodule