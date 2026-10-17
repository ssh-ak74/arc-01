
module arc01_alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [3:0]  op,
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
            4'b0000: result = a + b;
            4'b0001: result = a - b;
            4'b0010: result = a & b;
            4'b0011: result = a | b;
            4'b0100: result = a ^ b;
            4'b0101: result = a << b[4:0];
            4'b0110: result = a >> b[4:0];
            4'b0111: result = $signed(a) >>> b[4:0];
            4'b1000: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            4'b1001: result = (a < b) ? 32'd1 : 32'd0;

            4'b1010: result = unsigned_product[31:0]; // MUL
            4'b1011: result = signed_product[63:32];   // MULH
            4'b1100: result = unsigned_product[63:32]; // MULHU
            4'b1101: result = mixed_product[63:32];    // MULHSU

            default: result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule
