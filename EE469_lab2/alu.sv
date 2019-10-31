//64-bit Arithmetic Logic Unit
`timescale 1ns/10ps
module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
    input   logic [63:0] A, B;
    input   logic [2:0] cntrl;
    output  logic [63:0] result;
    output  logic       zero, overflow, carry_out, negative;

    //Signals for CarryOut from each full adder
    //Signals for Sum from each full adder
    logic [63:0] next_carry, sum_out;
    logic over_flag, not_cntrl2;

    //Assign statements for result, negative
    assign result = sum_out;
    assign negative = sum_out[63];
    //assign carry_out = next_carry[63];

    //bit 0 ALU
    nth_alu alu0    (.a(A[0]), .b(B[0]), .ctrl(cntrl), 
                     .out(sum_out[0]), .Cin(cntrl[0]), .Cout(next_carry[0]));
    
    genvar i;

    //Generate bits 1-62
    generate 
        for(i = 1; i < 63; i++) begin : alu_slice
            nth_alu alu_slice (.a(A[i]), .b(B[i]), .ctrl(cntrl),
                                .out(sum_out[i]), .Cin(next_carry[i - 1]),
                                .Cout(next_carry[i]));
        end
    endgenerate

    //bit 63 (Total, 64 bits) ALU
    //Also sets the carry out flag
    nth_alu alu63 (.a(A[63]), .b(B[63]), .ctrl(cntrl), .out(sum_out[63]),
                   .Cin(next_carry[62]), .Cout(next_carry[63]));


    //Carry Out flag only when in addition or subtraction
    not #0.05 not2 (not_cntrl2, cntrl[2]);
    and #0.05 coutf (carry_out, not_cntrl2, cntrl[1], next_carry[63]);

    //Overflow Flag only when in addition or subtraction
    xor #0.05 overflag (over_flag, next_carry[63], next_carry[62]);
    and #0.05 overf (overflow, not_cntrl2, cntrl[1], over_flag);

    //Zero flag
    zero_flag zerofl (.in(sum_out), .out(zero));
endmodule