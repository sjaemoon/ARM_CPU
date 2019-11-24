`timescale 1ns/10ps
module pipelinedstim();
    logic clk, reset;

    parameter ClockDelay = 500;

    processor_pipelined dut (.*);

    initial begin
        clk <= 0;
        forever #(ClockDelay/2) clk <= ~clk;
    end

    int i;

    initial begin
        reset <= 1;         @(posedge clk);
        reset <= 0; i = 0;  @(posedge clk);

        for(i = 1; i < 700; i++) begin
            @(posedge clk);
        end

        $stop;
    end
endmodule