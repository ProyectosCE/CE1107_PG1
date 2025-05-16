// Flip-flop D con enable y reset asíncrono 
module flip_flop_D_en (
    input logic clk,
    input logic rst,    // reset asíncrono activo alto
    input logic en,
    input logic d,
    output logic q
);
    logic q_int;
    logic dff_input;
    logic q_reset;

    // mux para enable: dff_input = en ? d : q_int
    mux2_1 mux_en (
        .sel(en),
        .a(q_int),
        .b(d),
        .y(dff_input)
    );

    // mux para reset asíncrono: q = rst ? 0 : q_int
    mux2_1 mux_rst (
        .sel(rst),
        .a(q_int),
        .b(1'b0),
        .y(q_reset)
    );

    // Instancia flip-flop básico
    FF_D ff (
        .clk(clk),
        .d(dff_input),
        .q(q_int)
    );

    assign q = q_reset;

endmodule


// Flip-flop D 
module FF_D (
    input logic clk,
    input logic d,
    output logic q
);
    logic qm, qnm; // Salida del latch maestro

    // Latch maestro: activo cuando clk = 0
    d_latch master (
        .d(d),
        .en(~clk),
        .q(qm),
        .qn(qnm)
    );

    // Latch esclavo: activo cuando clk = 1
    d_latch slave (
        .d(qm),
        .en(clk),
        .q(q),
        .qn() // no se usa, se puede dejar sin conectar
    );
endmodule

// D Latch
module d_latch (
    input logic d,
    input logic en,
    output logic q,
    output logic qn
);
    logic s, r;

    assign s = ~(d & en);
    assign r = ~(~d & en);
    assign q = ~(s & qn);
    assign qn = ~(r & q);
endmodule 