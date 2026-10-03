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

        // 0x0000: ADDI x1, x0, 12
        // 0x0004: JALR x5, x1, 0
        // 0x0008: ADDI x2, x0, 99   <- should be skipped
        // 0x000C: ADDI x2, x0, 42   <- JALR target

        dut.imem.memory[0] = 32'h00C00093;
        dut.imem.memory[1] = 32'h000082E7;
        dut.imem.memory[2] = 32'h06300113;
        dut.imem.memory[3] = 32'h02A00113;

        #10;
        reset = 0;

        #10; // ADDI x1
        #10; // JALR

        if (dut.regfile.regs[5] !== 32'd8) begin
            $display("FAIL: JALR link");
            $display("x5 = %0d", dut.regfile.regs[5]);
            $finish;
        end

        #10; // execute target

        if (dut.regfile.regs[2] !== 32'd42) begin
            $display("FAIL: JALR jump");
            $display("x2 = %0d", dut.regfile.regs[2]);
            $finish;
        end

        $display("ARC-01 CPU: JALR PASS");
        $display("x5 = %0d", dut.regfile.regs[5]);
        $display("x2 = %0d", dut.regfile.regs[2]);

        $finish;
    end

endmodule