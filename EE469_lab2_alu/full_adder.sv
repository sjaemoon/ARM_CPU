`timescale 1ns/10ps
module full_adder(a, b, Cin, Cout, sum);

    input   logic   a, b, Cin;
    output  logic   Cout, sum;

    logic and_cout_0, and_cout_1, xor_sum;

    xor #0.05 p (xor_sum, a, b);
    xor #0.05 sumOut (sum, xor_sum, Cin);
    and #0.05 r (and_cout_0, xor_sum, Cin);
    and #0.05 s (and_cout_1, a, b);
    or #0.05 CoutOut (Cout, and_cout_0, and_cout_1);

endmodule

module full_adder_testbench();
    logic a, b, Cin, Cout, sum;

    full_adder dut (.a, .b, .Cin, .Cout, .sum);

    integer i;

    initial begin
        for(i = 0; i < 8; i++) begin
            a = i[2]; b = i[1]; Cin = i[0]; #1;
        end
    end
endmodule