module arc01_imem (
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    always_comb begin
        instruction = memory[address[9:2]];
    end

endmodule