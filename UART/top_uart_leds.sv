module UART (
    input  logic clk,              // Reloj FPGA (50 MHz)
    input  logic rst_n,            // Botón de reset ACTIVO BAJO
    input  logic uart_rx,          // Entrada UART RX desde Arduino
    output logic [7:0] leds        // 4 LEDs para mostrar los 4 bits
);

    // Señales internas
    logic [7:0] uart_data;
    logic uart_data_ready;
    logic rst;  // Reset interno, activo alto

    // Instancia del receptor UART (9600 baudios, 8N1)
    uart_rx #(
        .BAUD_RATE(9600),
        .CLOCK_FREQ(50000000)
    ) uart_inst (
        .clk(clk),
        .rst(rst),
        .rx(uart_rx),
        .data(uart_data),
        .data_ready(uart_data_ready)
    );


    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            leds <= 4'b00000000;
        else if (uart_data_ready)
            leds <= uart_data;
    end

endmodule


module uart_rx (
    input  logic clk,          // Reloj FPGA (por ejemplo, 50 MHz)
    input  logic rst,          // Reset
    input  logic rx,           // UART RX desde Arduino (ej: GPIO[0])
    output logic [7:0] data,   // Byte recibido
    output logic data_ready    // Bandera de nuevo dato recibido
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000;
    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;
    typedef enum logic [1:0] {
        IDLE, START, DATA, STOP
    } state_t;
    state_t state;
    logic [15:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] rx_shift;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            data_ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    data_ready <= 0;
                    if (rx == 0) begin // start bit detectado
                        state <= START;
                        clk_count <= 0;
                    end
                end
                START: begin
                    if (clk_count == CLKS_PER_BIT/2) begin
                        if (rx == 0) begin
                            clk_count <= 0;
                            bit_index <= 0;
                            state <= DATA;
                        end else begin
                            state <= IDLE; // ruido
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end
                DATA: begin
                    if (clk_count == CLKS_PER_BIT) begin
                        clk_count <= 0;
                        rx_shift[bit_index] <= rx;
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end
                STOP: begin
                    if (clk_count == CLKS_PER_BIT) begin
                        state <= IDLE;
                        data <= rx_shift;
                        data_ready <= 1;
                        clk_count <= 0;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end
            endcase
        end
    end
endmodule
