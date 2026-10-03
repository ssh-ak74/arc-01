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

        // 0x0000: ADDI x2, x0, 42
        // 0x0004: SW   x2, 0(x0)
        // 0x0008: LW   x1, 0(x0)

        dut.imem.memory[0] = 32'h02A00113;
        dut.imem.memory[1] = 32'h00202023;
        dut.imem.memory[2] = 32'h00002083;

        #10;
        reset = 0;

        // Execute ADDI
        #10;
        if (dut.regfile.regs[2] !== 32'd42) begin
            $display("FAIL: ADDI");
            $finish;
        end

        // Execute SW
        #10;
        if (dut.data_memory.memory[0] !== 32'd42) begin
            $display("FAIL: SW");
            $finish;
        end

        // Execute LW
        #10;
        if (dut.regfile.regs[1] !== 32'd42) begin
            $display("FAIL: LW");
            $finish;
        end

        $display("ARC-01 CPU: LW PASS");
        $display("x1 = %0d", dut.regfile.regs[1]);

        $finish;
    end

endmodule