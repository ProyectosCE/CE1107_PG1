module pwm_controller (
    input  logic clk,           // 50 MHz
    input  logic rst,
    input  logic [3:0] duty,    // 0 a 15
    output logic pwm_out
);

    logic clk_div;
    logic [3:0] counter;
    logic duty_pick;

    // Divisor de reloj: genera ticks a 10kHz
    clk_div_50M_to_10K clk_div_inst(
        .clk_50MHz(clk),
        .clk_out_10k(clk_div)
    );

    // Contador de 4 bits: cuenta de 0 a 15
    contador4bit cont_inst(
        .clk(clk_div),
        .rst(rst),
        .en(1'b1),       // contar siempre
        .Q(counter)
    );

    // Comparador: genera señal alta si counter < duty
    comparador_menor comp_inst(
        .A(counter),
        .B(duty),
        .menor(duty_pick)
    );

    // Salida PWM
    assign pwm_out = duty_pick;

endmodule
