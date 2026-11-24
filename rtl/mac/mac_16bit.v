module mac_16bit (
    input  wire clk,
    input  wire reset,
    input  wire enable,

    input  wire signed [15:0] M,
    input  wire signed [15:0] Q,

    output reg signed [63:0] ACC
);

    // 32-bit signed multiplication result
    wire signed [31:0] PRODUCT;

    booth_multiplier_16bit MULTIPLIER (
        .M(M),
        .Q(Q),
        .PRODUCT(PRODUCT)
    );

    // Sign-extend product to 64 bits
    wire signed [63:0] PRODUCT_EXT;

    assign PRODUCT_EXT = {{32{PRODUCT[31]}}, PRODUCT};

    // Synchronous reset and enabled accumulation
    always @(posedge clk) begin
        if (reset)
            ACC <= 64'sd0;
        else if (enable)
            ACC <= ACC + PRODUCT_EXT;
    end

endmodule
