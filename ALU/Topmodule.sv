// ----------------------
// TopModule: conexión completa ALU + flags + visualización
// ----------------------
module Topmodule(
    input  logic [9:0] switches,      // switches[3:0] = A, switches[5:4] = B, switches[7:6] = sel
	 input logic clk,
	 input tx_esp,
	 input rst,
	 input [3:0] ABCD,
    output logic [6:0] seg0,          // display de 7 segmentos (HEX0)
    output logic [9:0] leds,         // leds[3:0] = flags Z, N, C, V (de derecha a izquierda)
	 output logic pwm_gpio
);
    logic [3:0] A;
    logic [1:0] B, sel;
    logic [3:0] Y;
    logic Z, N, C, V;
	 logic [7:0] Outs_uart;

    // Asignación de entradas desde switches
    assign A   = Outs_uart[7:4];
    assign B   = switches[5:4];
    assign sel = Outs_uart[3:2];
	 
	logic [1:0] four_two_out;
		
	Enco_Four_Two insenco(
	.A(ABCD),
	.B(four_two_out)

	); 
	 
	UART uart_inst(
		.clk(clk),              // Reloj FPGA (50 MHz)
		.uart_rx(tx_esp),          // Entrada UART RX desde Arduino
		.Out(Outs_uart)         // salida conectada a esp
	);


    // Instancia de la ALU
    alu u_alu(
        .A(A),
        .B(four_two_out),
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
	 
	 
	     // PWM controller
    pwm_controller u_pwm(
        .clk(clk),
        .rst(rst),
        .duty(Y),
        .pwm_out(pwm_gpio)
    );


endmodule
