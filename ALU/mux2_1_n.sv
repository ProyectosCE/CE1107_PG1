module mux2_1_n #(parameter N = 8)(
    input  logic sel,
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] y
);
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : mux_loop
            mux2_1 m (.sel(sel), .a(a[i]), .b(b[i]), .y(y[i]));
        end
    endgenerate
endmodule 