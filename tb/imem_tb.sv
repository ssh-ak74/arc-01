module imem_tb;

    logic [31:0] address;
    logic [31:0] instruction;

    arc01_imem dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        // Put test instructions into memory
        dut.memory[0] = 32'h12345678;
        dut.memory[1] = 32'hDEADBEEF;
        dut.memory[2] = 32'hCAFEBABE;

        // Address 0x00
        address = 32'h00000000;
        #1;

        if (instruction !== 32'h12345678) begin
            $display("FAIL: address 0x00");
            $finish;
        end

        // Address 0x04
        address = 32'h00000004;
        #1;

        if (instruction !== 32'hDEADBEEF) begin
            $display("FAIL: address 0x04");
            $finish;
        end

        // Address 0x08
        address = 32'h00000008;
        #1;

        if (instruction !== 32'hCAFEBABE) begin
            $display("FAIL: address 0x08");
            $finish;
        end

        $display("ARC-01 IMEM: PASS");
        $finish;
    end

endmodule
