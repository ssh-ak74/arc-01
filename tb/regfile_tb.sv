`timescale 1ns/1ps

module regfile_tb;

    logic        clk;
    logic        we;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [31:0] wd;
    logic [31:0] rd1;
    logic [31:0] rd2;

    arc01_regfile dut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        we  = 0;
        rs1 = 0;
        rs2 = 0;
        rd  = 0;
        wd  = 0;

        // x0 must always be zero
        #1;
        if (rd1 !== 32'd0) begin
            $display("FAIL: x0 is not zero");
            $finish;
        end

        // Write 123 to x1
        @(negedge clk);
        we = 1;
        rd = 5'd1;
        wd = 32'd123;

        @(posedge clk);
        #1;
        we = 0;

        // Read x1
        rs1 = 5'd1;
        #1;

        if (rd1 !== 32'd123) begin
            $display("FAIL: x1 should be 123");
            $finish;
        end

        // Write 456 to x2
        @(negedge clk);
        we = 1;
        rd = 5'd2;
        wd = 32'd456;

        @(posedge clk);
        #1;
        we = 0;

        // Read x1 and x2 simultaneously
        rs1 = 5'd1;
        rs2 = 5'd2;
        #1;

        if (rd1 !== 32'd123) begin
            $display("FAIL: x1 changed");
            $finish;
        end

        if (rd2 !== 32'd456) begin
            $display("FAIL: x2 should be 456");
            $finish;
        end

        // Try to overwrite x0
        @(negedge clk);
        we = 1;
        rd = 5'd0;
        wd = 32'hDEADBEEF;

        @(posedge clk);
        #1;
        we = 0;

        rs1 = 5'd0;
        #1;

        if (rd1 !== 32'd0) begin
            $display("FAIL: x0 was modified");
            $finish;
        end

        $display("ARC-01 REGFILE: PASS");

        $finish;
    end

endmodule