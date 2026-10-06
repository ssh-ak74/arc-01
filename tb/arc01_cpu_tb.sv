module arc01_cpu_tb;

    logic clk;
    logic reset;

    arc01 dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // 0x0000: ADDI x1, x0, 15
        // 0x0004: ANDI x2, x1, 10
        // 15 & 10 = 10

        dut.imem.memory[0] = 32'h00F00093;
        dut.imem.memory[1] = 32'h00A0F113;

        #10;
        reset = 0;

        #10;
        #10;

        if (dut.regfile.regs[2] !== 32'd10) begin
            $display("FAIL: ANDI");
            $display("x2 = %0d", dut.regfile.regs[2]);
            $finish;
        end

        $display("ARC-01 CPU: ANDI PASS");
        $display("x2 = %0d", dut.regfile.regs[2]);

        $finish;
    end

endmodule