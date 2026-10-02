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

        // Program:
        // 0x0000: ADDI x2, x0, 10
        // 0x0004: ADDI x3, x0, 20
        // 0x0008: ADD  x1, x2, x3

        dut.imem.memory[0] = 32'h00A00113;
        dut.imem.memory[1] = 32'h01400193;
        dut.imem.memory[2] = 32'h003100B3;

        // Reset CPU
        #10;

        if (dut.pc !== 32'h00000000) begin
            $display("FAIL: PC reset");
            $finish;
        end

        // Execute ADDI x2, x0, 10
        reset = 0;
        #10;

        if (dut.regfile.regs[2] !== 32'd10) begin
            $display("FAIL: x2 = %0d, expected 10", dut.regfile.regs[2]);
            $finish;
        end

        // Execute ADDI x3, x0, 20
        #10;

        if (dut.regfile.regs[3] !== 32'd20) begin
            $display("FAIL: x3 = %0d, expected 20", dut.regfile.regs[3]);
            $finish;
        end

        // Execute ADD x1, x2, x3
        #10;

        if (dut.regfile.regs[1] !== 32'd30) begin
            $display("FAIL: x1 = %0d, expected 30", dut.regfile.regs[1]);
            $finish;
        end

        $display("ARC-01 CPU: PROGRAM PASS");
        $display("x2 = %0d", dut.regfile.regs[2]);
        $display("x3 = %0d", dut.regfile.regs[3]);
        $display("x1 = %0d", dut.regfile.regs[1]);

        $finish;
    end

endmodule