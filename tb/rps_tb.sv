`timescale 1ns/1ps

module rps_tb;
    logic clk = 0;
    logic reset = 1;
    integer i;
    integer result;

    arc01 dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            dut.imem.memory[i] = 32'h00000013;

        $readmemh("programs/rps.hex", dut.imem.memory, 0, 23);

        @(posedge clk);
        #1 reset = 0;

        repeat (30) @(posedge clk);
        #1;

        result = $signed(dut.regfile.regs[3]);
        $display("RPS_RESULT=%0d", result);

        if (result != -1 && result != 0 && result != 1)
            $fatal(1, "FAIL: invalid result %0d", result);

        $display("ARC-01 RPS: PASS");
        $finish;
    end
endmodule
