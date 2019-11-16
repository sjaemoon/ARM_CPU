`timescale 1ns/10ps
module mux4_1 #(parameter WIDTH=8) (in, sel, out);

    input   logic [3:0][WIDTH-1:0]  in;
    input   logic [1:0]             sel;
    output  logic [WIDTH-1:0]       out;

    logic   [WIDTH-1:0] out0, out1, out2, out3;
    logic   notsel0, notsel1;


    not #0.05 NOTSEL0 (notsel0, sel[0]);
    not #0.05 NOTSEL1 (notsel1, sel[1]);
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : mask
            
            and #0.05 OUT0 (out0[i], notsel0, notsel1, in[0][i]);
            and #0.05 OUT1 (out1[i], sel[0], notsel1, in[1][i]);
            and #0.05 OUT2 (out2[i], notsel0, sel[1], in[2][i]);
            and #0.05 OUT3 (out3[i], sel[0], sel[1], in[3][i]);
            or #0.05 FINALOUT ( out[i], out0[i], out1[i], 
                                out2[i], out3[i]);
        end
    endgenerate
endmodule

module mux4_1_testbench();

    logic [3:0][3:0] in;
    logic [1:0] sel;
    logic [3:0]  out;

    mux4_1 #(.WIDTH(4)) dut (.in, .sel, .out);

    initial begin
        in[0] = 4'b0;
        in[1] = 4'b0;
        in[2] = 4'b0;
        in[3] = 4'b0;
        sel = 2'b00; #2;
        in[0] = 4'b0001;
        in[1] = 4'b0011;
        in[2] = 4'b0111;
        in[3] = 4'b1111; #2;
        sel = 2'b01; #2;
        sel = 2'b10; #2;
        sel = 2'b11; #2;
    end
endmodule
