module reg_n #(parameter N = 8)(
    input  logic clk,
    input  logic [N-1:0] d,
    input  logic en,
    output logic [N-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : reg_loop
            logic d_in;
            mux2_1 sel_mux (
                .sel(en),
                .a(q[i]),
                .b(d[i]),
                .y(d_in)
            );
            Flip_Flop_D ff (
                .clk(clk),
                .d(d_in),
                .q(q[i])
            );
        end
    endgenerate
endmodule
