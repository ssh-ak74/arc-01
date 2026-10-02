`timescale 1ns/1ps

module immgen_tb;

    logic [31:0] instruction;
    logic [31:0] immediate;

    arc01_immgen dut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin

        // ------------------------------------------------
        // I-type: ADDI x1, x2, 10
        // ------------------------------------------------
        instruction = 32'b000000001010_00010_000_00001_0010011;
        #1;

        if (immediate !== 32'd10) begin
            $display("FAIL: I-type positive immediate");
            $finish;
        end

        // I-type negative immediate: -1
        instruction = 32'b111111111111_00010_000_00001_0010011;
        #1;

        if (immediate !== 32'hFFFFFFFF) begin
            $display("FAIL: I-type negative immediate");
            $finish;
        end

        // ------------------------------------------------
        // S-type: SW x5, 20(x6)
        // ------------------------------------------------
        instruction = 32'b0000000_00101_00110_010_10100_0100011;
        #1;

        if (immediate !== 32'd20) begin
            $display("FAIL: S-type immediate");
            $finish;
        end

        // ------------------------------------------------
        // B-type
        // Branch immediate = 16
        // ------------------------------------------------
        instruction = 32'b0000000_00010_00001_000_1000_0_1100011;
        #1;

        if (immediate !== 32'd16) begin
            $display("FAIL: B-type immediate");
            $finish;
        end

        // ------------------------------------------------
        // U-type: LUI
        // immediate = 0x12345000
        // ------------------------------------------------
        instruction = 32'h123450B7;
        #1;

        if (immediate !== 32'h12345000) begin
            $display("FAIL: U-type immediate");
            $finish;
        end

        // ------------------------------------------------
        // J-type
        // JAL immediate = 2048
        // ------------------------------------------------
        instruction = 32'h0010006F;
        #1;

        if (immediate !== 32'd2048) begin
            $display("FAIL: J-type immediate");
            $finish;
        end

        $display("ARC-01 IMMGEN: PASS");

        $finish;
    end

endmodule