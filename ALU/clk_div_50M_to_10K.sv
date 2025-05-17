module clk_div_50M_to_10K (
    input logic clk_50MHz,
    output logic clk_out_10k
);
    logic [16:0] count;
    logic [16:0] next_count;

    // Flip-Flops tipo D
    Flip_Flop_D ff0(clk_50MHz, next_count[0], count[0]);
    Flip_Flop_D ff1(clk_50MHz, next_count[1], count[1]);
    Flip_Flop_D ff2(clk_50MHz, next_count[2], count[2]);
    Flip_Flop_D ff3(clk_50MHz, next_count[3], count[3]);
    Flip_Flop_D ff4(clk_50MHz, next_count[4], count[4]);
    Flip_Flop_D ff5(clk_50MHz, next_count[5], count[5]);
    Flip_Flop_D ff6(clk_50MHz, next_count[6], count[6]);
    Flip_Flop_D ff7(clk_50MHz, next_count[7], count[7]);
    Flip_Flop_D ff8(clk_50MHz, next_count[8], count[8]);
    Flip_Flop_D ff9(clk_50MHz, next_count[9], count[9]);
    Flip_Flop_D ff10(clk_50MHz, next_count[10], count[10]);
    Flip_Flop_D ff11(clk_50MHz, next_count[11], count[11]);
    Flip_Flop_D ff12(clk_50MHz, next_count[12], count[12]);
    Flip_Flop_D ff13(clk_50MHz, next_count[13], count[13]);
    Flip_Flop_D ff14(clk_50MHz, next_count[14], count[14]);
    Flip_Flop_D ff15(clk_50MHz, next_count[15], count[15]);
    Flip_Flop_D ff16(clk_50MHz, next_count[16], count[16]);

    // Lógica de sumador de 17 bits (sin for)
    assign next_count[0]  = ~count[0];
    assign next_count[1]  = count[0] ^ count[1];
    assign next_count[2]  = (count[0] & count[1]) ^ count[2];
    assign next_count[3]  = (count[0] & count[1] & count[2]) ^ count[3];
    assign next_count[4]  = (count[0] & count[1] & count[2] & count[3]) ^ count[4];
    assign next_count[5]  = (count[0] & count[1] & count[2] & count[3] & count[4]) ^ count[5];
    assign next_count[6]  = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5]) ^ count[6];
    assign next_count[7]  = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6]) ^ count[7];
    assign next_count[8]  = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7]) ^ count[8];
    assign next_count[9]  = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8]) ^ count[9];
    assign next_count[10] = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8] & count[9]) ^ count[10];
    assign next_count[11] = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8] & count[9] & count[10]) ^ count[11];
    assign next_count[12] = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8] & count[9] & count[10] & count[11]) ^ count[12];
    assign next_count[13] = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8] & count[9] & count[10] & count[11] & count[12]) ^ count[13];
    assign next_count[14] = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8] & count[9] & count[10] & count[11] & count[12] & count[13]) ^ count[14];
    assign next_count[15] = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8] & count[9] & count[10] & count[11] & count[12] & count[13] & count[14]) ^ count[15];
    assign next_count[16] = (count[0] & count[1] & count[2] & count[3] & count[4] & count[5] & count[6] & count[7] & count[8] & count[9] & count[10] & count[11] & count[12] & count[13] & count[14] & count[15]) ^ count[16];

    // Salida: clk_out_500 ≈ 500 Hz
    assign clk_out_500 = count[16];

endmodule
