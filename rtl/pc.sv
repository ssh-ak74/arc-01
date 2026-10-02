module arc01_pc (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (reset)
            pc <= 32'h00000000;
        else
            pc <= pc + 32'd4;
    end

endmodule