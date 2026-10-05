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

        // 0x0000: LUI x1, 0x12345
        // x1 should become 0x12345000

        dut.imem.memory[0] = 32'h123450B7;

        #10;
        reset = 0;

        #10;

        if (dut.regfile.regs[1] !== 32'h12345000) begin
            $display("FAIL: LUI");
            $display("x1 = %h", dut.regfile.regs[1]);
            $finish;
        end

        $display("ARC-01 CPU: LUI PASS");
        $display("x1 = %h", dut.regfile.regs[1]);

        $finish;
    end

endmodule