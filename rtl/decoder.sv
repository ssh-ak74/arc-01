module arc01_decoder (
    input  logic [31:0] instruction,

    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,

    output logic [2:0] funct3,
    output logic [6:0] funct7,

    output logic [3:0] alu_op
);

    localparam logic [6:0] OPCODE_R = 7'b0110011;
    localparam logic [6:0] OPCODE_I = 7'b0010011;
    localparam logic [6:0] OPCODE_LOAD  = 7'b0000011;
    localparam logic [6:0] OPCODE_STORE = 7'b0100011;

    always_comb begin
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        funct7 = instruction[31:25];

        // Default ALU operation: ADD
        alu_op = 4'b0000;

        case (instruction[6:0])

            // R-type
            OPCODE_R: begin
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
                    default:          alu_op = 4'b0000;
                endcase
            end

            // I-type
            OPCODE_I: begin
                case (funct3)
                    3'b000: alu_op = 4'b0000; // ADDI
                    default: alu_op = 4'b0000;
                endcase
            end

            default: begin
                alu_op = 4'b0000;
            end

            // Load / Store
            OPCODE_LOAD,
            OPCODE_STORE: begin
                alu_op = 4'b0000; // ADD address
            end

            // Branch
            7'b1100011: begin
                case (funct3)
                    3'b000: alu_op = 4'b0001; // BEQ: subtract rs1 - rs2
                    default: alu_op = 4'b0000;
                endcase
            end

        endcase
    end

endmodule