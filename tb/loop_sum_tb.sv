`timescale 1ns/1ps

module loop_sum_tb;

    logic clk = 0;
    logic reset = 1;
    integer i;

    arc01 dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        // Initialize instruction memory to NOPs.
        for (i = 0; i < 256; i = i + 1)
            dut.imem.memory[i] = 32'h00000013;

        // Load the six-instruction loop program.
        $readmemh("programs/loop_sum.hex",
                  dut.imem.memory, 0, 5);

        // Reset the CPU.
        @(posedge clk);
        #1;
        reset = 0;

        // Allow the loop and final branch to complete.
        repeat (22) @(posedge clk);
        #1;

        $display("Counter x1 = %0d",
                 $signed(dut.regfile.regs[1]));
        $display("Sum x2 = %0d",
                 $signed(dut.regfile.regs[2]));
        $display("Limit x3 = %0d",
                 $signed(dut.regfile.regs[3]));

        if (dut.regfile.regs[1] !== 32'd6)
            $fatal(1, "FAIL: expected counter x1 = 6");

        if (dut.regfile.regs[2] !== 32'd15)
            $fatal(1, "FAIL: expected sum x2 = 15");

        if (dut.regfile.regs[3] !== 32'd6)
            $fatal(1, "FAIL: expected limit x3 = 6");

        $display("ARC-01 LOOP SUM: PASS");
        $finish;
    end

endmodule
