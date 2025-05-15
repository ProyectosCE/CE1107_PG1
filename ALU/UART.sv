module UART (
    input  logic clk,              // Reloj FPGA (50 MHz)
    input  logic rst_n,            // Botón de reset ACTIVO BAJO
    input  logic uart_rx,          // Entrada UART RX desde Arduino
    output logic [7:0] Out         // Salida de datos recibidos
);

    // Reset activo alto interno
    logic rst;
    assign rst = ~rst_n;

    // Parámetros de configuración
    parameter BAUD_RATE = 115200;
    parameter CLOCK_FREQ = 50000000;
    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

    // Señales internas del receptor UART
    typedef enum logic [1:0] {
        IDLE, START, DATA, STOP
    } state_t;

    state_t state;
    logic [15:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] rx_shift;
    logic data_ready;
    logic [7:0] data;

    // Receptor UART integrado
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
                    if (uart_rx == 0) begin // Start bit detectado
                        state <= START;
                        clk_count <= 0;
                    end
                end
                START: begin
                    if (clk_count == CLKS_PER_BIT/2) begin
                        if (uart_rx == 0) begin
                            clk_count <= 0;
                            bit_index <= 0;
                            state <= DATA;
                        end else begin
                            state <= IDLE; // Ruido, falso start
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end
                DATA: begin
                    if (clk_count == CLKS_PER_BIT) begin
                        clk_count <= 0;
                        rx_shift[bit_index] <= uart_rx;
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

    // Salida de los datos recibidos
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Out <= 8'b00000000;
        else if (data_ready)
            Out <= data;
    end

endmodule
