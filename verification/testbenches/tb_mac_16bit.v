`timescale 1ns/1ps

module tb_mac_16bit;

    reg clk;
    reg reset;
    reg enable;

    reg signed [15:0] M;
    reg signed [15:0] Q;

    wire signed [63:0] ACC;

    integer errors;
    reg signed [63:0] expected;

    mac_16bit DUT (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .M(M),
        .Q(Q),
        .ACC(ACC)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    task check_acc;
        input signed [63:0] expected_value;
        begin
            #1;
            if (ACC !== expected_value) begin
                $display("FAIL: ACC=%0d EXPECTED=%0d",
                         ACC, expected_value);
                errors = errors + 1;
            end
        end
    endtask

    task apply_mac;
        input signed [15:0] a;
        input signed [15:0] b;
        begin
            @(negedge clk);
            M = a;
            Q = b;
            enable = 1'b1;

            @(posedge clk);
            expected = expected + (a * b);
            check_acc(expected);
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

        // Test synchronous reset
        @(negedge clk);
        reset = 1;
        @(posedge clk);
        expected = 0;
        check_acc(expected);

        @(negedge clk);
        reset = 0;

        // Directed signed multiplication and accumulation
        apply_mac(10, 5);          // +50
        apply_mac(-10, 5);         // -50
        apply_mac(-10, -5);        // +50
        apply_mac(32767, 32767);
        apply_mac(-32768, 32767);
        apply_mac(-32768, -32768);

        // Verify disabled accumulation holds ACC
        @(negedge clk);
        enable = 0;
        M = 100;
        Q = 100;
        @(posedge clk);
        check_acc(expected);

        // Reset must take priority over enable
        @(negedge clk);
        reset = 1;
        enable = 1;
        @(posedge clk);
        expected = 0;
        check_acc(expected);

        @(negedge clk);
        reset = 0;
        enable = 0;

        if (errors == 0)
            $display("PASS: All MAC tests completed successfully.");
        else
            $fatal(1, "FAIL: %0d MAC tests failed.", errors);

        $finish;
    end

endmodule
