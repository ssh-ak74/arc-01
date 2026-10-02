module arc01_decoder (
    input  logic [31:0] instruction,

    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,

    output logic [2:0]  funct3,
    output logic [6:0]  funct7,

    output logic [3:0]  alu_op,
    output logic        reg_write
);

    // RISC-V R-type opcode
    localparam logic [6:0] OPCODE_R = 7'b0110011;

    always_comb begin
        // Extract instruction fields
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        funct7 = instruction[31:25];

        // Safe defaults
        alu_op    = 4'b0000;
        reg_write = 1'b0;

        // Decode R-type instructions
        if (instruction[6:0] == OPCODE_R) begin
            reg_write = 1'b1;

            case ({funct7, funct3})
                10'b0000000_000: alu_op = 4'b0000; // ADD
                10'b0100000_000: alu_op = 4'b0001; // SUB
                10'b0000000_111: alu_op = 4'b0010; // AND
                10'b0000000_110: alu_op = 4'b0011; // OR
                10'b0000000_100: alu_op = 4'b0100; // XOR
                10'b0000000_001: alu_op = 4'b0101; // SLL
                10'b0000000_101: alu_op = 4'b0110; // SRL
                10'b0100000_101: alu_op = 4'b0111; // SRA
                10'b0000000_010: alu_op = 4'b1000; // SLT
                10'b0000000_011: alu_op = 4'b1001; // SLTU

                default: begin
                    alu_op    = 4'b0000;
                    reg_write = 1'b0;
                end
            endcase
        end
    end

endmodule