`timescale 1ns/1ps

module mul_tb;
    logic clk = 0;
    logic reset = 1;
    integer i;

    arc01 dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            dut.imem.memory[i] = 32'h00000013;

        // x1 = 7
        dut.imem.memory[0] = 32'h00700093;

        // x2 = 6
        dut.imem.memory[1] = 32'h00600113;

        // MUL x3, x1, x2
        dut.imem.memory[2] = 32'h022081B3;

        // Stop execution by looping at the next instruction.
        dut.imem.memory[3] = 32'h0000006F;

        repeat (2) @(posedge clk);
        #1 reset = 0;

        repeat (10) @(posedge clk);
        #1;

        $display("x1 = %0d", dut.regfile.regs[1]);
        $display("x2 = %0d", dut.regfile.regs[2]);
        $display("x3 = %0d", dut.regfile.regs[3]);

        if (dut.regfile.regs[3] !== 32'd42)
            $fatal(1, "MUL FAIL: expected 42");

        $display("ARC-01 MUL: PASS");
        $finish;
    end
endmodule
