// ======================================================
// PWM estructural usando contador y comparador
// ======================================================


module pwm_controller (
    input  logic clk,
    input  logic rst,
    input  logic [3:0] duty,
    output logic pwm_out
);

    logic tick;
    logic [3:0] counter;
    logic menor;

    div_pwm #(
        .CLK_FREQ(50_000_000),
        .PWM_FREQ(10_000) //frecuencia de pwm
    ) u_div_pwm (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    contador4bit u_counter (
        .clk(clk),
        .rst(rst),
        .en(tick),
        .Q(counter)
    );

    comparador_menor u_cmp (
        .A(counter),
        .B(duty),
        .menor(menor)
    );

    assign pwm_out = menor;

endmodule
