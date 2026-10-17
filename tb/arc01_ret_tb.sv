`timescale 1ns/1ps

module arc01_ret_tb;
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

        $readmemh("programs/ret.hex", dut.imem.memory);

        @(negedge clk);
        reset = 0;

        repeat (3) @(posedge clk);
        #1;

        if (dut.pc !== 32'd16)
            $fatal(1, "FAIL: PC expected 16, got %0d", dut.pc);

        if (dut.regfile.regs[5] !== 32'd42)
            $fatal(1, "FAIL: x5 expected 42, got %0d",
                   dut.regfile.regs[5]);

        $display("ARC-01 RET: PASS");
        $display("Return target reached: PC = 0x%08h", dut.pc);
        $display("Target instruction result: x5 = %0d",
                 dut.regfile.regs[5]);

        $finish;
    end
endmodule
