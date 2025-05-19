module Flip_Flop_D (
    input logic clk,
    input logic d,
    output logic q
);
    always_ff @(posedge clk)
        q <= d;
endmodule
