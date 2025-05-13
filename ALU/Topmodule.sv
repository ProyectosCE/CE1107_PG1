// ----------------------
// TopModule: conexión completa ALU + flags + visualización + PWM
// ----------------------
module Topmodule(
    input  logic [9:0] switches,      // switches[3:0] = A, switches[5:4] = B, switches[7:6] = sel
    input  logic clk,
    input  logic tx_esp,
    input  logic rst,
    output logic [6:0] seg0,          // display de 7 segmentos (HEX0)
    output logic [9:0] leds,          // leds[3:0] = flags Z, N, C, V (de derecha a izquierda)
    output logic pwm_gpio             // salida PWM para controlar transistor/motor
);

    logic [3:0] A;
    logic [1:0] B, sel;
    logic [3:0] Y;
    logic Z, N, C, V;
    logic [7:0] Outs_uart;

    // Asignación de entradas desde switches y UART
    assign A   = Outs_uart[7:4];
    assign B   = switches[5:4];
    assign sel = Outs_uart[3:2];

    // UART
    UART uart_inst(
        .clk(clk),
        .rst_n(~rst),
        .uart_rx(tx_esp),
        .Out(Outs_uart)
    );

    // ALU
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

    // Display de 7 segmentos
    HEX_SevenSeg u_display(
        .a(Y),
        .seg0(seg0)
    );

    // Flags en LEDs
    assign leds[0] = Z;
    assign leds[1] = N;
    assign leds[2] = C;
    assign leds[3] = V;
    assign leds[9:4] = 6'b0;

    // PWM controller
    pwm_controller u_pwm(
        .clk(clk),
        .rst(rst),
        .duty(Y),
        .pwm_out(pwm_gpio)
    );

endmodule
