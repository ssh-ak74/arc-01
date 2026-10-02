module arc01 (
    input logic clk,
    input logic reset
);

    // =========================
    // Program Counter
    // =========================

    logic [31:0] pc;

    arc01_pc pc_unit (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // =========================
    // Instruction Memory
    // =========================

    logic [31:0] instruction;

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

    logic [31:0] immediate;

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
    logic branch;
    logic jump;

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

    logic [31:0] alu_result;
    logic alu_zero;

    arc01_alu alu (
        .a(reg_data1),
        .b(alu_b),
        .op(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );

    // =========================
    // Writeback
    // =========================

    assign write_data = alu_result;

endmodule