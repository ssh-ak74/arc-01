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

        // 0x0000: ADDI x1, x0, 10
        // 0x0004: ADDI x2, x0, 20
        // 0x0008: BLT  x1, x2, +8
        // 0x000C: ADDI x3, x0, 99   <- should be skipped
        // 0x0010: ADDI x3, x0, 42   <- branch target

        dut.imem.memory[0] = 32'h00A00093;
        dut.imem.memory[1] = 32'h01400113;
        dut.imem.memory[2] = 32'h0020C463;
        dut.imem.memory[3] = 32'h06300193;
        dut.imem.memory[4] = 32'h02A00193;

        #10;
        reset = 0;

        #10; // ADDI x1
        #10; // ADDI x2
        #10; // BLT
        #10; // execute target

        if (dut.regfile.regs[3] !== 32'd42) begin
            $display("FAIL: BLT");
            $display("x3 = %0d", dut.regfile.regs[3]);
            $finish;
        end

        $display("ARC-01 CPU: BLT PASS");
        $display("x3 = %0d", dut.regfile.regs[3]);

        $finish;
    end

endmodule