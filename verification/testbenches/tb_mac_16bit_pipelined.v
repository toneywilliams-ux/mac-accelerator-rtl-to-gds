`timescale 1ns/1ps

module tb_mac_16bit_pipelined;

    reg clk;
    reg reset;
    reg enable;

    reg signed [15:0] M;
    reg signed [15:0] Q;

    wire signed [63:0] ACC;

    integer errors;
    integer i;

    reg signed [63:0] expected;
    reg signed [31:0] pending_product;
    reg pending_valid;

    reg signed [15:0] random_M;
    reg signed [15:0] random_Q;

    mac_16bit_pipelined DUT (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .M(M),
        .Q(Q),
        .ACC(ACC)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    // Apply one input transaction and update the reference model.
    // The model accumulates the product accepted in the PREVIOUS cycle.
    task apply_cycle;
        input rst;
        input en;
        input signed [15:0] a;
        input signed [15:0] b;

        reg signed [31:0] new_product;

        begin
            @(negedge clk);

            reset = rst;
            enable = en;
            M = a;
            Q = b;

            @(posedge clk);

            if (rst) begin
                expected = 64'sd0;
                pending_product = 32'sd0;
                pending_valid = 1'b0;
            end
            else begin
                if (pending_valid)
                    expected = expected + pending_product;

                pending_valid = en;

                if (en) begin
                    new_product = a * b;
                    pending_product = new_product;
                end
            end

            #1;

            if (ACC !== expected) begin
                $display(
                    "FAIL: reset=%b enable=%b M=%0d Q=%0d ACC=%0d EXPECTED=%0d",
                    rst, en, a, b, ACC, expected
                );
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        reset = 0;
        enable = 0;
        M = 0;
        Q = 0;

        errors = 0;
        expected = 0;
        pending_product = 0;
        pending_valid = 0;

        // 1. Reset
        apply_cycle(1, 0, 0, 0);

        // 2. First transaction: accumulator must remain zero
        apply_cycle(0, 1, 10, 5);

        // 3. Previous product (10*5) is accumulated here
        apply_cycle(0, 0, 100, 100);

        // 4. Disabled cycle: accumulator must hold
        apply_cycle(0, 0, 20, 30);

        // 5. Negative product
        apply_cycle(0, 1, -10, 5);

        // 6. Accumulate previous negative product
        apply_cycle(0, 1, -10, -5);

        // 7. Accumulate previous positive product
        apply_cycle(0, 0, 32767, 32767);

        // 8. Accumulate previous product and test boundary input
        apply_cycle(0, 1, -32768, 32767);

        // 9. Accumulate previous boundary product
        apply_cycle(0, 1, -32768, -32768);

        // 10. Accumulate previous product
        apply_cycle(0, 0, 0, 0);

        // 11. Reset while a product is pending
        apply_cycle(1, 1, 100, 100);

        // 12. Confirm reset cleared pending product and accumulator
        apply_cycle(0, 0, 0, 0);

        // 13. Randomized testing
        for (i = 0; i < 1000; i = i + 1) begin
            random_M = $random;
            random_Q = $random;

            apply_cycle(
                0,
                ($random & 1),
                random_M,
                random_Q
            );
        end

        // Flush the final pending transaction
        apply_cycle(0, 0, 0, 0);

        if (errors == 0)
            $display("PASS: All pipelined MAC tests completed successfully.");
        else
            $fatal(1, "FAIL: %0d pipelined MAC tests failed.", errors);

        $finish;
    end

endmodule
