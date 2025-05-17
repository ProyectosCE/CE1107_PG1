module clk_div_50M_to_10K (
    input  logic clk_in,     // 50 MHz clock
    input  logic rst,        // Reset
    output logic clk_out     // 10 kHz clock
);

    logic [12:0] counter;    // Suficiente para contar hasta 4999 (13 bits)
    logic clk_reg;

    always_ff @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 13'd0;
            clk_reg <= 1'b0;
        end else begin
            if (counter == 13'd2499) begin
                counter <= 13'd0;
                clk_reg <= ~clk_reg; // Toggle the output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end

    assign clk_out = clk_reg;

endmodule
