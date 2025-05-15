module pwm_controller (
    input  logic clk,           // 50 MHz
    input  logic rst,
    input  logic [3:0] duty,    // 0 a 15
    output logic pwm_out
);

    logic tick;
    logic [11:0] clk_div;       // divisor para tick (12 bits es suficiente)
    logic [7:0] counter;        // contador de 8 bits
    logic [7:0] duty_scaled;

    // ===============================
    // Divisor de reloj para PWM ≈ 20kHz
    // ===============================
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            clk_div <= 0;
        else if (clk_div == 2499)
            clk_div <= 0;
        else
            clk_div <= clk_div + 1;
    end

    assign tick = (clk_div == 0); // un tick cada 2500 ciclos → 20 kHz

    // ===============================
    // Contador de 8 bits para ciclo PWM
    // ===============================
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 0;
        else if (tick)
            counter <= counter + 1;
    end

    // ===============================
    // Escalado de entrada duty de 4 bits a 8 bits (0–255)
    // ===============================
    assign duty_scaled = duty * 17; // 0*17 = 0, 15*17 = 255

    // ===============================
    // Comparador para salida PWM
    // ===============================
    always_comb begin
        pwm_out = (counter < duty_scaled);
    end

endmodule
