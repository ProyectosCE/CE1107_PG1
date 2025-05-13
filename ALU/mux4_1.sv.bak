// ----------------------
// Módulo MUX 4:1 para seleccionar operación
// ----------------------

module mux4_1(
    input  logic [3:0] D0, // Multiplicación
    input  logic [3:0] D1, // Resta
    input  logic [3:0] D2, // AND
    input  logic [3:0] D3, // XOR
    input  logic [1:0] sel,
    output logic [3:0] Y
);
    logic [3:0] S0n, S1n;

    assign S0n = {4{~sel[0]}};
    assign S1n = {4{~sel[1]}};

    assign Y = (D0 & S1n & S0n) |
               (D1 & S1n & {4{ sel[0]}}) |
               (D2 & {4{ sel[1]}} & S0n) |
               (D3 & {4{ sel[1]}} & {4{ sel[0]}});
endmodule