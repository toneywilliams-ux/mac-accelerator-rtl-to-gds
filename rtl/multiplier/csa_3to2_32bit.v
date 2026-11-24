module csa_3to2_32bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [31:0] C,
    output wire [31:0] SUM,
    output wire [31:0] CARRY
);

    assign SUM   = A ^ B ^ C;

    assign CARRY = ((A & B) | (A & C) | (B & C)) << 1;

endmodule
