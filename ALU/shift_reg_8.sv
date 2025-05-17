module shift_reg_8 (
    input logic clk,
    input logic load,
    input logic uart_rx,
    input logic [2:0] bit_index,
    output logic [7:0] q
);

    // Señales one-hot para bit_index
    logic [7:0] bit_index_decoded;
	 
	 decoder_3to8 deco_3to8_inst(
		 .in(bit_index),
		 .out(bit_index_decoded)
	 );

    // Señales para d_next para cada bit
    logic [7:0] d_next;

    // Para cada bit i
    assign d_next[0] = (load & bit_index_decoded[0] & uart_rx) | (~(load & bit_index_decoded[0]) & q[0]);
    assign d_next[1] = (load & bit_index_decoded[1] & uart_rx) | (~(load & bit_index_decoded[1]) & q[1]);
    assign d_next[2] = (load & bit_index_decoded[2] & uart_rx) | (~(load & bit_index_decoded[2]) & q[2]);
    assign d_next[3] = (load & bit_index_decoded[3] & uart_rx) | (~(load & bit_index_decoded[3]) & q[3]);
    assign d_next[4] = (load & bit_index_decoded[4] & uart_rx) | (~(load & bit_index_decoded[4]) & q[4]);
    assign d_next[5] = (load & bit_index_decoded[5] & uart_rx) | (~(load & bit_index_decoded[5]) & q[5]);
    assign d_next[6] = (load & bit_index_decoded[6] & uart_rx) | (~(load & bit_index_decoded[6]) & q[6]);
    assign d_next[7] = (load & bit_index_decoded[7] & uart_rx) | (~(load & bit_index_decoded[7]) & q[7]);

    // Instanciar 8 Flip_Flop_D
    Flip_Flop_D ff0 (.clk(clk), .d(d_next[0]), .q(q[0]));
    Flip_Flop_D ff1 (.clk(clk), .d(d_next[1]), .q(q[1]));
    Flip_Flop_D ff2 (.clk(clk), .d(d_next[2]), .q(q[2]));
    Flip_Flop_D ff3 (.clk(clk), .d(d_next[3]), .q(q[3]));
    Flip_Flop_D ff4 (.clk(clk), .d(d_next[4]), .q(q[4]));
    Flip_Flop_D ff5 (.clk(clk), .d(d_next[5]), .q(q[5]));
    Flip_Flop_D ff6 (.clk(clk), .d(d_next[6]), .q(q[6]));
    Flip_Flop_D ff7 (.clk(clk), .d(d_next[7]), .q(q[7]));

endmodule

module decoder_3to8 (
    input  logic [2:0] in,
    output logic [7:0] out
);

    assign out[0] = ~in[2] & ~in[1] & ~in[0];
    assign out[1] = ~in[2] & ~in[1] &  in[0];
    assign out[2] = ~in[2] &  in[1] & ~in[0];
    assign out[3] = ~in[2] &  in[1] &  in[0];
    assign out[4] =  in[2] & ~in[1] & ~in[0];
    assign out[5] =  in[2] & ~in[1] &  in[0];
    assign out[6] =  in[2] &  in[1] & ~in[0];
    assign out[7] =  in[2] &  in[1] &  in[0];

endmodule 