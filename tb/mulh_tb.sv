
module mulh_tb;

    logic clk = 0;
    logic reset = 1;

    arc01 dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        dut.imem.memory[0] = 32'h800000B7; // LUI x1, 0x80000
        dut.imem.memory[1] = 32'h00200113; // ADDI x2, x0, 2
        dut.imem.memory[2] = 32'h022081B3; // MUL    x3, x1, x2
        dut.imem.memory[3] = 32'h02209233; // MULH   x4, x1, x2
        dut.imem.memory[4] = 32'h0220B2B3; // MULHU  x5, x1, x2
        dut.imem.memory[5] = 32'h0220A333; // MULHSU x6, x1, x2
        dut.imem.memory[6] = 32'h0000006F; // JAL x0, 0

        repeat (2) @(posedge clk);
        #1 reset = 0;

        repeat (12) @(posedge clk);
        #1;

        $display("x1 MUL operand = %h", dut.regfile.regs[1]);
        $display("MUL    x3 = %h", dut.regfile.regs[3]);
        $display("MULH   x4 = %h", dut.regfile.regs[4]);
        $display("MULHU  x5 = %h", dut.regfile.regs[5]);
        $display("MULHSU x6 = %h", dut.regfile.regs[6]);

        if (dut.regfile.regs[3] !== 32'h00000000)
            $fatal(1, "MUL failed");

        if (dut.regfile.regs[4] !== 32'hFFFFFFFF)
            $fatal(1, "MULH failed");

        if (dut.regfile.regs[5] !== 32'h00000001)
            $fatal(1, "MULHU failed");

        if (dut.regfile.regs[6] !== 32'hFFFFFFFF)
            $fatal(1, "MULHSU failed");

        $display("ARC-01 RV32M MULTIPLICATION: PASS");
        $finish;
    end

endmodule
