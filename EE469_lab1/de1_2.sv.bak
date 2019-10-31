`timescale 1ns/10ps
module de_1_2 (in, en, out);
    input   logic           in, en;
    output  logic   [1:0]   out;

    //assign out[0] = ~in & en;
    //assign out[1] = in & en;

    logic in_inv;

    not #0.05 inv (in_inv, in);
    and #0.05 out0 (out[0], in_inv, en);
    and #0.05 out1 (out[1], in, en);
    
endmodule

module de_1_2_testbench();
    logic       in, en;
    logic [1:0] out;

    de_1_2  dut (.in, .out, .en);

    initial begin
        en = 0; in = 0;     #10;
                    in = 1; #10;
        en = 1; in = 0;     #10;
                    in = 1; #10;
    end
endmodule