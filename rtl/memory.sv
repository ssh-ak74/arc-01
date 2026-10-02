module arc01_memory (
    input  logic        clk,

    input  logic [31:0] address,
    input  logic [31:0] write_data,

    input  logic        mem_write,
    input  logic        mem_read,

    output logic [31:0] read_data
);

    // 256 x 32-bit words = 1 KiB
    logic [31:0] memory [0:255];

    // Combinational read
    always_comb begin
        if (mem_read)
            read_data = memory[address[9:2]];
        else
            read_data = 32'd0;
    end

    // Synchronous write
    always_ff @(posedge clk) begin
        if (mem_write)
            memory[address[9:2]] <= write_data;
    end

endmodule