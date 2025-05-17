module contador4bit (
    input  logic clk,
    input  logic rst,
    input  logic en,
    output logic [3:0] Q
);

    logic [3:0] count;
    logic [3:0] next_count;
    logic [3:0] carry;

    // Flip-flops tipo D (estructura secuencial)
    Flip_Flop_D ff0(clk, next_count[0], count[0]);
    Flip_Flop_D ff1(clk, next_count[1], count[1]);
    Flip_Flop_D ff2(clk, next_count[2], count[2]);
    Flip_Flop_D ff3(clk, next_count[3], count[3]);

    // Lógica combinacional estructural (sin if, ?:, ni declaraciones internas)
    always_comb begin
        // Cálculo de acarreo
        carry[0] = en;
        carry[1] = carry[0] & count[0];
        carry[2] = carry[1] & count[1];
        carry[3] = carry[2] & count[2];

        // Lógica de suma y reset estructural
        next_count[0] = (count[0] ^ carry[0]) & ~rst;
        next_count[1] = (count[1] ^ carry[1]) & ~rst;
        next_count[2] = (count[2] ^ carry[2]) & ~rst;
        next_count[3] = (count[3] ^ carry[3]) & ~rst;
    end

    assign Q = count;

endmodule
