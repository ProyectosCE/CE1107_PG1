module UART (
    input  logic clk,              // Reloj FPGA (50 MHz)
    input  logic uart_rx,          // Entrada UART RX desde Arduino
    output logic [7:0] Out         // Salida de datos recibidos
);
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
	 
	 // Otros señales para los mux
	 logic [15:0] clk_count_next, clk_count_next_1;
	 logic [2:0]  bit_index_next, bit_index_next_1;
	 logic        data_ready_next, data_ready_next_1;
	 logic [7:0] data_next;

    // Instancia del módulo FSM
    UART_FSM #(.CLKS_PER_BIT(CLKS_PER_BIT)) fsm_inst (
        .clk(clk),
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


    // Registro de estado
    reg_n #(.N(2)) state_reg (
        .clk(clk),
        .d(next_state),
        .en(1'b1),
        .q(state)
    );

    // Registro de conteo de reloj
    logic [15:0] clk_inc;
    assign clk_inc = clk_count + 1;
	 mux2_1_n #(.N(16)) clk_mux1 (
		 .sel(inc_clk), 
		 .a(clk_count), 
		 .b(clk_inc), 
		 .y(clk_count_next_1)
	 );
	 mux2_1_n #(.N(16)) clk_mux2 (
		 .sel(rst_clk), 
		 .a(clk_count_next_1), 
		 .b(16'd0), 
		 .y(clk_count_next)
	 );
    reg_n #(.N(16)) clk_count_reg (
		 .clk(clk), 
		 .d(clk_count_next), 
		 .en(1'b1), 
		 .q(clk_count)
	 );


    // Registro de índice de bit
    logic [2:0] bit_inc;
    assign bit_inc = bit_index + 1;
	 mux2_1_n #(.N(3)) bit_mux1 (
	    .sel(inc_bit), 
	    .a(bit_index), 
	    .b(bit_inc), 
		 .y(bit_index_next_1)
	 );
	 mux2_1_n #(.N(3)) bit_mux2 (
		 .sel(rst_bit), 
		 .a(bit_index_next_1), 
	    .b(3'd0), 
		 .y(bit_index_next)
	 );
    reg_n #(.N(3)) bit_index_reg (
		 .clk(clk), 
		 .d(bit_index_next), 
		 .en(1'b1), 
		 .q(bit_index)
	 );


    // Registro de desplazamiento
    shift_reg_8 rx_shift_reg (
        .clk(clk),
        .load(load_data),
        .uart_rx(uart_rx),
        .bit_index(bit_index),
        .q(rx_shift)
    );

	 
    // Registro de salida
    mux2_1_n #(.N(8)) data_mux (
		 .sel(data_valid), 
		 .a(data), 
		 .b(rx_shift), 
		 .y(data_next)
	 );
    reg_n #(.N(8)) data_reg (
		 .clk(clk), 
		 .d(data_next), 
		 .en(1'b1), 
		 .q(data)
	 );


    // Flag de datos listos
    logic data_ready_set;
    assign data_ready_set = 1'b1;
	 mux2_1 data_ready_mux1 (
		 .sel(data_valid), 
		 .a(data_ready), 
		 .b(data_ready_set), 
		 .y(data_ready_next_1)
	 );
	 mux2_1 data_ready_mux2 (
		 .sel(clr_data_ready), 
		 .a(data_ready_next_1), 
		 .b(1'b0), 
		 .y(data_ready_next)
	 );
    reg_n #(.N(1)) data_ready_reg (
		 .clk(clk), 
		 .d(data_ready_next), 
		 .en(1'b1), 
		 .q(data_ready)
	 );

    // Salida de datos
    mux2_1_n #(.N(8)) out_mux (
		 .sel(data_ready), 
		 .a(Out), 
		 .b(data), 
		 .y(Out)
	 );
	 
endmodule 
