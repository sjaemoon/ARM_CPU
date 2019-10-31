//Checks if a given input is 0. 64 BITS ONLY

`timescale 1ns/10ps
module zero_flag (in, out);
    input   logic [63:0] in;
    output  logic        out;

    //Level 0 OR gate wires
    logic [15:0] l0;

    /*l0_0, l0_1, l0_2, l0_3,
                l0_4, l0_5, l0_6, l0_7,
                l0_8, l0_9, l0_10, l0_11,
                l0_12, l0_13, l0_14, l0_15;
    */

    //Level 1 OR gate wires
    logic [3:0] l1;
    //l1_0, l1_1, l1_2, l1_3;

    //Level 2 OR gate wires
    logic l2;

    genvar i;

    generate
        for(i = 0; i < 16; i++) begin : or_gates_l0
            or #0.05 or_gate_0 (l0[i], in[4*i], in[4*i + 1],
                                in[4*i + 2], in[4*i + 3]);
        end

        for(i = 0; i < 4; i++) begin : or_gates_l1
            or #0.05 or_gate_1 (l1[i], l0[4*i], l0[4*i + 1],
                                l0[4*i + 2], l0[4*i + 3]);
        end
    endgenerate

    or #0.05 or_gate_2 (l2, l1[0], l1[1], l1[2], l1[3]);

    //Invert signal from or_gate_2
    not #0.05 invr (out, l2);
    //assign out = l2;
endmodule

module zero_flag_testbench();

    logic [63:0] in;
    logic out;

    zero_flag dut (.in, .out);

    initial begin
        in = 64'd0; #2; #2;
        in = 64'd12; #2; #2;
    end
endmodule
