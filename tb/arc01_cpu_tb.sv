
module arc01_cpu_tb;

    logic clk = 0;
    logic reset = 1;

    arc01 dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $readmemh("programs/math.hex", dut.imem.memory);

        #10;
        reset = 0;

        // Wait for the three instructions to execute.
        #40;

        $display("x1 = %0d", $signed(dut.regfile.regs[1]));
        $display("x2 = %0d", $signed(dut.regfile.regs[2]));
        $display("x3 = %0d", $signed(dut.regfile.regs[3]));

        $finish;
    end

endmodule