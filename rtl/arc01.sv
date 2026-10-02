module arc01 (
    input logic clk,
    input logic reset
);

    // -------------------------
    // Program Counter
    // -------------------------

    logic [31:0] pc;

    arc01_pc pc_unit (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // -------------------------
    // Instruction
    // -------------------------

    logic [31:0] instruction;

    // -------------------------
    // Decoder
    // -------------------------

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [2:0] funct3;
    logic [6:0] funct7;

    logic [3:0] alu_op;
    logic       reg_write;

    arc01_decoder decoder (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op),
        .reg_write(reg_write)
    );

    // -------------------------
    // Register File
    // -------------------------

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

    // -------------------------
    // ALU
    // -------------------------

    logic [31:0] alu_result;
    logic        alu_zero;

    arc01_alu alu (
        .a(reg_data1),
        .b(reg_data2),
        .op(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );

    // ALU result goes back to register file
    assign write_data = alu_result;

endmodule