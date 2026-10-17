
module arc01_alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [4:0]  op,
    output logic [31:0] result,
    output logic        zero
);

    logic signed [63:0] signed_product;
    logic        [63:0] unsigned_product;
    logic signed [64:0] mixed_product;

    always_comb begin
        signed_product   = $signed(a) * $signed(b);
        unsigned_product = a * b;
        mixed_product    = $signed({a[31], a}) * $signed({1'b0, b});

        case (op)
            5'b00000: result = a + b; // ADD
            5'b00001: result = a - b; // SUB
            5'b00010: result = a & b; // AND
            5'b00011: result = a | b; // OR
            5'b00100: result = a ^ b; // XOR
            5'b00101: result = a << b[4:0]; // SLL
            5'b00110: result = a >> b[4:0]; // SRL
            5'b00111: result = $signed(a) >>> b[4:0]; // SRA
            5'b01000: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT
            5'b01001: result = (a < b) ? 32'd1 : 32'd0; // SLTU

            5'b01010: result = unsigned_product[31:0]; // MUL
            5'b01011: result = signed_product[63:32]; // MULH
            5'b01100: result = unsigned_product[63:32]; // MULHU
            5'b01101: result = mixed_product[63:32]; // MULHSU

            5'b01110: begin // DIV
                if (b == 0)
                    result = 32'hFFFFFFFF;
                else if (a == 32'h80000000 && b == 32'hFFFFFFFF)
                    result = 32'h80000000;
                else
                    result = $signed(a) / $signed(b);
            end

            5'b01111: begin // DIVU
                if (b == 0)
                    result = 32'hFFFFFFFF;
                else
                    result = a / b;
            end

            5'b10000: begin // REM
                if (b == 0)
                    result = a;
                else if (a == 32'h80000000 && b == 32'hFFFFFFFF)
                    result = 32'd0;
                else
                    result = $signed(a) % $signed(b);
            end

            5'b10001: begin // REMU
                if (b == 0)
                    result = a;
                else
                    result = a % b;
            end

            default: result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule
