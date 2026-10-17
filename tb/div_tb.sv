module div_tb;

    logic clk = 0;
    logic reset = 1;
    integer i;

    arc01 dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    function automatic [31:0] enc_r(
        input [6:0] funct7,
        input [4:0] rs2,
        input [4:0] rs1,
        input [2:0] funct3,
        input [4:0] rd
    );
        enc_r = {funct7, rs2, rs1, funct3, rd, 7'h33};
    endfunction

    function automatic [31:0] enc_i(
        input logic signed [11:0] imm,
        input [4:0] rs1,
        input [4:0] rd
    );
        enc_i = {imm, rs1, 3'b000, rd, 7'h13};
    endfunction

    initial begin
        for (i = 0; i < 256; i = i + 1)
            dut.imem.memory[i] = 32'h00000013;

        // Set up operands
        dut.imem.memory[0]  = enc_i(12'd20,  5'd0, 5'd1);
        dut.imem.memory[1]  = enc_i(12'd4,   5'd0, 5'd2);

        // DIV and DIVU: 20 / 4 = 5
        dut.imem.memory[2]  = enc_r(7'b0000001, 5'd2, 5'd1, 3'b100, 5'd3);
        dut.imem.memory[3]  = enc_r(7'b0000001, 5'd2, 5'd1, 3'b101, 5'd4);

        // REM and REMU: 20 % 6 = 2
        dut.imem.memory[4]  = enc_i(12'd6, 5'd0, 5'd5);
        dut.imem.memory[5]  = enc_r(7'b0000001, 5'd5, 5'd1, 3'b110, 5'd6);
        dut.imem.memory[6]  = enc_r(7'b0000001, 5'd5, 5'd1, 3'b111, 5'd7);

        // Signed: -20 / 4 = -5; -20 % 6 = -2
        dut.imem.memory[7]  = enc_i(-12'sd20, 5'd0, 5'd8);
        dut.imem.memory[8]  = enc_r(7'b0000001, 5'd2, 5'd8, 3'b100, 5'd9);
        dut.imem.memory[9]  = enc_r(7'b0000001, 5'd5, 5'd8, 3'b110, 5'd10);

        // Division by zero: quotient = -1; remainder = dividend
        dut.imem.memory[10] = enc_r(7'b0000001, 5'd0, 5'd1, 3'b100, 5'd11);
        dut.imem.memory[11] = enc_r(7'b0000001, 5'd0, 5'd8, 3'b110, 5'd12);

        // INT_MIN / -1 overflow case
        dut.imem.memory[12] = 32'h800006B7; // LUI x13, 0x80000
        dut.imem.memory[13] = enc_i(-12'sd1, 5'd0, 5'd14);
        dut.imem.memory[14] = enc_r(7'b0000001, 5'd14, 5'd13, 3'b100, 5'd15);
        dut.imem.memory[15] = enc_r(7'b0000001, 5'd14, 5'd13, 3'b110, 5'd16);

        dut.imem.memory[16] = 32'h0000006F; // Stop: JAL x0, 0

        repeat (2) @(posedge clk);
        #1 reset = 0;

        repeat (25) @(posedge clk);
        #1;

        $display("DIV   20 / 4    = %h", dut.regfile.regs[3]);
        $display("DIVU  20 / 4    = %h", dut.regfile.regs[4]);
        $display("REM   20 %% 6    = %h", dut.regfile.regs[6]);
        $display("REMU  20 %% 6    = %h", dut.regfile.regs[7]);
        $display("DIV  -20 / 4    = %h", dut.regfile.regs[9]);
        $display("REM  -20 %% 6    = %h", dut.regfile.regs[10]);
        $display("DIV   20 / 0    = %h", dut.regfile.regs[11]);
        $display("REM  -20 %% 0    = %h", dut.regfile.regs[12]);
        $display("DIV  INT_MIN/-1 = %h", dut.regfile.regs[15]);
        $display("REM  INT_MIN/-1 = %h", dut.regfile.regs[16]);

        if (dut.regfile.regs[3]  !== 32'd5 ||
            dut.regfile.regs[4]  !== 32'd5 ||
            dut.regfile.regs[6]  !== 32'd2 ||
            dut.regfile.regs[7]  !== 32'd2 ||
            dut.regfile.regs[9]  !== 32'hFFFFFFFB ||
            dut.regfile.regs[10] !== 32'hFFFFFFFE ||
            dut.regfile.regs[11] !== 32'hFFFFFFFF ||
            dut.regfile.regs[12] !== 32'hFFFFFFEC ||
            dut.regfile.regs[15] !== 32'h80000000 ||
            dut.regfile.regs[16] !== 32'd0)
            $fatal(1, "ARC-01 DIV/REM: FAIL");

        $display("ARC-01 DIVISION AND REMAINDER: PASS");
        $finish;
    end

endmodule
