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

        // ADDI x1, x0, 10
        // SLTI  x2, x1, 20
        // 10 | < 10 → 1

        dut.imem.memory[0] = 32'h00A00093;
	dut.imem.memory[1] = 32'h0140A113;

        #10;
        reset = 0;

        #30;

if (dut.regfile.regs[2] !== 32'd1) begin
    $display("FAIL: SLTI");
    $display("x2 = %0d", dut.regfile.regs[2]);
    $finish;
end

$display("ARC-01 CPU: SLTI PASS");
$display("x2 = %0d", dut.regfile.regs[2]);

        $finish;
    end

endmodule