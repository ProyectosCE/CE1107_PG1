module UART (
    input  logic clk,              // Reloj FPGA (50 MHz)
    input  logic rst_n,            // Botón de reset ACTIVO BAJO
    input  logic uart_rx,          // Entrada UART RX desde Arduino
    output logic [7:0] Out         // Salida de datos recibidos
);

    // Reset activo alto interno
    logic rst;
    assign rst = rst_n;

    // Parámetros de configuración
    parameter BAUD_RATE = 115200;
    parameter CLOCK_FREQ = 50000000;
    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

    // Señales internas
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;
	 
    // FSM signals
    logic [1:0] state, next_state;

    // Counters and indexes
    logic [15:0] clk_count;
    logic [15:0] clk_count_next;
    logic [2:0] bit_index;
    logic [2:0] bit_index_next;

    // Shift register and data buffers
    logic [7:0] rx_shift;
    logic [7:0] data;
    logic data_ready;

    // FSM control signals
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

// State register 2 bits
    reg_n #(.N(2)) state_reg (
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .d(next_state),
        .q(state)
    );

    // clk_count next logic without module sumador
    //assign clk_count_next = rst_clk ? 16'd0 : (inc_clk ? (clk_count + 1) : clk_count);

	clk_count_next_logic clk_count_logic_inst (
		.rst_clk(rst_clk),
		.inc_clk(inc_clk),
		.clk_count(clk_count),
		.clk_count_next(clk_count_next)
	);

    reg_n #(.N(16)) clk_count_reg (
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .d(clk_count_next),
        .q(clk_count)
    );

    // bit_index next logic without module sumador
    //assign bit_index_next = rst_bit ? 3'd0 : (inc_bit ? (bit_index + 1) : bit_index);

	bit_index_next_logic bit_index_logic_inst (
		.rst_bit(rst_bit),
		.inc_bit(inc_bit),
		.bit_index(bit_index),
		.bit_index_next(bit_index_next)
	);
		 
    reg_n #(.N(3)) bit_index_reg (
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .d(bit_index_next),
        .q(bit_index)
    );

    // Shift register 8 bits
    shift_reg_8 shift_reg (
        .clk(clk),
        .rst(rst),
        .load(load_data),
        .uart_rx(uart_rx),
        .bit_index(bit_index),
        .q(rx_shift)
    );

    // Data buffer register 8 bits
    reg_n #(.N(8)) data_reg (
        .clk(clk),
        .rst(rst),
        .en(data_valid),
        .d(rx_shift),
        .q(data)
    );

    // data_ready flag flip flop
    flip_flop_D_en data_ready_ff (
        .clk(clk),
        .rst(rst),
        .en(clr_data_ready || data_valid),
        .d(data_valid),
        .q(data_ready)
    );

    // Output register 8 bits
    reg_n #(.N(8)) out_reg (
        .clk(clk),
        .rst(rst),
        .en(data_ready),
        .d(data),
        .q(Out)
    );

endmodule 


module clk_count_next_logic (
    input  logic rst_clk,
    input  logic inc_clk,
    input  logic [15:0] clk_count,
    output logic [15:0] clk_count_next
);
    logic [15:0] clk_count_plus_1;
    logic [15:0] mux1_out;

    assign clk_count_plus_1 = clk_count + 1;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : mux_inc
            mux2_1 mux_inst (
                .sel(inc_clk),
                .a(clk_count[i]),
                .b(clk_count_plus_1[i]),
                .y(mux1_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < 16; i = i + 1) begin : mux_rst
            mux2_1 mux_inst (
                .sel(rst_clk),
                .a(mux1_out[i]),
                .b(1'b0),
                .y(clk_count_next[i])
            );
        end
    endgenerate
endmodule


module bit_index_next_logic (
    input  logic rst_bit,
    input  logic inc_bit,
    input  logic [2:0] bit_index,
    output logic [2:0] bit_index_next
);
    logic [2:0] bit_index_plus_1;
    logic [2:0] mux1_out;

    assign bit_index_plus_1 = bit_index + 1;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : mux_inc
            mux2_1 mux_inst (
                .sel(inc_bit),
                .a(bit_index[i]),
                .b(bit_index_plus_1[i]),
                .y(mux1_out[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < 3; i = i + 1) begin : mux_rst
            mux2_1 mux_inst (
                .sel(rst_bit),
                .a(mux1_out[i]),
                .b(1'b0),
                .y(bit_index_next[i])
            );
        end
    endgenerate
endmodule


