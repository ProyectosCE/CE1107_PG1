// ======================================================
// Contador de 4 bits 
// ======================================================

module contador4bit (
    input  logic clk,
    input  logic rst,
	 input  logic en,
    output logic [3:0] Q
);

    logic [3:0] next_Q;

    // Lógica del siguiente estado (Q + 1)
    always_comb begin
        next_Q = Q + 4'd1;
    end

    // FF tipo D
    always_ff @(posedge clk) begin
        if (rst)
            Q <= 4'b0000;
        else if (en)
            Q <= next_Q;
    end

endmodule 