`timescale 1ns/1ps

module tb_UART_FSM;

    // Parámetros
    localparam CLKS_PER_BIT = 434;

    // Señales
    logic clk;
    logic rst;
    logic uart_rx;
    logic [1:0] state;
    logic [15:0] clk_count;
    logic [2:0] bit_index;

    logic [1:0] next_state;
    logic load_data;
    logic inc_clk;
    logic rst_clk;
    logic inc_bit;
    logic rst_bit;
    logic data_valid;
    logic clr_data_ready;

    // Instanciar el DUT
    UART_FSM #(CLKS_PER_BIT) dut (
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

    // Reloj de 10ns (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Variables internas para seguimiento
    integer errors = 0;

    // Inicialización
    initial begin
        // Reset inicial
        rst = 1;
        state = 0;
        clk_count = 0;
        bit_index = 0;
        uart_rx = 1;  // Línea idle (alta)

        @(posedge clk);
        rst = 0;

        // Estado IDLE: uart_rx=1, clr_data_ready = 1 esperado
        #1; // Delay pequeño para evaluación combinacional
        if (clr_data_ready !== 1) begin
            $display("ERROR: clr_data_ready debe ser 1 en IDLE");
            errors = errors + 1;
        end

        // Simular bajada de uart_rx para iniciar START
        uart_rx = 0;
        state = 0;         // IDLE
        clk_count = 0;
        @(posedge clk);
        #1;
        if (next_state !== 2'd1 || rst_clk !== 1) begin
            $display("ERROR: En IDLE con uart_rx=0, debe pasar a START y rst_clk=1");
            errors = errors + 1;
        end

        // Mover a START
        state = 2'd1;

        // Simular avance de clk_count hasta CLKS_PER_BIT/2-1: no cambio
        clk_count = CLKS_PER_BIT/2 - 1;
        uart_rx = 0;
        @(posedge clk);
        #1;
        if (next_state !== 2'd1) begin
            $display("ERROR: En START antes de mitad de bit, debe quedarse en START");
            errors = errors + 1;
        end

        // clk_count = CLKS_PER_BIT/2, uart_rx = 0 (inicio válido)
        clk_count = CLKS_PER_BIT/2;
        uart_rx = 0;
        @(posedge clk);
        #1;
        if (next_state !== 2'd2 || rst_clk !== 1 || rst_bit !== 1) begin
            $display("ERROR: En START con clk_count mitad y uart_rx=0, debe pasar a DATA, rst_clk=1 y rst_bit=1");
            errors = errors + 1;
        end

        // Pasar a DATA
        state = 2'd2;
        clk_count = 0;
        bit_index = 0;

        // Simular recepción 7 bits (bit_index 0..6)
        repeat (7) begin
            clk_count = CLKS_PER_BIT;
            @(posedge clk);
            #1;
            if (load_data !== 1 || rst_clk !== 1 || inc_bit !== 1) begin
                $display("ERROR: En DATA con clk_count completo y bit_index < 7, debe load_data=1, rst_clk=1, inc_bit=1");
                errors = errors + 1;
            end
            // Simular incremento de bit_index
            bit_index = bit_index + 1;
            clk_count = 0;
            @(posedge clk);
        end

        // bit_index = 7 (último bit)
        bit_index = 7;
        clk_count = CLKS_PER_BIT;
        @(posedge clk);
        #1;
        if (load_data !== 1 || rst_clk !== 1 || next_state !== 2'd3) begin
            $display("ERROR: En DATA con bit_index=7 y clk_count completo, debe load_data=1, rst_clk=1, next_state=STOP");
            errors = errors + 1;
        end

        // Pasar a STOP
        state = 2'd3;
        clk_count = CLKS_PER_BIT;
        @(posedge clk);
        #1;
        if (data_valid !== 1 || rst_clk !== 1 || next_state !== 2'd0) begin
            $display("ERROR: En STOP con clk_count completo, debe data_valid=1, rst_clk=1, next_state=IDLE");
            errors = errors + 1;
        end

        // Mostrar resultado
        if (errors == 0) begin
            $display("TEST PASSED: No se detectaron errores.");
        end else begin
            $display("TEST FAILED: Se detectaron %0d errores.", errors);
        end

        $finish;
    end

endmodule
