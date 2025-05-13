module mux4_1(
    input  logic [3:0] D0,
    input  logic [3:0] D1,
    input  logic [3:0] D2,
    input  logic [3:0] D3,
    input  logic [1:0] sel,
    output logic [3:0] Y
);
    logic [3:0] s0n, s1n, t0, t1, t2, t3;

    assign s0n = {4{~sel[0]}};
    assign s1n = {4{~sel[1]}};

    assign t0 = D0 & s1n & s0n;
    assign t1 = D1 & s1n & {4{ sel[0]}};
    assign t2 = D2 & {4{ sel[1]}} & s0n;
    assign t3 = D3 & {4{ sel[1]}} & {4{ sel[0]}};

    assign Y = t0 | t1 | t2 | t3;
endmodule
