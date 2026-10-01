module arc01_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [1:0] op;
    logic [31:0] result;

    arc01_alu alu (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    initial begin
        a = 32'd10;
        b = 32'd5;

        op = 2'b00;
        #1;
        $display("ADD: %0d", result);
        assert(result == 32'd15);

        op = 2'b01;
        #1;
        $display("SUB: %0d", result);
        assert(result == 32'd5);

        op = 2'b10;
        #1;
        $display("AND: %h", result);
        assert(result == (32'd10 & 32'd5));

        op = 2'b11;
        #1;
        $display("OR: %h", result);
        assert(result == (32'd10 | 32'd5));

        $display("ARC-01 ALU PASS");
        $finish;
    end

endmodule
