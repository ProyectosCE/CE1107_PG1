module UART_FSM #(parameter CLKS_PER_BIT = 434)(
    input  logic        clk,
    input  logic        rst,
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

// --------------------------------------------------
// Módulo de transición de estados (sin if, case, else)
module State_Transition (
    input  logic [1:0] state,
    input  logic uart_rx,
    input  logic clk_count_eq_half,
    input  logic clk_count_eq_full,
    input  logic bit_index_eq_7,
    output logic [1:0] next_state
);
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;

    // Condiciones
    logic to_start, to_data, stay_data, to_stop, to_idle;

    assign to_start    = (state == IDLE)  & ~uart_rx;
    assign to_data     = (state == START) & clk_count_eq_half & ~uart_rx;
    assign stay_data   = (state == DATA)  & clk_count_eq_full & ~bit_index_eq_7;
    assign to_stop     = (state == DATA)  & clk_count_eq_full &  bit_index_eq_7;
    assign to_idle     = (state == STOP)  & clk_count_eq_full;

    // Selecciones con mux2_1 anidados (2 bits separados)
    logic [1:0] ns0, ns1, ns2, ns3, ns4;

    // Nivel 1
    mux2_1 m1 (.sel(to_idle),     .a(state[0]), .b(IDLE[0]),  .y(ns0[0]));
    mux2_1 m2 (.sel(to_idle),     .a(state[1]), .b(IDLE[1]),  .y(ns0[1]));

    mux2_1 m3 (.sel(to_stop),     .a(ns0[0]),   .b(STOP[0]),  .y(ns1[0]));
    mux2_1 m4 (.sel(to_stop),     .a(ns0[1]),   .b(STOP[1]),  .y(ns1[1]));

    mux2_1 m5 (.sel(stay_data),   .a(ns1[0]),   .b(DATA[0]),  .y(ns2[0]));
    mux2_1 m6 (.sel(stay_data),   .a(ns1[1]),   .b(DATA[1]),  .y(ns2[1]));

    mux2_1 m7 (.sel(to_data),     .a(ns2[0]),   .b(DATA[0]),  .y(ns3[0]));
    mux2_1 m8 (.sel(to_data),     .a(ns2[1]),   .b(DATA[1]),  .y(ns3[1]));

    mux2_1 m9 (.sel(to_start),    .a(ns3[0]),   .b(START[0]), .y(next_state[0]));
    mux2_1 m10(.sel(to_start),    .a(ns3[1]),   .b(START[1]), .y(next_state[1]));

endmodule



// --------------------------------------------------
// Módulo para señales de control (sin if, case, else)
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

    logic idle, start, data, stop;
    assign idle  = (state == 2'd0);
    assign start = (state == 2'd1);
    assign data  = (state == 2'd2);
    assign stop  = (state == 2'd3);

    assign load_data  = data & clk_count_eq_full;  // Se carga cada vez que termina un bit
    assign inc_clk    = (start & ~clk_count_eq_half) | (data & ~clk_count_eq_full) | (stop & ~clk_count_eq_full);
    assign rst_clk    = (idle & ~uart_rx) | (start & clk_count_eq_half) | (data & clk_count_eq_full) | (stop & clk_count_eq_full);
    assign inc_bit    = data & clk_count_eq_full & ~bit_index_eq_7;
    assign rst_bit = (start & clk_count_eq_half & ~uart_rx) | (stop & clk_count_eq_full);
    assign data_valid = stop & clk_count_eq_full;
    assign clr_data_ready = idle;

endmodule

