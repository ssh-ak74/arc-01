`timescale 1ns/1ps

module pc_tb;

    logic        clk;
    logic        reset;
    logic [31:0] pc;

    arc01_pc dut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;

        // Reset should set PC to 0
        @(posedge clk);
        #1;

        if (pc !== 32'h00000000) begin
            $display("FAIL: PC should be 0 after reset");
            $finish;
        end

        // Release reset
        reset = 0;

        // PC should advance by 4
        @(posedge clk);
        #1;

        if (pc !== 32'h00000004) begin
            $display("FAIL: PC should be 4");
            $finish;
        end

        @(posedge clk);
        #1;

        if (pc !== 32'h00000008) begin
            $display("FAIL: PC should be 8");
            $finish;
        end

        @(posedge clk);
        #1;

        if (pc !== 32'h0000000C) begin
            $display("FAIL: PC should be 0xC");
            $finish;
        end

        $display("ARC-01 PC: PASS");

        $finish;
    end

endmodule