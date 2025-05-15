// ======================================================
// Contador de 4 bits
// ======================================================

module contador4bit (
    input  logic clk,
    input  logic rst,
    input  logic en,
    output logic [3:0] Q
);

    // FF tipo D con lógica de conteo directa
    always_ff @(posedge clk) begin
        if (rst)
            Q <= 4'b0000;
        else if (en)
            Q <= Q + 4'd1;
        // Si 'en' no está activo, Q mantiene su valor actual automáticamente
    end

endmodule
