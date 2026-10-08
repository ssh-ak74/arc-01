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

dut.imem.memory[0] = 32'hFF000093; // ADDI x1, x0, -16
dut.imem.memory[1] = 32'h4020D113; // SRAI x2, x1, 2

        #10;
        reset = 0;

        #30;

if (dut.regfile.regs[2] !== 32'hFFFFFFFC) begin
    $display("FAIL: SRAI");
    $display("x2 = %h", dut.regfile.regs[2]);
    $finish;
end

$display("ARC-01 CPU: SRAI PASS");
$display("x2 = %h", dut.regfile.regs[2]);
        $finish;
    end

endmodule