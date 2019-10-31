`timescale 1ns/10ps
module de4_16(in, en, out);

    input   logic [3:0] in;
    input   logic       en;
    output  logic [15:0] out;

    logic   [3:0] ctrl_out;

    de2_4 decoder_ctrl (.in(in[3:2]), .en, .out(ctrl_out));
    de2_4 decoder0 (.in(in[1:0]), .en(ctrl_out[0]), .out(out[3:0]));
    de2_4 decoder1 (.in(in[1:0]), .en(ctrl_out[1]), .out(out[7:4]));
    de2_4 decoder2 (.in(in[1:0]), .en(ctrl_out[2]), .out(out[11:8]));
    de2_4 decoder3 (.in(in[1:0]), .en(ctrl_out[3]), .out(out[15:12]));

endmodule

module de4_16_testbench();

    logic [3:0] in;
    logic       en;
    logic [15:0] out;

    de4_16 dut (.in, .en, .out);

    integer i;
    initial begin
        in = 4'b0000; en = 0; #30;
        en = 1;
        for(i = 0; i < 16; i++) begin
            in = i; #15;
        end
        en = 0; #15;
        for(i = 0; i < 16; i++) begin
            in = i; #15;
        end
    end
endmodule