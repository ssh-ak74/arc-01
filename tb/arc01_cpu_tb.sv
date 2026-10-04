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

        // 0x0000: ADDI x1, x0, 20
        // 0x0004: ADDI x2, x0, 10
        // 0x0008: BGEU x1, x2, +8
        // 0x000C: ADDI x3, x0, 99   <- should be skipped
        // 0x0010: ADDI x3, x0, 42   <- branch target

        dut.imem.memory[0] = 32'h01400093;
        dut.imem.memory[1] = 32'h00A00113;
        dut.imem.memory[2] = 32'h0020F463;
        dut.imem.memory[3] = 32'h06300193;
        dut.imem.memory[4] = 32'h02A00193;

        #10;
        reset = 0;

        #10;
        #10;
        #10;
        #10;

        if (dut.regfile.regs[3] !== 32'd42) begin
            $display("FAIL: BGEU");
            $display("x3 = %0d", dut.regfile.regs[3]);
            $finish;
        end

        $display("ARC-01 CPU: BGEU PASS");
        $display("x3 = %0d", dut.regfile.regs[3]);

        $finish;
    end

endmodule