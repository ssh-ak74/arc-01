module arc01 (
    input logic clk,
    input logic reset
);

    logic [31:0] pc;
    logic [31:0] next_pc;
    logic [31:0] immediate;
    logic [31:0] instruction;
    logic [31:0] pc_plus_4;
    logic [31:0] alu_result;

    logic branch;
    logic jump;
    logic alu_zero;


assign next_pc = (jump && instruction[6:0] == 7'b1100111)
               ? {alu_result[31:1], 1'b0}
               : jump
               ? pc + immediate
               : (branch && (
    (instruction[14:12] == 3'b000 && alu_zero) ||
    (instruction[14:12] == 3'b001 && !alu_zero) ||
    (instruction[14:12] == 3'b100 && (alu_result != 32'd0)) ||
    (instruction[14:12] == 3'b101 && (alu_result == 32'd0))
))
               ? pc + immediate
               : pc + 32'd4;

    assign pc_plus_4 = pc + 32'd4;
 
    arc01_pc pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // =========================
    // Instruction Memory
    // =========================

    arc01_imem imem (
        .address(pc),
        .instruction(instruction)
    );

    // =========================
    // Decoder
    // =========================

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [2:0] funct3;
    logic [6:0] funct7;

    logic [3:0] alu_op;

    arc01_decoder decoder (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op)
    );

    // =========================
    // Immediate Generator
    // =========================


    arc01_immgen immgen (
        .instruction(instruction),
        .immediate(immediate)
    );

    // =========================
    // Control Unit
    // =========================

    logic reg_write;
    logic alu_src;
    logic mem_read;
    logic mem_write;

    arc01_control control (
        .opcode(instruction[6:0]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump)
    );

    // =========================
    // Register File
    // =========================

    logic [31:0] reg_data1;
    logic [31:0] reg_data2;
    logic [31:0] write_data;

    arc01_regfile regfile (
        .clk(clk),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_data),
        .rd1(reg_data1),
        .rd2(reg_data2)
    );

    // =========================
    // ALU Input
    // =========================

    logic [31:0] alu_b;

    assign alu_b = alu_src ? immediate : reg_data2;

    // =========================
    // ALU
    // =========================

    arc01_alu alu (
        .a(reg_data1),
        .b(alu_b),
        .op(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );

// =========================
// Data Memory
// =========================

logic [31:0] memory_data;

arc01_memory data_memory (
    .clk(clk),
    .address(alu_result),
    .write_data(reg_data2),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .read_data(memory_data)
);

// =========================
// Writeback
// =========================

assign write_data = jump
                  ? pc_plus_4
                  : mem_read
                  ? memory_data
                  : alu_result;

endmodule