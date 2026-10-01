module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] op;
    logic [31:0] result;
    logic zero;

    arc01_alu alu (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );

    initial begin
        a = 32'd10;
        b = 32'd5;

        op = 4'b0000;
        #1;
        assert(result == 32'd15);

        op = 4'b0001;
        #1;
        assert(result == 32'd5);

        op = 4'b0010;
        #1;
        assert(result == (32'd10 & 32'd5));

        op = 4'b0011;
        #1;
        assert(result == (32'd10 | 32'd5));

        op = 4'b0100;
        #1;
        assert(result == (32'd10 ^ 32'd5));

        op = 4'b0101;
        a = 32'd1;
        b = 32'd4;
        #1;
        assert(result == 32'd16);

        op = 4'b0110;
        a = 32'd16;
        b = 32'd2;
        #1;
        assert(result == 32'd4);

        op = 4'b1000;
        a = 32'd5;
        b = 32'd10;
        #1;
        assert(result == 32'd1);

        op = 4'b1001;
        a = 32'd10;
        b = 32'd5;
        #1;
        assert(result == 32'd0);

        $display("ARC-01 ALU: PASS");
        $finish;
    end

endmodule