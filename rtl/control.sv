module arc01_control (
    input  logic [6:0] opcode,

    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_read,
    output logic       mem_write,
    output logic       branch,
    output logic       jump
);

    // RISC-V opcodes
    localparam logic [6:0] OPCODE_R     = 7'b0110011;
    localparam logic [6:0] OPCODE_LOAD  = 7'b0000011;
    localparam logic [6:0] OPCODE_STORE = 7'b0100011;
    localparam logic [6:0] OPCODE_BRANCH = 7'b1100011;
    localparam logic [6:0] OPCODE_JAL   = 7'b1101111;
    localparam logic [6:0] OPCODE_JALR  = 7'b1100111;
    localparam logic [6:0] OPCODE_I     = 7'b0010011;
    localparam logic [6:0] OPCODE_LUI   = 7'b0110111;

    always_comb begin
        // Safe defaults
        reg_write = 1'b0;
        alu_src   = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        branch    = 1'b0;
        jump      = 1'b0;

        case (opcode)

            // R-type: ADD, SUB, AND, OR, ...
            OPCODE_R: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
            end

            // I-type ALU: ADDI, ANDI, ORI, ...
            OPCODE_I: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end

            // Load: LW
            OPCODE_LOAD: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                mem_read  = 1'b1;
            end

            // Store: SW
            OPCODE_STORE: begin
                alu_src   = 1'b1;
                mem_write = 1'b1;
            end

            // Branch: BEQ, BNE, ...
            OPCODE_BRANCH: begin
                branch = 1'b1;
            end

            // JAL
            OPCODE_JAL: begin
                reg_write = 1'b1;
                jump      = 1'b1;
            end

            // JALR
            OPCODE_JALR: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                jump      = 1'b1;
            end
	
	    // LUI
		OPCODE_LUI: begin
    		reg_write = 1'b1;
		end
			
            default: begin
                // Keep safe defaults
            end

        endcase
    end

endmodule