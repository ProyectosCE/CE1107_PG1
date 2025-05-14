// ======================================================
// PWM estructural usando contador y comparador
// ======================================================

module pwm_controller (
    input  logic clk,
    input  logic rst,
    input  logic [3:0] duty,
    output logic pwm_out
);

    logic [3:0] counter;
    logic menor;

    contador4bit u_counter(
        .clk(clk),
        .rst(rst),
        .Q(counter)
    );

    comparador_menor u_cmp(
        .A(counter),
        .B(duty),
        .menor(menor)
    );

    assign pwm_out = menor;

endmodule