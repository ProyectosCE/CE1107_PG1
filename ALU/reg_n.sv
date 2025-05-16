module reg_n #(parameter N = 8) (
    input logic clk,
    input logic rst,
    input logic en,
    input logic [N-1:0] d,
    output logic [N-1:0] q
);
    genvar i;
    generate
        for (i=0; i<N; i=i+1) begin : bit_ff
            flip_flop_D_en ff (
                .clk(clk),
                .rst(rst),
                .en(en),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule 