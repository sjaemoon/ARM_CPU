`timescale 1ns/10ps
module processorstim();
    logic clk, reset;

    parameter ClockDelay = 50;

    processor dut (.*);

    initial begin
        clk <= 0;
        forever #(ClockDelay/2) clk <= ~clk;
    end

    int i;

    initial begin
        reset <= 1;     @(posedge clk);
        reset <= 0;     @(posedge clk);

        for(i = 0; i < 1200; i++) begin
            @(posedge clk);
        end
        $stop;
    end
endmodule