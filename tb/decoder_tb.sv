`timescale 1ns/1ps

module decoder_tb;

    logic [31:0] instruction;

    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [3:0]  alu_op;
    logic        reg_write;

    arc01_decoder dut (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op),
        .reg_write(reg_write)
    );

    initial begin

        // ADD x1, x2, x3
        // funct7 = 0000000
        // rs2    = 00011
        // rs1    = 00010
        // funct3 = 000
        // rd     = 00001
        // opcode = 0110011
        instruction = 32'b0000000_00011_00010_000_00001_0110011;

        #1;

        if (rs1 !== 5'd2) begin
            $display("FAIL: rs1");
            $finish;
        end

        if (rs2 !== 5'd3) begin
            $display("FAIL: rs2");
            $finish;
        end

        if (rd !== 5'd1) begin
            $display("FAIL: rd");
            $finish;
        end

        if (alu_op !== 4'b0000) begin
            $display("FAIL: ADD ALU operation");
            $finish;
        end

        if (reg_write !== 1'b1) begin
            $display("FAIL: ADD reg_write");
            $finish;
        end

        // SUB x5, x6, x7
        instruction = 32'b0100000_00111_00110_000_00101_0110011;

        #1;

        if (rs1 !== 5'd6) begin
            $display("FAIL: SUB rs1");
            $finish;
        end

        if (rs2 !== 5'd7) begin
            $display("FAIL: SUB rs2");
            $finish;
        end

        if (rd !== 5'd5) begin
            $display("FAIL: SUB rd");
            $finish;
        end

        if (alu_op !== 4'b0001) begin
            $display("FAIL: SUB ALU operation");
            $finish;
        end

        if (reg_write !== 1'b1) begin
            $display("FAIL: SUB reg_write");
            $finish;
        end

        $display("ARC-01 DECODER: PASS");

        $finish;
    end

endmodule