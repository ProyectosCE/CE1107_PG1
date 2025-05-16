module mux2_1 (
    input  logic sel,
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = (sel & b) | (~sel & a);
endmodule
