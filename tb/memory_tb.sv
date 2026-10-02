`timescale 1ns/1ps

module memory_tb;

    logic        clk;
    logic [31:0] address;
    logic [31:0] write_data;
    logic        mem_write;
    logic        mem_read;
    logic [31:0] read_data;

    arc01_memory dut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk        = 0;
        address    = 32'd0;
        write_data = 32'd0;
        mem_write  = 0;
        mem_read   = 0;

        // Write 0xDEADBEEF to address 0x00
        @(negedge clk);
        address    = 32'h00000000;
        write_data = 32'hDEADBEEF;
        mem_write  = 1;

        @(posedge clk);
        #1;
        mem_write = 0;

        // Read it back
        mem_read = 1;
        #1;

        if (read_data !== 32'hDEADBEEF) begin
            $display("FAIL: memory read at 0x00");
            $finish;
        end

        // Write another value to address 0x04
        @(negedge clk);
        address    = 32'h00000004;
        write_data = 32'h12345678;
        mem_write  = 1;

        @(posedge clk);
        #1;
        mem_write = 0;

        // Read address 0x04
        mem_read = 1;
        #1;

        if (read_data !== 32'h12345678) begin
            $display("FAIL: memory read at 0x04");
            $finish;
        end

        // Make sure address 0x00 still contains its value
        address = 32'h00000000;
        #1;

        if (read_data !== 32'hDEADBEEF) begin
            $display("FAIL: memory at 0x00 changed");
            $finish;
        end

        $display("ARC-01 MEMORY: PASS");

        $finish;
    end

endmodule