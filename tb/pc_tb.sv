`timescale 1ns/1ps

module pc_tb;

    logic clk;
    logic reset;
    logic [31:0] pc;
    logic [31:0] next_pc;

    assign next_pc = pc + 32'd4;

    arc01_pc dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        @(posedge clk);
        #1;
        if (pc !== 32'd0)
            $fatal(1, "FAIL: PC should be 0 after reset");

        reset = 0;

        @(posedge clk);
        #1;
        if (pc !== 32'd4)
            $fatal(1, "FAIL: PC should be 4");

        @(posedge clk);
        #1;
        if (pc !== 32'd8)
            $fatal(1, "FAIL: PC should be 8");

        @(posedge clk);
        #1;
        if (pc !== 32'd12)
            $fatal(1, "FAIL: PC should be 12");

        $display("ARC-01 PC: PASS");
        $finish;
    end

endmodule
