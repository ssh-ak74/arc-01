`timescale 1ns/1ps

module arc01_c_tb;
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

        $readmemh("programs/first.hex", dut.imem.memory);

        // Simulate a caller returning to address 12.
        dut.regfile.regs[1] = 32'd12;

        @(posedge clk);
        #1;
        reset = 0;

        // Execute ADDI, RET, then the NOP at address 12.
        repeat (3) @(posedge clk);
        #1;

        if (dut.regfile.regs[10] !== 32'd42)
            $fatal(1, "FAIL: a0 expected 42, got %0d",
                   $signed(dut.regfile.regs[10]));

        if (dut.pc !== 32'd16)
            $fatal(1, "FAIL: PC expected 16, got %0d", dut.pc);

        $display("ARC-01 C PROGRAM: PASS");
        $display("main() result: %0d",
                 $signed(dut.regfile.regs[10]));
        $display("RET verified: PC = 0x%08h", dut.pc);

        $finish;
    end
endmodule
