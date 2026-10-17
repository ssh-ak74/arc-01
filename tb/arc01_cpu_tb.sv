`timescale 1ns/1ps

module arc01_cpu_tb;
logic clk = 0;
logic reset = 1;
integer i;
arc01 dut (
.clk(clk),
.reset(reset)
);
always #5 clk = ~clk;
initial begin
// Initialize unused instruction slots to NOP.
for (i = 0; i < 256; i = i + 1)
dut.imem.memory[i] = 32'h00000013;
        $readmemh("programs/regression.hex", dut.imem.memory);
// Hold reset through the first rising edge.
        @(posedge clk);
        #1;
        reset = 0;
// Allow the three instructions to execute.
        repeat (4) @(posedge clk);
        #1;
if (dut.regfile.regs[1] !== 32'd30)
            $fatal(1, "FAIL: x1 expected 30, got %0d",
                   $signed(dut.regfile.regs[1]));
if (dut.regfile.regs[2] !== 32'd10)
            $fatal(1, "FAIL: x2 expected 10, got %0d",
                   $signed(dut.regfile.regs[2]));
if (dut.regfile.regs[3] !== 32'd20)
            $fatal(1, "FAIL: x3 expected 20, got %0d",
                   $signed(dut.regfile.regs[3]));
$display("ARC-01 CPU REGRESSION: PASS");
        $display("x1 = %0d, x2 = %0d, x3 = %0d",
                 $signed(dut.regfile.regs[1]),
                 $signed(dut.regfile.regs[2]),
                 $signed(dut.regfile.regs[3]));
$finish;
    end
endmodule
