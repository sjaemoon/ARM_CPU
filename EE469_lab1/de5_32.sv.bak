`timescale 1ns/10ps
module de_5_32(in, en, out);

    input   logic [4:0] in;
    input   logic       en;
    output  logic [31:0] out;

    logic [1:0] ctrl_out;

    de_1_2  decoder_ctrl (.in(in[4]), .en, .out(ctrl_out));
    de_4_16 decoder0 (.in(in[3:0]), .en(ctrl_out[0]), .out(out[15:0]));
    de_4_16 decoder1 (.in(in[3:0]), .en(ctrl_out[1]), .out(out[31:16]));

endmodule

module de_5_32_testbench();

    logic [4:0] in;
    logic       en;
    logic [31:0] out;

    de_5_32 dut (.in, .en, .out);

    integer i;
    initial begin
        in = 5'b00000; en = 0; #30;
        en = 1;
        for(i = 0; i < 32; i++) begin
            in = i; #15;
        end
        en = 0; #15;
        for(i = 0; i < 32; i++) begin
            in = i; #15;
        end
    end
endmodule