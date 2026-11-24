module mac_16bit_pipelined (
    input  wire clk,
    input  wire reset,
    input  wire enable,

    input  wire signed [15:0] M,
    input  wire signed [15:0] Q,

    output reg signed [63:0] ACC
);

    // Combinational Booth multiplier
    wire signed [31:0] PRODUCT;

    booth_multiplier_16bit MULTIPLIER (
        .M(M),
        .Q(Q),
        .PRODUCT(PRODUCT)
    );

    // Pipeline registers
    reg signed [31:0] product_reg;
    reg product_valid;

    // Sign-extend registered product
    wire signed [63:0] PRODUCT_EXT;

    assign PRODUCT_EXT = {
        {32{product_reg[31]}},
        product_reg
    };

    // Pipeline control and accumulation
    always @(posedge clk) begin
        if (reset) begin
            product_reg  <= 32'sd0;
            product_valid <= 1'b0;
            ACC           <= 64'sd0;
        end
        else begin
            product_valid <= enable;

            if (enable)
                product_reg <= PRODUCT;

            if (product_valid)
                ACC <= ACC + PRODUCT_EXT;
        end
    end

endmodule
