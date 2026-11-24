module final_cpa_32bit (
    input  wire [31:0] SUM_FINAL,
    input  wire [31:0] CARRY_FINAL,
    output wire [31:0] PRODUCT
);

    assign PRODUCT = SUM_FINAL + CARRY_FINAL;

endmodule
