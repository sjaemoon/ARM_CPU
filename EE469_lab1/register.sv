`timescale 1ns/10ps
module register #(parameter WIDTH=8) (in, enable, clk, out);
    output  logic   [WIDTH-1 : 0]   out;
    input   logic   [WIDTH-1 : 0]   in;
    input                           enable, clk;

    initial assert (WIDTH > 0);

    genvar i;

    generate
        for(i = 0; i < WIDTH; i++) begin : eachDFF
            D_FF_en nDff (.in(in[i]), .out(out[i]), .clk, .enable, .reset(1'b0));
        end
    endgenerate
endmodule

module register_testbench #(parameter WIDTH=8)();
    logic   [WIDTH - 1 : 0] in, out;
    logic                   enable, clk;

    register #(.WIDTH(8)) dut (.in, .out, .clk, .enable);

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        in <= 8'b0000_0000;
        enable <= 0;                    @(posedge clk);
                                        @(posedge clk);
                                        @(posedge clk);
                                        @(posedge clk);
        in <= 8'b1100_0101;             @(posedge clk);
                                        @(posedge clk);
        enable <= 1;                    @(posedge clk);
                                        @(posedge clk);
        enable <= 0;                    @(posedge clk);
                                        @(posedge clk);
                                        @(posedge clk);
                                        @(posedge clk);
        in <= 8'b0001_0001;             @(posedge clk);
                                        @(posedge clk);
                                        @(posedge clk);
        in <= 8'b0000_0001;             @(posedge clk);
                                        @(posedge clk);
        enable <= 1;                    @(posedge clk);
                                        @(posedge clk);
        enable <= 0;                    @(posedge clk);
                                        @(posedge clk);
                                        @(posedge clk);
                                        @(posedge clk);
        $stop;
    end
endmodule