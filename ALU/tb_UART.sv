`timescale 1ns/1ps

module tb_UART();

    logic clk;
    logic uart_rx;
    logic [7:0] Out;
	 logic data_ready;

    parameter BAUD_RATE = 115200;
    parameter CLOCK_FREQ = 50000000;
    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

    UART #(
        .BAUD_RATE(BAUD_RATE),
        .CLOCK_FREQ(CLOCK_FREQ)
    ) uut (
        .clk(clk),
        .uart_rx(uart_rx),
        .Out(Out),
		  .data_ready_out(data_ready)
    );

    initial clk = 0;
    always #10 clk = ~clk;  // 50 MHz clock

    localparam BIT_PERIOD = CLKS_PER_BIT * 20; // ns por bit

    // Datos a enviar
    reg [7:0] data_to_send [0:2];
    initial begin
        data_to_send[0] = 8'h55;  // 0b01010101
        data_to_send[1] = 8'hA3;  // 0b10100011
        data_to_send[2] = 8'hFF;  // 0b11111111
    end

    integer i, idx;

    task send_uart_byte(input [7:0] data);
        begin
            // Start bit
            uart_rx = 0;
            #(BIT_PERIOD);

            // Bits de datos LSB primero
            for (i = 0; i < 8; i = i + 1) begin
                uart_rx = data[i];
                #(BIT_PERIOD);
            end

            // Stop bit
            uart_rx = 1;
            #(BIT_PERIOD);

            // Esperar para que se procese
            #(BIT_PERIOD * 5);
        end
    endtask

    initial begin
        uart_rx = 1;  // idle

        #(BIT_PERIOD * 10);

	for (idx = 0; idx < 3; idx = idx + 1) begin
		 send_uart_byte(data_to_send[idx]);

		 // Esperar que data_ready se active (dato listo)
		 wait (data_ready == 1);

		 // Comparar el dato recibido
		 if (Out == data_to_send[idx]) begin
			  $display("TEST PASSED for byte %0d: received %h", idx+1, Out);
		 end else begin
			  $display("TEST FAILED for byte %0d: expected %h, received %h", idx+1, data_to_send[idx], Out);
		 end

		 // Esperar que data_ready se desactive para el próximo dato (si es necesario)
		 wait (data_ready == 0);
	end


        $stop;
    end

endmodule
