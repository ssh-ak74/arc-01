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
        // 0x0000: ADDI x2, x0, 42
        // 0x0004: SW   x2, 0(x0)

        dut.imem.memory[0] = 32'h02A00113;
        dut.imem.memory[1] = 32'h00202023;

        // Reset
        #10;

        reset = 0;

        // Execute ADDI
        #10;

        if (dut.regfile.regs[2] !== 32'd42) begin
            $display("FAIL: x2 = %0d, expected 42", dut.regfile.regs[2]);
            $finish;
        end

        // Execute SW
        #10;

        if (dut.data_memory.memory[0] !== 32'd42) begin
            $display("FAIL: memory[0] = %0d, expected 42",
                     dut.data_memory.memory[0]);
            $finish;
        end

        $display("ARC-01 CPU: SW PASS");
        $display("memory[0] = %0d", dut.data_memory.memory[0]);

        $finish;
    end

endmodule