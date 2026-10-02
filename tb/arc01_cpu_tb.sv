`timescale 1ns/1ps

module arc01_cpu_tb;

    logic clk;
    logic reset;

    arc01 dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    // ADD x1, x2, x3
    //
    // funct7 = 0000000
    // rs2    = 00011
    // rs1    = 00010
    // funct3 = 000
    // rd     = 00001
    // opcode = 0110011
    //
    // Encoding = 0x003100B3
    //
    initial begin

        clk   = 0;
        reset = 1;

        // Give the CPU one reset cycle
        @(posedge clk);
        #1;

        reset = 0;

        // ------------------------------------------------
        // Prepare registers
        // ------------------------------------------------

        // x2 = 10
        dut.regfile.regs[2] = 32'd10;

        // x3 = 20
        dut.regfile.regs[3] = 32'd20;

        // ------------------------------------------------
        // Execute ADD x1, x2, x3
        // ------------------------------------------------

        dut.instruction = 32'h003100B3;

        @(posedge clk);
        #1;

        // ------------------------------------------------
        // Check result
        // ------------------------------------------------

        if (dut.regfile.regs[1] !== 32'd30) begin
            $display("FAIL: x1 should be 30");
            $display("x1 = %d", dut.regfile.regs[1]);
            $finish;
        end

        $display("ARC-01 CPU: ADD PASS");

        $finish;

    end

endmodule