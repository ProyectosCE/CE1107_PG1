module contador8bit (
    input  logic clk,
    input  logic rst,
    output logic [7:0] Q
);

    logic [7:0] next_Q;

    always_comb begin
        next_Q = Q + 8'd1;
    end

    always_ff @(posedge clk) begin
        if (rst)
            Q <= 8'b0;
        else
            Q <= next_Q;
    end

endmodule
