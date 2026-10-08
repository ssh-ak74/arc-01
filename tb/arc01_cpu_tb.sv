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

dut.imem.memory[0] = 32'h04000093; // ADDI x1, x0, 64
dut.imem.memory[1] = 32'h0020D113; // SRLI x2, x1, 2

        #10;
        reset = 0;

        #30;

if (dut.regfile.regs[2] !== 32'd16) begin
    $display("FAIL: SRLI");
    $display("x2 = %0d", dut.regfile.regs[2]);
    $finish;
end

$display("ARC-01 CPU: SRLI PASS");
$display("x2 = %0d", dut.regfile.regs[2]);
        $finish;
    end

endmodule