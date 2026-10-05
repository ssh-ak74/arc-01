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

// 0x0000: ADDI x2, x0, 0
// 0x0004: AUIPC x1, 0x12345
// x1 should = 0x12345004

dut.imem.memory[0] = 32'h00000113;
dut.imem.memory[1] = 32'h12345097;

#10;
reset = 0;

#10; // ADDI
#10; // AUIPC

if (dut.regfile.regs[1] !== 32'h12345004) begin
    $display("FAIL: AUIPC non-zero PC");
    $display("x1 = %h", dut.regfile.regs[1]);
    $finish;
end

$display("ARC-01 CPU: AUIPC NON-ZERO PC PASS");
$display("x1 = %h", dut.regfile.regs[1]);

$finish;
    end

endmodule