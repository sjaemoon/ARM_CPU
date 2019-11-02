`timescale 1ns/10ps
module nth_alu (a, b, ctrl, out, Cin, Cout);

    input   logic       a, b, Cin;
    input   logic [2:0] ctrl;
    output  logic       out, Cout;

    /*
    Wire signals
    Signal a does need to be modified
    Signal b goes through a 2 to 1 mux for
    subtract operation
    */
    logic adder_out, and_out, or_out, xor_out, b_not, adder_b;
    logic [1:0] mux2_sig;
    logic [7:0] mux8_sig;
    
    //Mux2 Input Signals
    assign mux2_sig[0] = b;
    assign mux2_sig[1] = b_not;

    /*
    Commands
    000 = b (0)
    001 = empty;
    010 = a + b (2) both takes adder out
    011 = a - b (3) both takes adder out
    100 = a & b (4)
    101 = a | b (5)
    110 = a ^ b (6)
    111 = empty
    */
    //Mux8 Input Signals
    assign mux8_sig[0] = b;
    assign mux8_sig[3:2] = {2{adder_out}};
    assign mux8_sig[4] = and_out;
    assign mux8_sig[5] = or_out;
    assign mux8_sig[6] = xor_out;

    //Instantiate 2 to 1 mux for B signal
    not #0.05 (b_not, b);
    mux2_1 #(.WIDTH(1)) mux2    (.in(mux2_sig), .sel(ctrl[0]), 
                                .out(adder_b));

    //Instantiate full_adder
    full_adder adder (.a, .b(adder_b), .Cin, .Cout, .sum(adder_out));

    //Create the 3 gates
    and #0.05 and_gate (and_out, a, b);
    or #0.05 or_gate (or_out, a, b);
    xor #0.05 xor_out0 (xor_out, a, b);

    //Instantiate 8 to 1 mux for ALU output
    mux8_1 #(.WIDTH(1)) mux8 (.in(mux8_sig), .sel(ctrl), .out(out));
endmodule

module nth_alu_testbench();
    logic       a, b, Cin;
    logic [2:0] ctrl;
    logic       out, Cout;

    nth_alu dut (.a, .b, .Cin, .ctrl, .out, .Cout);

    integer i;

    initial begin
        a = 0; b = 0; Cin = 0; ctrl = 3'b0; #2;
        a = 1; b = 0; 
        for(i = 0; i < 8; i++) begin // check all outputs
            ctrl = i; 
            if(ctrl[0] == 1)
                Cin = 1;
            else
                Cin = 0;
            #2;
        end

        a = 1; b = 1;
        for(i = 0; i < 8; i++) begin // check all outputs
            ctrl = i; 
            if(ctrl[0] == 1)
                Cin = 1;
            else
                Cin = 0;
            #2;
        end

        a = 0; b = 0;
        for(i = 0; i < 8; i++) begin // check all outputs
            ctrl = i; 
            if(ctrl[0] == 1)
                Cin = 1;
            else
                Cin = 0;
            #2;
        end

        a = 0; b = 1;
        for(i = 0; i < 8; i++) begin // check all outputs
            ctrl = i; 
            if(ctrl[0] == 1)
                Cin = 1;
            else
                Cin = 0;
            #2;
        end
    end
endmodule