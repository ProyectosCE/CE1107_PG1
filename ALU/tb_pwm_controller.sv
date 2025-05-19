// ============================================================================
// Testbench: tb_pwm_controller
// Descripción:
//     Verifica el comportamiento del módulo pwm_controller según diferentes
//     valores de duty cycle. Se analiza la señal pwm_out en el tiempo.
// ============================================================================

`timescale 1ns/1ps

module tb_pwm_controller;

    // Señales
    logic clk;
    logic rst;
    logic [3:0] duty;
    logic pwm_out;

    // Instanciar DUT
    pwm_controller dut (
        .clk(clk),
        .rst(rst),
        .duty(duty),
        .pwm_out(pwm_out)
    );

    // Reloj 50 MHz => periodo de 20ns
    initial clk = 0;
    always #10 clk = ~clk;

    // Proceso de prueba
    initial begin

        // Reset inicial
        rst = 1;
        duty = 4'd0;
        #100;
        rst = 0;

        // Prueba con duty = 0 (0% ciclo útil)
        duty = 4'd0;
        #16000;

        // Prueba con duty = 8 (50%)
        duty = 4'd8;
        #16000;

        // Prueba con duty = 15 (100%)
        duty = 4'd15;
        #16000;

        // Prueba con duty = 4 (25%)
        duty = 4'd4;
        #16000;

    end

endmodule
