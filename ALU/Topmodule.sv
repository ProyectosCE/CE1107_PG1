// ----------------------
// TopModule: conexión completa ALU + flags + visualización
// ----------------------
module Topmodule(
    input  logic [9:0] switches,      // switches[3:0] = A, switches[5:4] = B, switches[7:6] = sel
    output logic [6:0] seg0,          // display de 7 segmentos (HEX0)
    output logic [9:0] leds           // leds[3:0] = flags Z, N, C, V (de derecha a izquierda)
);
    logic [3:0] A;
    logic [1:0] B, sel;
    logic [3:0] Y;
    logic Z, N, C, V;

    // Asignación de entradas desde switches
    assign A   = switches[3:0];
    assign B   = switches[5:4];
    assign sel = switches[7:6];

    // Instancia de la ALU
    alu u_alu(
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

    // Instancia del módulo HEX para mostrar resultado
    HEX_SevenSeg u_display(
        .a(Y),
        .seg0(seg0)
    );

    // Asignación de banderas a los 4 primeros LEDs (de derecha a izquierda)
    assign leds[0] = Z;
    assign leds[1] = N;
    assign leds[2] = C;
    assign leds[3] = V;

    // Resto de LEDs no utilizados
    assign leds[9:4] = 6'b0;

endmodule
