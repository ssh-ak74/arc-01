`timescale 1ns/1ps

module control_tb;

    logic [6:0] opcode;

    logic reg_write;
    logic alu_src;
    logic mem_read;
    logic mem_write;
    logic branch;
    logic jump;

    arc01_control dut (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump)
    );

    initial begin

        // R-type
        opcode = 7'b0110011;
        #1;

        if (reg_write !== 1'b1 ||
            alu_src   !== 1'b0 ||
            mem_read  !== 1'b0 ||
            mem_write !== 1'b0 ||
            branch    !== 1'b0 ||
            jump      !== 1'b0) begin

            $display("FAIL: R-type control");
            $finish;
        end

        // LW
        opcode = 7'b0000011;
        #1;

        if (reg_write !== 1'b1 ||
            alu_src   !== 1'b1 ||
            mem_read  !== 1'b1 ||
            mem_write !== 1'b0) begin

            $display("FAIL: LW control");
            $finish;
        end

        // SW
        opcode = 7'b0100011;
        #1;

        if (reg_write !== 1'b0 ||
            alu_src   !== 1'b1 ||
            mem_read  !== 1'b0 ||
            mem_write !== 1'b1) begin

            $display("FAIL: SW control");
            $finish;
        end

        // Branch
        opcode = 7'b1100011;
        #1;

        if (branch !== 1'b1 ||
            reg_write !== 1'b0) begin

            $display("FAIL: Branch control");
            $finish;
        end

        // JAL
        opcode = 7'b1101111;
        #1;

        if (jump !== 1'b1 ||
            reg_write !== 1'b1) begin

            $display("FAIL: JAL control");
            $finish;
        end

        $display("ARC-01 CONTROL: PASS");

        $finish;
    end

endmodule