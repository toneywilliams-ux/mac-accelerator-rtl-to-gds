`timescale 1ns/1ps

module tb_booth_multiplier_16bit;

    reg signed [15:0] M;
    reg signed [15:0] Q;
    wire signed [31:0] PRODUCT;

    integer i;
    integer errors;
    integer expected;

    booth_multiplier_16bit DUT (
        .M(M),
        .Q(Q),
        .PRODUCT(PRODUCT)
    );

    task check_result;
        input signed [15:0] a;
        input signed [15:0] b;
        reg signed [31:0] reference;
        begin
            M = a;
            Q = b;
            #10;

            reference = a * b;

            if (PRODUCT !== reference) begin
                $display("FAIL: M=%0d Q=%0d PRODUCT=%0d EXPECTED=%0d",
                         a, b, PRODUCT, reference);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;

        // Directed tests
        check_result(0, 0);
        check_result(1, 1);
        check_result(-1, 1);
        check_result(1, -1);
        check_result(-1, -1);
        check_result(32767, 32767);
        check_result(-32768, 32767);
        check_result(32767, -32768);
        check_result(-32768, -32768);
        check_result(-32768, -1);
        check_result(32767, 1);
        check_result(0, 32767);

        // Randomized tests
        for (i = 0; i < 10000; i = i + 1) begin
            check_result($random, $random);
        end

        if (errors == 0)
            $display("PASS: All multiplier tests completed successfully.");
        else
            $display("FAIL: %0d multiplier tests failed.", errors);

        $finish;
    end

endmodule
