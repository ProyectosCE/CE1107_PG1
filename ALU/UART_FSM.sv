module UART_FSM #(parameter CLKS_PER_BIT = 434)(
    input  logic        clk,
    input  logic        uart_rx,
    input  logic [1:0]  state,
    input  logic [15:0] clk_count,
    input  logic [2:0]  bit_index,

    output logic [1:0]  next_state,
    output logic        load_data,
    output logic        inc_clk,
    output logic        rst_clk,
    output logic        inc_bit,
    output logic        rst_bit,
    output logic        data_valid,
    output logic        clr_data_ready
);

    // Señales auxiliares para comparaciones
    logic clk_count_eq_half;
    logic clk_count_eq_full;
    logic bit_index_eq_7;

    assign clk_count_eq_half = (clk_count == CLKS_PER_BIT/2);
    assign clk_count_eq_full = (clk_count == CLKS_PER_BIT);
    assign bit_index_eq_7 = (bit_index == 3'd7);

    // Lógica de transición de estados
    State_Transition st_trans (
        .state(state),
        .uart_rx(uart_rx),
        .clk_count_eq_half(clk_count_eq_half),
        .clk_count_eq_full(clk_count_eq_full),
        .bit_index_eq_7(bit_index_eq_7),
        .next_state(next_state)
    );

    // Lógica de señales de control
    Output_Logic out_logic (
        .state(state),
        .uart_rx(uart_rx),
        .clk_count_eq_half(clk_count_eq_half),
        .clk_count_eq_full(clk_count_eq_full),
        .bit_index_eq_7(bit_index_eq_7),
        .load_data(load_data),
        .inc_clk(inc_clk),
        .rst_clk(rst_clk),
        .inc_bit(inc_bit),
        .rst_bit(rst_bit),
        .data_valid(data_valid),
        .clr_data_ready(clr_data_ready)
    );

endmodule

// --------------------------------
// Módulo de transición de estados 
module State_Transition (
    input  logic [1:0] state,
    input  logic uart_rx,
    input  logic clk_count_eq_half,
    input  logic clk_count_eq_full,
    input  logic bit_index_eq_7,
    output logic [1:0] next_state
);
	 
	logic s1, s0, rx, ch, cf, b7;
	assign s1 = state[1];
	assign s0 = state[0];
	assign rx = uart_rx;
	assign ch = clk_count_eq_half;
	assign cf = clk_count_eq_full;
	assign b7 = bit_index_eq_7;
	
	assign next_state[1] = (~s1 & s0 & ~rx & ch) |
					           (s1 & ~s0 & cf & ~b7) |
					           (s1 & ~s0 & cf & b7)  |
					           (s1 & ~s0 & ~cf)      |
					           (s1 & s0 & ~cf);
					  
	assign next_state[0] = (~s1 & ~s0 & ~rx)      |
								  (~s1 & s0 & ~rx & ~ch) |
								  (s1 & ~s0 & cf & b7)   |
								  (s1 & s0 & ~cf);


endmodule



// ------------------------------
// Módulo para señales de control 
module Output_Logic (
    input logic [1:0] state,
    input logic uart_rx,
    input logic clk_count_eq_half,
    input logic clk_count_eq_full,
    input logic bit_index_eq_7,
    output logic load_data,
    output logic inc_clk,
    output logic rst_clk,
    output logic inc_bit,
    output logic rst_bit,
    output logic data_valid,
    output logic clr_data_ready
);

	logic s1, s0, rx, ch, cf, b7;
	assign s1 = state[1];
	assign s0 = state[0];
	assign rx = uart_rx;
	assign ch = clk_count_eq_half;
	assign cf = clk_count_eq_full;
	assign b7 = bit_index_eq_7;
	
	
    assign load_data = (s1 & ~s0 & cf & ~b7) |
							  (s1 & ~s0 & cf & b7);
	 
    assign inc_clk = (~s1 & s0 & ~rx & ~ch) |
							(s1 & ~s0 & ~cf)       |
							(s1 & s0 & ~cf);
	 
    assign rst_clk = (~s1 & ~s0 & ~rx)     |
	                  (~s1 & s0 & ~rx & ch) |
							(s1 & ~s0 & cf & ~b7) |
							(s1 & ~s0 & cf & b7)  |
							(s1 & s0 & cf);
	 
    assign inc_bit = (s1 & ~s0 & cf & ~b7);
	 
    assign rst_bit = (~s1 & s0 & ~rx & ch) |
						   (s1 & s0 & cf);
	 
    assign data_valid = (s1 & s0 & cf);
	 
    assign clr_data_ready = (~s1 & ~s0 & ~rx) |
									 (~s1 & ~s0 & rx);

endmodule

