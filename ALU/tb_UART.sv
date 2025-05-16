`timescale 1ns / 1ps

module tb_UART();

    // Parámetros
    parameter CLOCK_FREQ = 50000000; // 50 MHz
    parameter BAUD_RATE = 115200;
    parameter CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;
    parameter BIT_PERIOD = 1000000000 / BAUD_RATE; // en nanosegundos

    // Señales
    logic clk;
    logic rst_n;
    logic uart_rx;
    logic [7:0] Out;

    // Variables internas para pruebas
    logic [7:0] expected_data [2:0];
    int i;
    int errors = 0;

    // Instancia del DUT
    UART dut (
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx(uart_rx),
        .Out(Out)
    );

    // Generador de reloj (50 MHz)
    always #10 clk = ~clk;

    // Inicialización
    initial begin
        clk = 0;
        rst_n = 0;
        uart_rx = 1;  // Línea UART en reposo (idle)

        expected_data[0] = 8'h5A;
        expected_data[1] = 8'hA3;
		  expected_data[2] = 8'hB3;

        // Reset activo bajo
        #100;
        rst_n = 1;

        // Esperar estabilización
        #1000;

        // Enviar datos y comprobar resultados
        for (i = 0; i < 3; i++) begin
            send_uart_byte(expected_data[i]);

            // Esperar tiempo suficiente para recepción completa (10 bits + margen)
            #(BIT_PERIOD * 12);

            // Mostrar estado (si deseas inspeccionar)
            $display("Prueba %0d: Se esperaba %h, se recibio %h", i+1, expected_data[i], Out);

            if (Out === expected_data[i]) begin
                $display("Prueba %0d OK: dato recibido correctamente.", i+1);
            end else begin
                $display("Prueba %0d ERROR: dato recibido incorrecto.", i+1);
                errors++;
            end
        end

        // Resultado final
        if (errors == 0)
            $display("\nTODAS LAS PRUEBAS PASARON");
        else
            $display("\n%0d PRUEBA(S) FALLARON", errors);

        $finish;
    end

    // Tarea para simular la transmisión UART (start bit + 8 bits + stop bit)
    task send_uart_byte(input [7:0] data);
        integer j;
        begin
            // Bit de inicio (start bit)
            uart_rx = 0;
            #(BIT_PERIOD);

            // Bits de datos (LSB primero)
            for (j = 0; j < 8; j++) begin
                uart_rx = data[j];
                #(BIT_PERIOD);
            end

            // Bit de parada (stop bit)
            uart_rx = 1;
            #(BIT_PERIOD);
        end
    endtask

endmodule
