// ======================================================
// Divisor de frecuencia PWM
// ======================================================

module div_pwm #(
    parameter CLK_FREQ = 50_000_000,   // 50 MHz
    parameter PWM_FREQ = 10_000        // Frecuencia PWM deseada
)(
    input  logic clk,
    input  logic rst,
    output logic tick               // pulso cada STEP_CYCLES
);
    localparam integer PWM_STEPS = 16;
    localparam integer STEP_CYCLES = CLK_FREQ / (PWM_FREQ * PWM_STEPS);
    localparam integer COUNTER_WIDTH = $clog2(STEP_CYCLES);

    logic [COUNTER_WIDTH-1:0] counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 0;
        else if (counter == STEP_CYCLES - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign tick = (counter == STEP_CYCLES - 1);

endmodule
