module booth_multiplier_16bit (
    input  wire signed [15:0] M,
    input  wire signed [15:0] Q,
    output wire signed [31:0] PRODUCT
);

    // Radix-4 Booth encoding
    wire [2:0] booth [0:7];

    assign booth[0] = {Q[1:0], 1'b0};
    assign booth[1] = Q[3:1];
    assign booth[2] = Q[5:3];
    assign booth[3] = Q[7:5];
    assign booth[4] = Q[9:7];
    assign booth[5] = Q[11:9];
    assign booth[6] = Q[13:11];
    assign booth[7] = Q[15:13];

    // Sign-extended multiplicand
    wire signed [31:0] M_ext;
    assign M_ext = {{16{M[15]}}, M};

    // Booth partial products
    wire signed [31:0] pp [0:7];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : booth_generation
            reg signed [31:0] selected_pp;

            always @(*) begin
                case (booth[i])
                    3'b000, 3'b111:
                        selected_pp = 32'sd0;

                    3'b001, 3'b010:
                        selected_pp = M_ext;

                    3'b011:
                        selected_pp = M_ext <<< 1;

                    3'b100:
                        selected_pp = -(M_ext <<< 1);

                    3'b101, 3'b110:
                        selected_pp = -M_ext;

                    default:
                        selected_pp = 32'sd0;
                endcase
            end

            assign pp[i] = selected_pp <<< (2*i);
        end
    endgenerate

    // CSA compression: 8 partial products -> 2 final rows

    wire [31:0] s1, c1;
    wire [31:0] s2, c2;
    wire [31:0] s3, c3;
    wire [31:0] s4, c4;
    wire [31:0] s5, c5;
    wire [31:0] s6, c6;

    csa_3to2_32bit CSA1 (
        .A(pp[0]), .B(pp[1]), .C(pp[2]),
        .SUM(s1), .CARRY(c1)
    );

    csa_3to2_32bit CSA2 (
        .A(pp[3]), .B(pp[4]), .C(pp[5]),
        .SUM(s2), .CARRY(c2)
    );

    csa_3to2_32bit CSA3 (
        .A(pp[6]), .B(pp[7]), .C(s1),
        .SUM(s3), .CARRY(c3)
    );

    csa_3to2_32bit CSA4 (
        .A(c1), .B(s2), .C(c2),
        .SUM(s4), .CARRY(c4)
    );

    csa_3to2_32bit CSA5 (
        .A(s3), .B(c3), .C(s4),
        .SUM(s5), .CARRY(c5)
    );

    csa_3to2_32bit CSA6 (
        .A(c4), .B(s5), .C(c5),
        .SUM(s6), .CARRY(c6)
    );

    // Final carry-propagate addition
    final_cpa_32bit FINAL_ADDER (
        .SUM_FINAL(s6),
        .CARRY_FINAL(c6),
        .PRODUCT(PRODUCT)
    );

endmodule
