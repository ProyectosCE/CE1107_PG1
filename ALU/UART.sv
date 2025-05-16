module UART (
    input  logic clk,              // Reloj FPGA (50 MHz)
    input  logic rst_n,            // Botón de reset ACTIVO BAJO
    input  logic uart_rx,          // Entrada UART RX desde Arduino
    output logic [7:0] Out         // Salida de datos recibidos
);

    // Reset activo alto interno
    logic rst;
    //assign rst = ~rst_n;

    // Parámetros de configuración
    parameter BAUD_RATE = 115200;
    parameter CLOCK_FREQ = 50000000;
    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

    // Señales internas
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;
	 
	 logic [1:0] state, next_state;
    logic [15:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] rx_shift;
    logic [7:0] data;
    logic data_ready;

    // Señales de control desde la FSM
    logic load_data;
    logic inc_clk;
    logic rst_clk;
    logic inc_bit;
    logic rst_bit;
    logic data_valid;
    logic clr_data_ready;

    // Instancia del módulo FSM
    UART_FSM #(.CLKS_PER_BIT(CLKS_PER_BIT)) fsm_inst (
        .clk(clk),
        .rst(rst),
        .uart_rx(uart_rx),
        .state(state),
        .clk_count(clk_count),
        .bit_index(bit_index),

        .next_state(next_state),
        .load_data(load_data),
        .inc_clk(inc_clk),
        .rst_clk(rst_clk),
        .inc_bit(inc_bit),
        .rst_bit(rst_bit),
        .data_valid(data_valid),
        .clr_data_ready(clr_data_ready)
    );

    // Registro de estado (state register)
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Registro de conteo de reloj
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            clk_count <= 0;
        else if (rst_clk)
            clk_count <= 0;
        else if (inc_clk)
            clk_count <= clk_count + 1;
    end

    // Registro de índice de bit
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            bit_index <= 0;
        else if (rst_bit)
            bit_index <= 0;
        else if (inc_bit)
            bit_index <= bit_index + 1;
    end

    // Registro de desplazamiento (shift register)
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            rx_shift <= 8'b0;
        else if (load_data)
            rx_shift[bit_index] <= uart_rx;
    end

    // Registro de salida final (buffer)
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            data <= 8'b0;
        else if (data_valid)
            data <= rx_shift;
    end

    // Flag de datos listos
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            data_ready <= 0;
        else if (clr_data_ready)
            data_ready <= 0;
        else if (data_valid)
            data_ready <= 1;
    end

    // Salida de datos
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            Out <= 8'b0;
        else if (data_ready)
            Out <= data;
    end

endmodule 